package com.stardance.triviagenerator.Controller;

import com.stardance.triviagenerator.Data.UserService;
import com.stardance.triviagenerator.Model.ApplicationUser;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.List;

@RestController
@RequestMapping("/api")
public class UserInformationController {

    private final UserService userService;

    public UserInformationController(UserService userService) {
        this.userService = userService;
    }

    record UserProfileResponse(String username, int totalAnswered, int totalCorrect){}
    record LeaderboardEntry(String username, int totalAnswered, int totalCorrect){}


    @GetMapping("/user/me")
    public UserProfileResponse me(@AuthenticationPrincipal ApplicationUser user){
        return new UserProfileResponse(user.getUsername(), user.getTotalTriviaQuestionsAnswered(), user.getTotalTriviaQuestionsCorrectlyAnswered());
    }

    @GetMapping("/leaderboard/total")
    public List<LeaderboardEntry> leaderboard(@AuthenticationPrincipal ApplicationUser user){
        return userService.findAll().stream()
                .sorted(Comparator.comparingInt(ApplicationUser::getTotalTriviaQuestionsAnswered).reversed())
                .limit(10)
                .map(u-> new LeaderboardEntry(
                        u.getUsername(),
                        u.getTotalTriviaQuestionsAnswered(),
                        u.getTotalTriviaQuestionsCorrectlyAnswered()
                )).toList();
    }

    @GetMapping("/leaderboard/correct")
    public List<LeaderboardEntry> leaderboardCorrect(){
        return userService.findAll().stream()
                .sorted(Comparator.comparingInt(ApplicationUser::getTotalTriviaQuestionsCorrectlyAnswered).reversed())
                .limit(10)
                .map(u-> new LeaderboardEntry(
                        u.getUsername(),
                        u.getTotalTriviaQuestionsAnswered(),
                        u.getTotalTriviaQuestionsCorrectlyAnswered()
                )).toList();
    }
}
