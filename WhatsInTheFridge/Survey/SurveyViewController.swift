//
//  SurveyViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/5/21.
//

import UIKit
import ResearchKit

class SurveyViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    let survey = SurveyData()
    var surveyResponses:[SurveyResponse] = []
    var giveSurvey:Bool = false
    
    // handles view for the first time it is opened
    override func viewDidLoad() {
        super.viewDidLoad()
        routeView()
    }
    
    // handles view for every time the view is opened
    override func viewWillAppear(_ animated: Bool) {
        if self.isViewLoaded{
            routeView()
        }
        
    }
    
    /* method to route view to recipe view if data exists
     or to survey if none exists */
    func routeView(){
        if loadSurveyResponses()?.count == 0 || giveSurvey {
            presentSurvey()
        }else{
            goToRecipeTableViewController()
        }
    }
    
    // MARK: - present survey
     func presentSurvey(){
        let taskViewController = ORKTaskViewController(task: survey.SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        taskViewController.modalPresentationStyle = .fullScreen
        present(taskViewController, animated: true, completion: nil)
    }
    
    func setGiveSurvey(give:Bool){
        giveSurvey = give
    }
    
    // MARK: - handle survey responses
    // method to handle when the survey has been completed
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        switch(reason){
        case .completed:
            giveSurvey = false
            os_log(.info, log: OSLog.default, "survey finished with reason 'completed'")
            // get results
            let taskResult = taskViewController.result.results! as! [ORKStepResult]
            // process and translate results
            let processedResults = processResults(stepResults: taskResult)
            surveyResponses = translateResults(processedResults: processedResults)
            // save results
            saveSurveyResponses()
            taskViewController.dismiss(animated: true, completion: nil)
            goToRecipeTableViewController()
            break
        case .discarded:
            giveSurvey = loadSurveyResponses()?.count == 0
            os_log(.debug, log: OSLog.default, "survey finished with reason 'discarded'")
            // go to explore vc
            taskViewController.dismiss(animated: true, completion: nil)
            if giveSurvey{
                goToExplorePageCollectionViewController()
            }
            break
        case .failed:
            os_log(.debug, log: OSLog.default, "survey finished with reason 'failed'")
            break
        case .saved:
            os_log(.debug, log: OSLog.default, "survey finished with reason 'saved'")
            break
        default:
            os_log(.debug, log: OSLog.default, "survey finished for unknown reason...dismissing")
            break
        }
        
    }
    
    // reads step results and returns dictionary of choices user selected from survey
    func processResults(stepResults:[ORKStepResult])->[String:[Int]]{
        var questionChoices = [String:[Int]]()
        for stepResult in stepResults{
            var questionResults:[ORKChoiceQuestionResult]?
            questionResults = stepResult.results! as? [ORKChoiceQuestionResult]
            if questionResults!.capacity > 0{
                let questionResult = questionResults?.first
                let identifier = questionResult?.identifier
                let choices = questionResult?.choiceAnswers
                questionChoices[identifier!] = (choices as! [Int])
            }
        }
        return questionChoices
    }
    
    // reads dictionary of user choices from survey and returns the string values of those choices
    func translateResults(processedResults: [String:[Int]]) -> [SurveyResponse]{
        var surveyResponses:[SurveyResponse] = []
        let dataDict = survey.getStepDataListDict()
        for processedResult in processedResults{
            let identifier = processedResult.key
            let data = dataDict[identifier]
            if data != nil{
                let answers:[Int] = processedResult.value
                if answers.isEmpty{
                    if data?.getIdentifier() == survey.mealTypeIdentifier{
                        let defaultAnswer:String = (dataDict[identifier]?.getChoices().first)!
                        surveyResponses.append(SurveyResponse(key: identifier,value: defaultAnswer)!)
                    }else if data?.getIdentifier() == survey.cuisineTypeIdentifier{
                        let defaultAnswer:[String] = (dataDict[identifier]?.getChoices())!
                        surveyResponses.append(SurveyResponse(key: identifier,value: defaultAnswer)!)
                    }else{
                        surveyResponses.append(SurveyResponse(key: identifier,value: [])!)
                    }
                }else{
                    var translatedChoices:[String] = []
                    let choices = dataDict[identifier]?.getChoices()
                    for processedResultAnswer in answers{
                        translatedChoices.append(choices![processedResultAnswer])
                    }
                    surveyResponses.append(SurveyResponse(key: identifier,value: translatedChoices)!)
                }
            }
        }
        return surveyResponses
    }
    
    // MARK: - loads survey from archive
    func loadSurveyResponses() -> [SurveyResponse]?{
        do{
            let data = try Data(contentsOf: SurveyResponse.surveyResponseArchiveURL)
            let loadedResponse = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SurveyResponse]
            return loadedResponse
        }catch{
            os_log(.error, log: OSLog.default, "failed to load responses")
        }
        return []
    }
    
    // MARK: - saves survey response into archive
    private func saveSurveyResponses(){
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: surveyResponses, requiringSecureCoding: false)
            try data.write(to: SurveyResponse.surveyResponseArchiveURL)
            os_log(.info, log: OSLog.default, "survey responses successfully saved in archive")
        }catch{
            os_log(.error, log: OSLog.default, "failed to save responses")
        }
    }

    // TODO: Add Button to RecipeTableView, then do the logic
    func goToRecipeTableViewController(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recipeCollectionViewController") as? recipeCollectionViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: false)
            }
        }
        
//        //This is for testing purpose, delete afterwards
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestButton") as? TestButton {
//            if let navigator = navigationController {
//                navigator.pushViewController(viewController, animated: false)
//            }
//        }
    }
    
    func goToExplorePageCollectionViewController(){
        tabBarController?.selectedIndex = HomeTabBarController.exploreTabIndex
    }
}
