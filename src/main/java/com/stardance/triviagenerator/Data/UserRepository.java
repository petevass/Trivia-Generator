package com.stardance.triviagenerator.Data;


import com.stardance.triviagenerator.Model.ApplicationUser;
import com.stardance.triviagenerator.Model.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<ApplicationUser, String> {
    ApplicationUser getByUsername(String username);
    List<ApplicationUser> getAllByRole(Role role);
}
