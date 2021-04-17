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
    
    var ingredients = [Ingredient]()
    var newIngredient: Ingredient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        //use class original edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //if there is data from the loaded data, load it here.
        if let savedIngredients = loadIngredients(){
            print("There are saved ingredients: attempting to load them.")
            ingredients += savedIngredients
        }
        
        //otherwise use the default.
        else{
            print("There are no saved ingredients: you should see the defaults.")
            loadSampleIngredients()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    @IBAction func done(segue:UIStoryboardSegue) {
        let ingredientVC = segue.source as! AddIngredientViewController
        print("Coming in from the segue?")
        newIngredient = ingredientVC.ingredient
        ingredients.append(newIngredient!)
        saveIngredients()
        tableView.reloadData()
    }
    
    // Mark: - Default data for no data stores.
    private func loadSampleIngredients(){
        guard let ingred1 = Ingredient(name: "salt") else {
            fatalError("Unable to load default ingredient 1.")
        }
        
        guard let ingred2 = Ingredient(name: "pepper") else {
            fatalError("Unable to load default ingredient 2.")
        }
        
        guard let ingred3 = Ingredient(name: "oil") else {
            fatalError("Unable to load default ingredient 3.")
        }
        
        ingredients += [ingred1, ingred2, ingred3]
    }
    
    // Mark: - Table View Data Source
    private func loadIngredients() -> [Ingredient]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Ingredient.ArchiveURL.path) as? [Ingredient]
    }
    
    // Mark: - Table View Save Data
    private func saveIngredients(){
        print("We are saving ingredients.")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ingredients, toFile: Ingredient.ArchiveURL.path)
        print(isSuccessfulSave)
        if isSuccessfulSave{
            os_log(.error, log: OSLog.default, "Ingredients successfully saved.")
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to saved ingredients...")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableViewCell", for: indexPath) as? IngredientTableViewCell else {
            fatalError("The dequeued cell is not an instance of IngredientTableViewCell.")
        }
        let ingredient = ingredients[indexPath.row]
        
        cell.ingredientName?.text = ingredient.name
        cell.backgroundColor = .clear
        
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
            print("Attempting to delete an ingredient.")
            // Delete the row from the data source
            ingredients.remove(at: indexPath.row)
            saveIngredients()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        print("Rearranging table.")
        let cell = self.ingredients[fromIndexPath.row]
        ingredients.remove(at: fromIndexPath.row)
        ingredients.insert(cell, at: to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // Mark : Save Ingredients to Datalast again whenever a new one is added or an existing one updated.
    @IBAction func unwindToIngredients(sender: UIStoryboardSegue){
        let sourceViewController = sender.source as? AddIngredientViewController
        
        if sourceViewController != nil {
            let ingredient = sourceViewController?.ingredient
            print("Coming from segue.")
            
            //update an existing ingredient?
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                ingredients[selectedIndexPath.row] = ingredient!
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            
            //add a new ingredient
            else{
                print("Adding a new ingredient: table view detected this.")
                let newIndexPath = IndexPath(row: ingredients.count, section:0)
                
                ingredients.append(ingredient!)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveIngredients()
        }
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
