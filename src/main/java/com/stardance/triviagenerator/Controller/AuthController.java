package com.stardance.triviagenerator.Controller;

import com.stardance.triviagenerator.Data.UserService;
import com.stardance.triviagenerator.Model.RequestRecords.AuthRequest;
import com.stardance.triviagenerator.Model.ResponseRecords.AuthResponse;
import com.stardance.triviagenerator.Model.RequestRecords.RegisterRequest;
import com.stardance.triviagenerator.Security.AuthService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@AllArgsConstructor
public class AuthController {

private final AuthService authService;
private final UserService userService;

@PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest registerRequest){
        if(userService.doesUserExistByUsername(registerRequest.username())){
            return ResponseEntity.status(403).body(new AuthResponse("Username is Already in User"));
        }

        return  ResponseEntity.ok(authService.register(registerRequest));

    }

    @PostMapping("/authenticate")
    public AuthResponse authenticate(@RequestBody AuthRequest authRequest){
    return  authService.authenticate(authRequest);
    }

}
