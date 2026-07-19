package com.stardance.triviagenerator.Model.ResponseRecords;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class CheckAnswerResponse{
        String sessionId;
        boolean wasCorrect;
        String correctAnswer;
        String nextQuestion;
        ArrayList<String> options;

}
