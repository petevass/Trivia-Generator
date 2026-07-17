package com.stardance.triviagenerator.Data;

import com.stardance.triviagenerator.Model.ApplicationUser;
import com.stardance.triviagenerator.Model.Role;
import lombok.AllArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor

public class UserService implements UserDetailsService {

    private final UserRepository userRepository;

    public boolean doesUserExistByUsername(String username){
        return userRepository.existsByUsername(username);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username)
                .orElseThrow(()->new UsernameNotFoundException("Username Not Found"));
    }
    public ApplicationUser loadById(String id){
        return userRepository.findById(id).orElseThrow(()->new UsernameNotFoundException("Username Not Found"));
    }

    public List<ApplicationUser> findAllByRole(Role role){
        return userRepository.getAllByRole(role);
    }

    public List<ApplicationUser> findAll(){
        return userRepository.findAll();
    }
}
