package com.stardance.triviagenerator.Model.ResponseRecords;

public record CheckAnswerResponse(String sessionId, boolean wasCorrect, String nextQuestion) {
}
