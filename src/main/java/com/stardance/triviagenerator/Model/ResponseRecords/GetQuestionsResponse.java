package com.stardance.triviagenerator.Model.ResponseRecords;

import java.util.ArrayList;

public record GetQuestionsResponse(String sessionId, String firstQuestion, ArrayList<String> options) {
}
