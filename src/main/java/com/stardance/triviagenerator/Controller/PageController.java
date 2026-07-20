package com.stardance.triviagenerator.Controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String index() {
        return "home";
    }

    @GetMapping("/pages/login")
    public String login() {
        return "login";
    }

    @GetMapping("/pages/profile")

    public String profile() {
        return "profile";
    }

    @GetMapping("/pages/session/setup")

    public String setup() {
        return "session-setup";
    }

    @GetMapping("/pages/session/play")
    public String play(){
        return "play";
    }

    @GetMapping("/pages/leaderboard")

    public String leaderboard(){
        return "leaderboard";
    }
}
