//
//  MealSurveyTableViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/3/21.
//

import UIKit

// MARK: Question Struct for survey
struct Question {
    let questionString: String?
    let answers:[String]?
    var response: String?
}

// MARK: list of questions for survey
var survey:[Question] = [
    Question(questionString: "What type of meal are you planning?", answers: ["main course", "side dish", "desert", "appetizer", "salad", "bread", "breakfast", "soup", "beverage", "sauce", "marinade", "fingerfood", "snack", "drink"], response:nil),
    Question(questionString: "What cuisine do you want to have for this meal?", answers: ["African", "American", "British", "Cajun", "Caribbean", "Chinese", "Eastern European", "European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"], response:nil),
    Question(questionString: "Diet Preference?", answers: ["Gluten Free", "Ketogenic", "Vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan", "Pescetarian", "Paleo", "Primal", "Whole30"], response:nil),
    Question(questionString: "Any diet restriction we should know about?", answers: ["Dairy", "Egg", "Gluten", "Grain", "Peanut", "Seafood", "Sesame", "Shellfish", "Soy", "Sulfite", "Tree Nut", "Wheat"], response:nil)]

class MealSurveyQuestion: UITableViewController {

    let cellId = "answerCell"
    let headerId = "headerId"
    let sendToRecipeId = "sendToRecipeId"
    let headerHeight: CGFloat = 50
//    let question = Question(questionString: "How you doin?", answers: ["good", "bd", "meh"], response:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Question"
        
        // parameters for header
        tableView.register(MealSurveyHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.register(MealSurveyTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.sectionHeaderHeight = headerHeight
        
        // removes extra lines for extra cells
        tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            return survey[index].answers!.count
        }
        else {
            return 0
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MealSurveyTableViewCell
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            let row = indexPath.row
            cell.textLabel?.text = survey[index].answers![row]
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! MealSurveyHeader
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            header.nameLabel.text = survey[index].questionString
        }
        return header
        
    }

    // MARK: - Navigation
    // progmatically creating view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            survey[index].response = survey[index].answers![indexPath.row]
            
            // move through all questions and send to view controller
            if index < survey.count - 1{
                let question = MealSurveyQuestion()
                navigationController?.pushViewController(question, animated: true)
            }else{
                let layout = UICollectionViewFlowLayout()
                let recipeVC = RecipesViewController(collectionViewLayout: layout)
                recipeVC.survey = survey
                navigationController?.pushViewController(recipeVC, animated: true)
            }
        }
    }
}

// MARK: - Header for Question View
// This is an inner class for the header of the Meal Survey
class MealSurveyHeader: UITableViewHeaderFooterView{
    
    override init(reuseIdentifier:String?){
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.textColor = .red
        
        // disables automatic constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel])
        // add manual constraints to header
        addConstraints(horizontalConstraints)
        addConstraints(verticalConstraints)
        
    }
    
    // default error handling
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
