package com.stardance.triviagenerator.Controller;

import com.stardance.triviagenerator.Data.QuestionAPIURLGenerator;
import com.stardance.triviagenerator.Data.SessionRepository;
import com.stardance.triviagenerator.Data.UserRepository;
import com.stardance.triviagenerator.Data.UserService;
import com.stardance.triviagenerator.Model.ApplicationUser;

import com.stardance.triviagenerator.Model.Question;
import com.stardance.triviagenerator.Model.RequestRecords.CheckAnswerRequest;
import com.stardance.triviagenerator.Model.RequestRecords.GetQuestionsRequest;
import com.stardance.triviagenerator.Model.RequestRecords.StartSessionRequest;
import com.stardance.triviagenerator.Model.ResponseRecords.CheckAnswerResponse;
import com.stardance.triviagenerator.Model.ResponseRecords.EndingResponse;
import com.stardance.triviagenerator.Model.ResponseRecords.GetQuestionsResponse;
import com.stardance.triviagenerator.Model.ResponseRecords.StartSessionResponse;
import com.stardance.triviagenerator.Model.Session;
import com.stardance.triviagenerator.Model.SessionTypes.Category;
import com.stardance.triviagenerator.Model.SessionTypes.Difficulty;
import com.stardance.triviagenerator.Model.SessionTypes.Type;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.node.ArrayNode;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/session")
@AllArgsConstructor
public class SessionController {

    private final SessionRepository sessionRepository;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private UserService userService;
    @Autowired
    private UserRepository userRepository;


    @PostMapping("/start")
    public ResponseEntity<?> startSession(@AuthenticationPrincipal ApplicationUser user, @RequestBody StartSessionRequest getQuestionsRequest) {
        Session s = new Session();

        LinkedHashMap<Enum, Integer> params = new QuestionAPIURLGenerator().parametersToEnums(getQuestionsRequest.category(), getQuestionsRequest.difficulty(), getQuestionsRequest.type());
        ArrayList<Map.Entry<Enum, Integer>>  keys = new ArrayList<>(params.entrySet());


        if(keys.get(0).getKey() == Category.DNE){
            return ResponseEntity.status(401).body("Not a valid category");
        }
        if(keys.get(1).getKey() == Difficulty.DNE){
            return ResponseEntity.status(401).body("Not a valid difficulty");
        }
        if(keys.get(2).getKey() == Type.DNE){
            return ResponseEntity.status(401).body("Not a valid type");
        }

        if(sessionRepository.existsByUserId(user.getId())){
            return ResponseEntity.status(401).body("User already has a session open");
        }

        s.setUserId(user.getId());
        s.setCategory(keys.get(0).getKey());
        s.setDifficulty(keys.get(1).getKey());
        s.setType(keys.get(2).getKey());
        s.setAmount(getQuestionsRequest.amount());
        s.setCurrentQuestion(new Question());
        sessionRepository.save(s);

        return  ResponseEntity.ok(new StartSessionResponse(s.getId()));
    }

    @PostMapping("/get_questions")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> getQuestions(@AuthenticationPrincipal ApplicationUser user, @RequestBody GetQuestionsRequest getQuestionsRequest) throws URISyntaxException, IOException, InterruptedException {
        Session s = sessionRepository.findById(getQuestionsRequest.sessionId()).orElse(null);

        if(s == null){

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Session ID Invalid");
        }

        String url = new QuestionAPIURLGenerator().generateURL(s.getCategory(),s.getDifficulty(), s.getType(), s.getAmount());

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                .GET()
                .uri(new URI(url))
                .build();
        HttpResponse<String>resp = client.send(req, HttpResponse.BodyHandlers.ofString());

        JsonNode triviaResp = objectMapper.readTree(resp.body());
        JsonNode triviaRes = triviaResp.get("results");
        ArrayNode trivia =triviaRes.asArray();
        ArrayList<Question> questions = new ArrayList<>();
        for(JsonNode i: trivia){

                Question mcq = new Question();
                mcq.setAnswer(i.get("correct_answer").asString());
                mcq.setQuestion(i.get("question").asString());
                ArrayList<String> incorrectAnswers = new ArrayList<>();
                ArrayNode choices = i.get("incorrect_answers").asArray();
                for(JsonNode j: choices){

                    incorrectAnswers.add(j.asString());

                }
                mcq.setIncorrectAnswers(incorrectAnswers);
                questions.add(mcq);

        }

        s.setQuestions(questions);
        s.setCurrentQuestion(questions.get(0));
        sessionRepository.save(s);
        ArrayList<String> options = s.getCurrentQuestion().getIncorrectAnswers();
        options.add(s.getCurrentQuestion().getAnswer());
        Collections.shuffle(options);

        return ResponseEntity.status(200).body(new GetQuestionsResponse(s.getId(),s.getCurrentQuestion().getQuestion(), options));
    }

    @PostMapping("/check_answer")
    public ResponseEntity<?> checkAnswer(@AuthenticationPrincipal ApplicationUser user,  @RequestBody CheckAnswerRequest checkAnswerRequest) {

        Session s = sessionRepository.findById(checkAnswerRequest.sessionId()).orElse(null);
        if(s == null){
            return ResponseEntity.status(401).body("Session ID is Invalid");
        }

        CheckAnswerResponse resp = new CheckAnswerResponse();
            resp.setSessionId(s.getId());
            resp.setWasCorrect(false);
            resp.setCorrectAnswer(s.getCurrentQuestion().getAnswer());

        if(checkAnswerRequest.answer().equalsIgnoreCase(s.getCurrentQuestion().getAnswer())){
            resp.setWasCorrect(true);
            int x =s.getCorrectQuestions()+1;
            s.setCorrectQuestions(x);
        }

        int index = s.getQuestions().indexOf(s.getCurrentQuestion());
        index++;
        if(index < s.getQuestions().size()) {
            s.setCurrentQuestion(s.getQuestions().get(index));
        }else{
            String message = "Congratulations "+user.getUsername()+"! You have finished all of your questions in this session. Session Over";
            sessionRepository.delete(s);
            return ResponseEntity.status(200).body(new EndingResponse(message, s.getCorrectQuestions(), s.getAmount()));
        }

        ArrayList<String> options = s.getCurrentQuestion().getIncorrectAnswers();
        options.add(s.getCurrentQuestion().getAnswer());
        Collections.shuffle(options);
        resp.setOptions(options);
        resp.setNextQuestion(s.getCurrentQuestion().getQuestion());

        return ResponseEntity.status(200).body(resp);
    }

    @PostMapping("/end_session")
    public ResponseEntity<?> endSession(@AuthenticationPrincipal ApplicationUser user){
        Session s = sessionRepository.findById(user.getId()).orElse(null);
        if(s == null){
            return ResponseEntity.status(401).body("User does not have a session open");
        }
        ApplicationUser u = userService.loadById(s.getUserId());

        int questionsAnswered = s.getAmount()+u.getTotalTriviaQuestionsAnswered();
        int correct = s.getCorrectQuestions()+ u.getTotalTriviaQuestionsCorrectlyAnswered();
        u.setTotalTriviaQuestionsAnswered(questionsAnswered);
        u.setTotalTriviaQuestionsCorrectlyAnswered(correct);
        sessionRepository.delete(s);
        userRepository.save(u);
        return ResponseEntity.status(200).body("session has been successfully ended");
    }

}
