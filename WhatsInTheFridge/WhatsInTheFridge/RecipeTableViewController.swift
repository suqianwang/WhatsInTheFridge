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
    

    // MARK: - Welcome
    struct recipeDetail: Codable {
        let vegetarian, vegan, glutenFree, dairyFree: Bool
        let veryHealthy, cheap, veryPopular, sustainable: Bool
        let weightWatcherSmartPoints: Int
        let gaps: String
        let lowFodmap: Bool
        let preparationMinutes, cookingMinutes, aggregateLikes, spoonacularScore: Int
        let healthScore: Int
        let creditsText, sourceName: String
        let pricePerServing: Double
        let extendedIngredients: [ExtendedIngredient]
        let id: Int
        let title: String
        let readyInMinutes, servings: Int
        let sourceURL: String
        let image: String
        let imageType, summary: String
        let cuisines, dishTypes, diets, occasions: [String]
        let winePairing: WinePairing
        let instructions: String
        let analyzedInstructions: [AnalyzedInstruction]
        let originalID: JSONNull?

        enum CodingKeys: String, CodingKey {
            case vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, weightWatcherSmartPoints, gaps, lowFodmap, preparationMinutes, cookingMinutes, aggregateLikes, spoonacularScore, healthScore, creditsText, sourceName, pricePerServing, extendedIngredients, id, title, readyInMinutes, servings
            case sourceURL = "sourceUrl"
            case image, imageType, summary, cuisines, dishTypes, diets, occasions, winePairing, instructions, analyzedInstructions
            case originalID = "originalId"
        }
    }

    // MARK: - AnalyzedInstruction
    struct AnalyzedInstruction: Codable {
        let name: String
        let steps: [Step]
    }

    // MARK: - Step
    struct Step: Codable {
        let number: Int
        let step: String
        let ingredients, equipment: [Ent]
        let length: Length?
    }

    // MARK: - Ent
    struct Ent: Codable {
        let id: Int
        let name, localizedName, image: String
    }

    // MARK: - Length
    struct Length: Codable {
        let number: Int
        let unit: String
    }

    // MARK: - ExtendedIngredient
    struct ExtendedIngredient: Codable {
        let id: Int
        let aisle, image, consistency, name: String
        let nameClean, original, originalString, originalName: String
        let amount: Double
        let unit: String
        let meta, metaInformation: [String]
        let measures: Measures
    }

    // MARK: - Measures
    struct Measures: Codable {
        let us, metric: Metric
    }

    // MARK: - Metric
    struct Metric: Codable {
        let amount: Double
        let unitShort, unitLong: String
    }

    // MARK: - WinePairing
    struct WinePairing: Codable {
        let pairedWines: [String]
        let pairingText: String
        let productMatches: [ProductMatch]
    }

    // MARK: - ProductMatch
    struct ProductMatch: Codable {
        let id: Int
        let title, productMatchDescription, price: String
        let imageURL: String
        let averageRating: Double
        let ratingCount: Int
        let score: Double
        let link: String

        enum CodingKeys: String, CodingKey {
            case id, title
            case productMatchDescription = "description"
            case price
            case imageURL = "imageUrl"
            case averageRating, ratingCount, score, link
        }
    }

    // MARK: - Encode/decode helpers

    class JSONNull: Codable, Hashable {

        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }

        public var hashValue: Int {
            return 0
        }

        public init() {}

        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

    
    
    
    var recipes:[recipe] = []
    var recipeDetailList:[recipeDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 150
        let ingredients: [String] = ["Ribeye"]
        getAllData(ingredients: ingredients)

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

    
    func getAllData(ingredients: [String])   {
        print("Trying to get all data")
        let headers = [
            "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        let ingredientsString = ingredients.joined(separator:"%2")
        let urlRequestString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients="+String(ingredientsString)+"&number=5&ranking=1&ignorePantry=true"
        
        let urlStr = URL(string: urlRequestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        print(urlStr)
        let request = NSMutableURLRequest(url: urlStr!,
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
                self.fillRecipeDetailData()
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
    
    func fillRecipeDetailData() {
        for recipe in recipes   {
            let id = recipe.id
            let headers = [
                "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
            ]
            let urlRequestString: String = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"+String(id)+"/information"
            
            let urlStr = URL(string: urlRequestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            let request = NSMutableURLRequest(url: urlStr!,
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
                    self.recipeDetailList.append(try JSONDecoder().decode(recipeDetail.self, from: jsonData))
                    print("here")
                } catch {
                    print("JSONDecoder error: \(error)")
                }
            })

            dataTask.resume()
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeListing", for: indexPath)
            as! RecipeTableViewCell
        // Configure the cell...
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
