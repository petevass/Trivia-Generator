package com.stardance.triviagenerator.Model.RequestRecords;

public record CheckAnswerRequest(String token, String sessionId, String answer) {
}
