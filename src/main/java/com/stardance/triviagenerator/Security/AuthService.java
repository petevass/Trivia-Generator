package com.stardance.triviagenerator.Security;

import com.stardance.triviagenerator.Data.UserRepository;
import com.stardance.triviagenerator.Model.*;
import com.stardance.triviagenerator.Model.RequestRecords.AuthRequest;
import com.stardance.triviagenerator.Model.ResponseRecords.AuthResponse;
import com.stardance.triviagenerator.Model.RequestRecords.RegisterRequest;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JWTService jwtService;
    private final AuthenticationManager authenticationManager;

    public AuthResponse register(RegisterRequest request) {



        ApplicationUser applicationUser = ApplicationUser.builder()
                .username(request.username())
                .password(passwordEncoder.encode(request.password()))
                .role(Role.USER)
                .totalTriviaQuestionsAnswered(0)
                .totalTriviaQuestionsCorrectlyAnswered(0)
                .build();
        userRepository.save(applicationUser);
        return new AuthResponse(jwtService.generateToken(applicationUser));

    }

    public AuthResponse authenticate(AuthRequest authRequest) {
        ApplicationUser user = userRepository.findByUsername(authRequest.username())
                .orElseThrow();
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(user.getUsername(), authRequest.password())
        );

        HashMap<String, Object> claims = new HashMap<>();
        claims.put("role", user.getRole());
        return new AuthResponse(jwtService.generateToken(claims, user));

    }



}
