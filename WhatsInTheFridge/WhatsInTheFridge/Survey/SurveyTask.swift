//
//  SurveyTask.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/5/21.
//

import UIKit
import ResearchKit

private func createTextChoiceLIst(listString:[String]) -> [ORKTextChoice]{
    var textChoices: [ORKTextChoice] = [ORKTextChoice]()
    let count = 0...listString.count-1
    for number in count {
        textChoices.append(ORKTextChoice(text: listString[number], value: number as NSNumber))
    }
    return textChoices
}

public var SurveyTask: ORKOrderedTask {
    var steps = [ORKStep]()
    
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "Plan the meal"
    instructionStep.text = "Your satisfaction is important to us, let us get some preferences from you so we can provide you with better suggestion :)"
    steps += [instructionStep]
    
    // create meal type choices
    let mealTypes: [String] =  ["main course", "side dish", "desert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    let mealTypesQuestionStepTitle = "What type of meal are you planning?"
    let mealTypesTextChoices: [ORKTextChoice] = createTextChoiceLIst(listString: mealTypes)
    let mealTypeAnswerFormat1: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: mealTypesTextChoices)
    let mealQuestionStep1 = ORKQuestionStep(identifier: "TextChoiceQuestionStep1", title: mealTypesQuestionStepTitle, answer: mealTypeAnswerFormat1)
    steps += [mealQuestionStep1]
    
    // create cuisine type choices
    let cuisineTypes: [String] = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"]
    let cuisineTypesQuestionStepTitle = "What cuisine do you want to have for this meal?"
    let cuisineTypesTextChoices: [ORKTextChoice] = createTextChoiceLIst(listString: cuisineTypes)
    let mealTypeAnswerFormat2: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: cuisineTypesTextChoices)
    let mealQuestionStep2 = ORKQuestionStep(identifier: "TextChoiceQuestionStep2", title: cuisineTypesQuestionStepTitle, answer: mealTypeAnswerFormat2)
    steps += [mealQuestionStep2]
    
    // create diet preferences choices
    let dietPreferences:[String] = ["Gluten Free", "Ketogenic", "Vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"]
    let dietPreferencesQuestionStepTitle = "Diet preference?"
    let dietPreferencesTextChoices: [ORKTextChoice] = createTextChoiceLIst(listString: dietPreferences)
    let mealTypeAnswerFormat3: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: dietPreferencesTextChoices)
    let mealQuestionStep3 = ORKQuestionStep(identifier: "TextChoiceQuestionStep3", title: dietPreferencesQuestionStepTitle, answer: mealTypeAnswerFormat3)
    steps += [mealQuestionStep3]
    
    // create diet restriction choices
    let dietRestrictions:[String] = ["Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
    let dietRestrictionsQuestionStepTitle = "Any diet restriction we should be aware of?"
    let dietRestrictionsTextChoices: [ORKTextChoice] = createTextChoiceLIst(listString: dietRestrictions)
    let mealTypeAnswerFormat4: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: dietRestrictionsTextChoices)
    let mealQuestionStep4 = ORKQuestionStep(identifier: "TextChoiceQuestionStep4", title:  dietRestrictionsQuestionStepTitle, answer: mealTypeAnswerFormat4)
    steps += [mealQuestionStep4]
    
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "Thank you!"
    summaryStep.text = "Click next to see your recipes~"
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
