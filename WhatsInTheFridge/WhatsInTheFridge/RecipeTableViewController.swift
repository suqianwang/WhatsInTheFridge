//
//  RecipeTableViewController.swift
//  WhatsInTheFridge
//
//  Created by Billy Luqiu on 4/3/21.
//

import UIKit
import Foundation

class RecipeTableViewController: UITableViewController {

    
    struct recipe: Codable {
        let id: Int
        let title: String
        let image: String
        let imageType: String
        let usedIngredientCount, missedIngredientCount: Int
        let missedIngredients, usedIngredients, unusedIngredients: [ingredient]
        let likes: Int
    }

    // MARK: - Ingredient
    struct ingredient: Codable {
        let id: Int
        let amount: Double
        let unit, unitLong, unitShort, aisle: String
        let name, original, originalString, originalName: String
        let metaInformation, meta: [String]
        let image: String
        let extendedName: String?
    }
    
    var recipes:[recipe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()

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
        return recipes.count
    }

    
    func getAllData()   {
        print("Trying to get all data")
        let headers = [
            "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=apples%2Cflour%2Csugar&number=5&ranking=1&ignorePantry=true")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                print ("Error: \(error!)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error - ", message: "\(error!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            guard let jsonData = data else {
                print("No data")
                return
            }
            
            do{
                self.recipes = try JSONDecoder().decode([recipe].self, from: jsonData)
                print(self.recipes.count)
                //because we HAVE to refresh after we load the data to make sure the data is populated.
                //this is a separate task so we gotta use dispatch queue to tell it to go to the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSONDecoder error: \(error)")
            }
        })
        
        dataTask.resume()

    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeListing", for: indexPath)
            as! RecipeTableViewCell
        // Configure the cell...
        print("hererererere")
        let recipeID = recipes[indexPath.row].id
        let recipeTitle = recipes[indexPath.row].title
        let imageUrl = URL(string: recipes[indexPath.row].image)!
        
        let data = try? Data(contentsOf: imageUrl)
        if let imageData = data {
            cell.recipeImage.image = UIImage(data: imageData)
        }
        
        cell.recipeName.text = recipeTitle
        cell.recipeID.text = String(recipeID)
        
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
