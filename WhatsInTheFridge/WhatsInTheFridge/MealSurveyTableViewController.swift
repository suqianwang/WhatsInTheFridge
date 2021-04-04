//
//  MealSurveyTableViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/3/21.
//

import UIKit

struct Question {
    let questionString: String?
    let answers:[String]?
    var response: String?
}

var survey:[Question] = [Question(questionString: "How you doin?", answers: ["good", "bd", "meh"], response:nil),
                         Question(questionString: "How you still doin?", answers: ["good", "bd", "meh"], response:nil),
                         Question(questionString: "How you doin now?", answers: ["good", "bd", "meh"], response:nil),
                         Question(questionString: "How you doin really?", answers: ["good", "bd", "meh"], response:nil),
                         Question(questionString: "How you doin after this?", answers: ["good", "bd", "meh"], response:nil)]

class MealSurveyQuestion: UITableViewController {

    let cellId = "answerCell"
    let headerId = "headerId"
    let headerHeight: CGFloat = 50
    let question = Question(questionString: "How you doin?", answers: ["good", "bd", "meh"], response:nil)
    
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
        // #warning Incomplete implementation, return the number of rows
        guard let count = question.answers?.count else { return 0 }
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MealSurveyTableViewCell
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            cell.textLabel?.text = survey[index].answers![indexPath.row]
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = navigationController?.viewControllers.firstIndex(of: self){
            survey[index].response = survey[index].answers![indexPath.row]
            
            // move through all questions and send to view controller
            if index < survey.count - 1{
                let question = MealSurveyQuestion()
                navigationController?.pushViewController(question, animated: true)
            }else{
                let recipeViewController = RecipesViewController()
                
                var responses:[String] = []
                for question in survey {
                    responses.append(question.response!)
                }
                recipeViewController.responses = responses
                navigationController?.pushViewController(recipeViewController, animated: true)
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
