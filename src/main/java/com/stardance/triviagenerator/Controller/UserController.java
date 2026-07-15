package com.stardance.triviagenerator.Controller;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/protected")
public class UserController {

    @GetMapping
    public String protect(Authentication authentication) {
        return "protected";
    }

}
