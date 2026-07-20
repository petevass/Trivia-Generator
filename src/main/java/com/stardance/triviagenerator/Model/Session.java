package com.stardance.triviagenerator.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name="sessions")
public class Session {

    @Id
    @Column(unique = true, nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    String Id;

    @Column(unique = true, nullable = false)
    String userId;

    @Column(nullable = false)
    int amount;

    @Column(nullable = false)
    int correctQuestions;

    @Column(nullable = false)
    Enum category;


    @Column(nullable = false)
    Enum difficulty;


    @Column(nullable = false)
    Enum type;

    @Column(nullable = false)
    Question currentQuestion;

    @CollectionTable(
            name = "questions",
            joinColumns = @JoinColumn(name = "trivia_id")
    )
    @ElementCollection(fetch = FetchType.LAZY)
    private List<Question> questions = new ArrayList<>();
}
