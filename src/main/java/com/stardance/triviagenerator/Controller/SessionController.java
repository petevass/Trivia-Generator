package com.stardance.triviagenerator.Controller;

import com.stardance.triviagenerator.Data.QuestionAPIURLGenerator;
import com.stardance.triviagenerator.Data.SessionRepository;
import com.stardance.triviagenerator.Model.ApplicationUser;
import com.stardance.triviagenerator.Model.RequestRecords.GetQuestionsRequest;
import com.stardance.triviagenerator.Model.ResponseRecords.GetQuestionsResponse;
import com.stardance.triviagenerator.Model.ResponseRecords.StartSessionResponse;
import com.stardance.triviagenerator.Model.Session;
import lombok.AllArgsConstructor;
import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/sesssion")
@AllArgsConstructor
public class SessionController {

    private final SessionRepository sessionRepository;


    @GetMapping("/start")
    @PreAuthorize("hasRole('USER')")
    public StartSessionResponse startSession(@AuthenticationPrincipal ApplicationUser user) {
        Session s = new Session();
        s.setUserId(user.getId());
        sessionRepository.save(s);

        return  new StartSessionResponse(s.getId());
    }

    @PostMapping("/get_questions")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<?> getQuestions(@AuthenticationPrincipal ApplicationUser user, @RequestBody GetQuestionsRequest getQuestionsRequest) throws URISyntaxException, IOException, InterruptedException {
        Session s = sessionRepository.findById(getQuestionsRequest.sessionId()).orElse(null);

        if(s == null){

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Session ID Invalid");
        }

        String url = new QuestionAPIURLGenerator(getQuestionsRequest.category(), getQuestionsRequest.difficulty(), getQuestionsRequest.type(), getQuestionsRequest.amount()).generateURL();

        HttpClient client = HttpClient.newHttpClient();
        HttpRequest req = HttpRequest.newBuilder()
                .GET()
                .uri(new URI(url))
                .build();
        HttpResponse<String>resp = client.send(req, HttpResponse.BodyHandlers.ofString());



        return ResponseEntity.status(200).body(resp.body());
    }

}
