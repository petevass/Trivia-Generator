package com.stardance.triviagenerator.Model;

import com.stardance.triviagenerator.Model.SessionTypes.Category;
import com.stardance.triviagenerator.Model.SessionTypes.Difficulty;
import com.stardance.triviagenerator.Model.SessionTypes.Type;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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

    @Column(unique = true)
    String userId;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    Category category;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Difficulty difficulty;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Type type;

    @Column(nullable = false)
    Question currentQuestion;

    @CollectionTable(
            name = "questions",
            joinColumns = @JoinColumn(name = "trivia_id")
    )
    @ElementCollection(fetch = FetchType.LAZY)
    private List<Question> questions = new ArrayList<>();
}
