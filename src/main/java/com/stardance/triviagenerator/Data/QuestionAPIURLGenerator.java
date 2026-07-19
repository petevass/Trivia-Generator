package com.stardance.triviagenerator.Data;

import com.stardance.triviagenerator.Model.SessionTypes.Category;
import com.stardance.triviagenerator.Model.SessionTypes.Difficulty;
import com.stardance.triviagenerator.Model.SessionTypes.Type;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;


@Data
public class QuestionAPIURLGenerator {




    public String generateURL(String category, String difficulty, String type, int amount){
        String url = "https://opentdb.com/api.php?";
        LinkedHashMap<Enum, Integer> params = parametersToEnums(category, difficulty, type);
        ArrayList<Map.Entry<Enum,Integer>> keys = new ArrayList<>(params.entrySet());
        url+="amount="+amount+"&";
        if(keys.get(0).getKey() == Category.DNE){
            return "Not a valid category";
        }
        if(keys.get(1).getKey() == Difficulty.DNE){
            return "Not a valid difficulty";
        }
        if(keys.get(2).getKey() == Type.DNE){
            return "Not a valid type";
        }

        url+="category="+keys.get(0).getValue()+"&";
        url+="difficulty="+keys.get(1).getValue()+"&";
        url+="type="+keys.get(2).getValue();

        return url;

    }


    public String generateURL(Enum category, Enum difficulty, Enum type, Integer amount){
        String url = "https://opentdb.com/api.php?";
        int categoryInt = categoryEnumToInteger(category);
        ArrayList<String> params = enumsToString(difficulty, type);

        url+="amount="+amount+"&";

        if(category!= Category.DNE && category != Category.ANY) {
            url += "category=" + categoryInt + "&";
        }

        if(difficulty!= Difficulty.DNE && difficulty != Difficulty.ANY) {
            url += "difficulty=" + params.get(0)+ "&";
        }

        if(type != Type.ANY && type != Type.DNE) {
            url += "type=" + params.get(params.size()-1);
        }

        return url;

    }

    public LinkedHashMap<Enum, Integer> parametersToEnums(String category, String difficulty, String type){

        LinkedHashMap<Enum, Integer> enums = new LinkedHashMap<>();

        if(category.equals("any") ){
            enums.put(Category.ANY, 0);

        }else if(category.equals("general knowledge")){
            enums.put(Category.GENERAL_KNOWLEDGE, 9);
        }else if(category.equals("books")){
            enums.put(Category.BOOKS, 10);
        }else if(category.equals("film")){
            enums.put(Category.FILM, 11);
        }else if(category.equals("music")){
            enums.put(Category.MUSIC, 12) ;
        }else if(category.equals("musicals and theaters")){
            enums.put(Category.MUSICALSandTHEATERS, 13);
        }else if(category.equals("tv")){
            enums.put(Category.TV, 14);
        }else if(category.equals("video games")){
            enums.put(Category.VIDEO_GAMES, 15);
        }else if(category.equals("board games")){
            enums.put(Category.BOARD_GAMES, 16);
        }else if(category.equals("science and nature")){
            enums.put(Category.SCIENCEandNATURE, 17);
        }else if(category.equals("science:computers")){
            enums.put(Category.SCIENCE_COMPUTERS, 18);
        }else if(category.equals("science:math")){
            enums.put(Category.SCIENCE_MATH, 19);
        }else if(category.equals("mythology")){
            enums.put(Category.MYTHOLOGY, 20);
        }else if(category.equals("sports")){
            enums.put(Category.SPORTS, 21);
        }else if(category.equals("history")){
            enums.put(Category.HISTORY, 22);
        }else if(category.equals("geography")){
            enums.put(Category.GEOGRAPHY, 23);
        }else if(category.equals("politics")){
            enums.put(Category.POLITICS, 24);
        }else if(category.equals("art")){
            enums.put(Category.ART, 25);
        }else if(category.equals("celebrities")){
            enums.put(Category.CELEBRITIES, 26);
        }else if(category.equals("animals")){
            enums.put(Category.ANIMALS, 27);
        }else if(category.equals("vehicles")){
            enums.put(Category.VEHICLES, 28);
        }else if(category.equals("comics")){
            enums.put(Category.COMICS, 29);
        }else if(category.equals("gadgets")){
            enums.put(Category.GADGETS, 30);
        }else if(category.equals("anime and manga")){
            enums.put(Category.ANIMEandMANGA, 31);
        }else if(category.equals("cartoons and animation")){
            enums.put(Category.CARTOONSandANIMATION, 32);
        }else{
            enums.put(Category.DNE, 33);
        }

        if(difficulty.equals("easy")){
            enums.put(Difficulty.EASY, 34);
        }else if(difficulty.equals("medium")){
            enums.put(Difficulty.MEDIUM, 35);
        }else if(difficulty.equals("hard")){
            enums.put(Difficulty.HARD, 36);
        }else if(difficulty.equals("any")){
            enums.put(Difficulty.ANY, 37);
        }else{
            enums.put(Difficulty.DNE, 38);
        }

        if(type.equals("multiple")){
            enums.put(Type.MULTI_CHOICE, 39);
        }else if(type.equals("boolean")) {
            enums.put(Type.TRUE_FALSE, 40);
        }else if(type.equals("any")){
            enums.put(Type.ANY, 41);
        }else {
            enums.put(Type.DNE, 42);
        }


        return enums;
    }

    public int categoryEnumToInteger(Enum category){
        if(category== Category.ANY){
            return 0;

        }else if(category==Category.GENERAL_KNOWLEDGE){
            return 9;
        }else if(category==Category.BOOKS){
            return 10;
        }else if(category==Category.FILM){
            return 11;
        }else if(category==Category.MUSIC){
            return 12;
        }else if(category==Category.MUSICALSandTHEATERS){
            return 13;
        }else if(category==Category.TV){
            return 14;
        }else if(category==Category.VIDEO_GAMES){
            return 15;
        }else if(category==Category.BOARD_GAMES){
            return 16;
        }else if(category==Category.SCIENCEandNATURE){
            return 17;
        }else if(category==Category.SCIENCE_COMPUTERS){
            return 18;
        }else if(category==Category.SCIENCE_MATH){
            return 19;
        }else if(category==Category.MYTHOLOGY){
            return 20;
        }else if(category==Category.SPORTS){
            return 21;
        }else if(category==Category.HISTORY){
            return 22;
        }else if(category==Category.GEOGRAPHY){
            return 23;
        }else if(category==Category.POLITICS){
            return 24;
        }else if(category==Category.ART){
            return 25;
        }else if(category==Category.CELEBRITIES){
            return 26;
        }else if(category==Category.ANIMALS){
            return 27;
        }else if(category==Category.VEHICLES){
            return 28;
        }else if(category==Category.COMICS){
            return 29;
        }else if(category==Category.GADGETS){
            return 30;
        }else if(category== Category.ANIMEandMANGA){
            return 31;
        }else if(category== Category.CARTOONSandANIMATION){
            return 32;
        }else{
            return 33;
        }
    }

    public ArrayList<String> enumsToString(Enum difficulty, Enum type){
        ArrayList<String> enums = new ArrayList<>();
        if(difficulty == Difficulty.EASY){
            enums.add("easy");
        }else if(difficulty == Difficulty.MEDIUM){
            enums.add("medium");
        }else if(difficulty == Difficulty.HARD){
            enums.add("hard");
        }

        if(type == Type.MULTI_CHOICE){
            enums.add("multiple");
        }else if(type == Type.TRUE_FALSE){
            enums.add("boolean");
        }

        return enums;
    }

}
