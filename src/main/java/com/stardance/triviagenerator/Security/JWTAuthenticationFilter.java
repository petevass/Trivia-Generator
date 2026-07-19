package com.stardance.triviagenerator.Security;

import com.stardance.triviagenerator.Data.UserRepository;
import com.stardance.triviagenerator.Data.UserService;
import com.stardance.triviagenerator.Model.ApplicationUser;
import com.stardance.triviagenerator.Model.Role;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

@Component
@AllArgsConstructor
public class JWTAuthenticationFilter extends OncePerRequestFilter {

    private final JWTService jwtService;
    private final UserService userService;



    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        System.out.println("AUTH HEADER = " + request.getHeader("Authorization"));

        final String authHeader = request.getHeader("Authorization");
        if(authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        final String jwt = authHeader.substring(7);
        final String id = jwtService.extractId(jwt);

        if(id !=null && SecurityContextHolder.getContext().getAuthentication() == null) {
            ApplicationUser user = userService.loadById(id);
            if(jwtService.isTokenValid(jwt, user)) {

                Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
                grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_USER"));

                if(user.getRole().equals(Role.ADMIN)) {
                    grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                }
                if(user.getRole().equals(Role.OWNER)) {
                    grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
                    grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_OWNER"));
                }

                var token = new UsernamePasswordAuthenticationToken(user, null, grantedAuthorities);
                token.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(token);
            }
        }
        filterChain.doFilter(request, response);
    }
}
