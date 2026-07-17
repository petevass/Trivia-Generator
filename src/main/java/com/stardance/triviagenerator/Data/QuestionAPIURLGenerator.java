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

@AllArgsConstructor
@Data
public class QuestionAPIURLGenerator {

    String category;
    String difficulty;
    String type;
    int amount;


    public String generateURL(){
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

    public LinkedHashMap<Enum, Integer> parametersToEnums(String category, String difficulty, String type){

        LinkedHashMap<Enum, Integer> enums = new LinkedHashMap<>();

        if(category.equals("any")){
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
        }else if(type.equals("t-f")) {
            enums.put(Type.TRUE_FALSE, 40);
        }else if(type.equals("any")){
            enums.put(Type.ANY, 41);
        }else if(type.equals("dne")){
            enums.put(Type.DNE, 42);
        }


        return enums;
    }

}
