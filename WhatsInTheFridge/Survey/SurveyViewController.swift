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
    
    @IBAction func surveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: survey.SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: handle survey responses
    // method to handle when the survey has been completed
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
//        taskViewController.dismiss(animated: true, completion: nil)
        
        switch(reason){
        case .completed:
            os_log(.info, log: OSLog.default, "survey finished with reason 'completed'")
            // get results
            let taskResult = taskViewController.result.results! as! [ORKStepResult]
            // process and translate results
            let processedResults = processResults(stepResults: taskResult)
            surveyResponses = translateResults(processedResults: processedResults)
            // save results
            saveSurveyResponses()
            // load test
            // TODO: remove after done testing
//            let loadedResponses:[SurveyResponse] = loadSurveyResponses()!
//            os_log(.info, log:OSLog.default, "loaded survey responses \(loadedResponses)")
            break
        case .discarded:
            os_log(.debug, log: OSLog.default, "survey finished with reason 'discarded'")
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let homeViewController = storyboard.instantiateViewController(identifier: "HomeTabBarController")
            homeViewController.modalTransitionStyle = .crossDissolve
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true)
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
        
        taskViewController.dismiss(animated: true, completion: nil)
        
    }
    
    // reads step results and returns dictionary of choices user selected from survey
    func processResults(stepResults:[ORKStepResult])->[String:[Int]]{
        var questionChoices = [String:[Int]]()
        for stepResult in stepResults{
            do{
                var questionResults:[ORKChoiceQuestionResult]?
                questionResults = try stepResult.results! as? [ORKChoiceQuestionResult]
                if questionResults!.capacity > 0{
                    let questionResult = questionResults?.first
                    let identifier = questionResult?.identifier
                    let choices = questionResult?.choiceAnswers
                    questionChoices[identifier!] = choices as! [Int]
                }
            } catch {
                os_log(.error, log: OSLog.default, "failed to process results")
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
                    if data?.getIdentifier() == survey.mealTypeIdentifier || data?.getIdentifier() == survey.cuisineTypeIdentifier{
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
    

}
