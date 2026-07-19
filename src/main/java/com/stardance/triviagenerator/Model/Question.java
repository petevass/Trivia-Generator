package com.stardance.triviagenerator.Model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Embeddable
public class Question {

    String question;
    String answer;
    ArrayList<String> incorrectAnswers;
}
