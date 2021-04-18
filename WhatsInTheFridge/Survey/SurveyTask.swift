//
//  SurveyTask.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/5/21.
//

import UIKit
import ResearchKit

struct SurveyStepData{
    private var surveyChoices:[String]?
    private var surveyQuestion:String?
    private var surveyIdentifier:String?
    
    init(choices:[String],question:String,id:String){
        self.surveyChoices = choices
        self.surveyQuestion = question
        self.surveyIdentifier = id
    }
    
    public func getChoices() -> [String]{
        return surveyChoices!
    }
    
    public func getQuestion() -> String{
        return surveyQuestion!
    }
    
    public func getIdentifier() -> String{
        return surveyIdentifier!
    }
}
class SurveyData{
    
    // instruction data
    let instructionStepTitle:String = "Plan the meal"
    let instructionStepText:String = "Your satisfaction is important to us, let us get some preferences from you so we can provide you with better suggestion :)"
    
    // meal data
     let mealTypeList:[String] = ["main course", "side dish", "desert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"]
    let mealTypeTitle:String = "What type of meal are you planning?"
    
    // cuisine data
    let cuisineTypeList:[String] = ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"]
    let cuisineTypeTitle:String = "What cuisine do you want to have for this meal?"
    
    // diet preference data
    let dietPreferenceList:[String] = ["Gluten Free", "Ketogenic", "Vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"]
    let dietPreferenceTitle:String = "Diet preference?"
    
    // diet restriction data
    let dietRestrictionList:[String] = ["Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"]
    let dietRestrictionTitle:String = "Any diet restriction we should be aware of?"
    
    // summary data
    let summaryTitle:String = "Thank you!"
    let summaryText:String = "Click next to see your recipes~"
    
    // identifiers
    let instructionStepIdentifier:String = "IntroStep"
    let mealTypeIdentifier:String = "type"
    let cuisineTypeIdentifier:String = "cuisine"
    let dietPreferenceIdentifier:String = "diet"
    let dietRestrictionIdentifier:String = "intolerance"
    let summaryStepIdentifier:String = "SummaryStep"
    let taskIdentifier:String = "SurveyTask"
    
    var stepDataList:[SurveyStepData]{return [SurveyStepData(choices: mealTypeList,question: mealTypeTitle,id: mealTypeIdentifier),
                                             SurveyStepData(choices: cuisineTypeList,question: cuisineTypeTitle,id: cuisineTypeIdentifier),
                                             SurveyStepData(choices: dietPreferenceList,question: dietPreferenceTitle,id: dietPreferenceIdentifier),
                                             SurveyStepData(choices: dietRestrictionList,question: dietRestrictionTitle,id: dietRestrictionIdentifier)]}
    
    func getStepDataListDict()->[String:SurveyStepData]{
        var result:[String:SurveyStepData] = [:]
        for stepData in stepDataList{
            result[stepData.getIdentifier()] = stepData
        }
        return result
    }

    // method to take a list of choices and returns ORKTextChoice
    private func createTextChoiceLIst(listString:[String]) -> [ORKTextChoice]{
        var textChoices: [ORKTextChoice] = [ORKTextChoice]()
        let count = 0...listString.count-1
        for number in count {
            textChoices.append(ORKTextChoice(text: listString[number], value: number as NSNumber))
        }
        return textChoices
    }
    
    // MARK: create ordered tasks for survey
    private func createORKOrderedTask() -> ORKOrderedTask{
        var steps = [ORKStep]()
        // set up instructions
        let instructionStep = ORKInstructionStep(identifier: instructionStepIdentifier)
        instructionStep.title = instructionStepTitle
        instructionStep.text = instructionStepText
        steps += [instructionStep]
        
        // set up steps
        for stepData in stepDataList{
            // create meal type choices
            let choices = stepData.getChoices()
            let question = stepData.getQuestion()
            let textChoices: [ORKTextChoice] = createTextChoiceLIst(listString: choices)
            let answerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: textChoices)
            let questionStep = ORKQuestionStep(identifier: stepData.getIdentifier(), title: question, answer: answerFormat)
            steps += [questionStep]
        }
        
        // set up summary
        let summaryStep = ORKCompletionStep(identifier: summaryStepIdentifier)
        summaryStep.title = summaryTitle
        summaryStep.text = summaryText
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: taskIdentifier, steps: steps)
    }

    // public task attribute
    public var SurveyTask: ORKOrderedTask{return createORKOrderedTask()}
        
}
    

