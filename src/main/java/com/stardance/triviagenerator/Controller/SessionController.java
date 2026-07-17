package com.stardance.triviagenerator.Controller;

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

import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/sesssion")
@AllArgsConstructor
public class SessionController {

    private final SessionRepository sessionRepository;
    private final String url = "https://opentdb.com/api.php";

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
    public ResponseEntity<?> getQuestions(@AuthenticationPrincipal ApplicationUser user, @RequestBody GetQuestionsRequest getQuestionsRequest) {
        Session s = sessionRepository.findById(getQuestionsRequest.sessionId()).orElse(null);

        if(s == null){

            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Session ID Invalid");
        }

        ArrayList<String> parameters = new ArrayList<>();



        HttpClient client = HttpClient.newHttpClient();

        return null;
    }

}
