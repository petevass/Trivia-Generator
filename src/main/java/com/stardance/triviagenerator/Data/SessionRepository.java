package com.stardance.triviagenerator.Data;

import com.stardance.triviagenerator.Model.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SessionRepository extends JpaRepository<Session, String> {
    Session findByUserId(String userId);

}
