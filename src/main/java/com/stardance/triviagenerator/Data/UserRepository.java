package com.stardance.triviagenerator.Data;


import com.stardance.triviagenerator.Model.ApplicationUser;
import com.stardance.triviagenerator.Model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<ApplicationUser, String> {
    Optional<ApplicationUser> findByUsername(String username);
    List<ApplicationUser> getAllByRole(Role role);
    boolean existsByUsername(String username);
}
