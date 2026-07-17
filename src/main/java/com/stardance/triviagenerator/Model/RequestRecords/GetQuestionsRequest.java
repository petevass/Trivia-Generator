package com.stardance.triviagenerator.Model.RequestRecords;

public record GetQuestionsRequest(String sessionId, String category, String difficulty, String type, int amount) {
}
