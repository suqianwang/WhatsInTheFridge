//
//  IngredientTableViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/5/21.
//

import UIKit
import os.log

class IngredientTableViewController: UITableViewController {

    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    

    @IBAction func done(segue:UIStoryboardSegue) {
            let ingredientVC = segue.source as! AddIngredientViewController
            newIngredient = ingredientVC.ingredient
            ingredients.append(newIngredient)
            tableView.reloadData()
    }
    
    var ingredients = [String]()
    var newIngredient: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ingredients = ["salt", "pepper", "oil"]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // Mark: - Table View Save Data
    
    private func saveIngredients(){
        //let isSuccessfulSave = NSKeyedArchiver.archivedData(withRootObject: ingredients, requiringSecureCoding: true)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients, toFile: IngredientTableViewCell.ArchiveURL.path)
        if isSuccessfulSave{
            os_log(.error, log: OSLog.default, "Ingredients successfully saved.")
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to saved ingredients...")
        }
    }
    
    private func loadIngredients(){
        return NSKeyedUnarchiver.unarchiveObject(withFile: IngredientTableViewCell.ArchiveURL.path) as? [IngredientTableViewCell.Ingredient]
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)

        cell.textLabel?.text = ingredients[indexPath.row]

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let cell = self.ingredients[fromIndexPath.row]
        ingredients.remove(at: fromIndexPath.row)
        ingredients.insert(cell, at: to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
