package com.stardance.triviagenerator.Controller;

import com.stardance.triviagenerator.Model.ApplicationUser;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/protected")
public class UserController {

    @GetMapping
    @PreAuthorize("hasRole('OWNER')")
    public String protect(@AuthenticationPrincipal ApplicationUser user) {
        return "protected for "+user.getRole();
    }

}
