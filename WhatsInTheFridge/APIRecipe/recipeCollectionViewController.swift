//
//  recipeCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/18/21.
//  Modified by Suqian Wang on 4/19/21.

import UIKit
import os.log

private let reuseIdentifier = "recipeCell"

class recipeCollectionViewController: UICollectionViewController {
    struct allData: Codable {
        let results: [recipe]
        let baseURI: String
        let offset, number, totalResults, processingTimeMS: Int

        enum CodingKeys: String, CodingKey {
            case results
            case baseURI = "baseUri"
            case offset, number, totalResults
            case processingTimeMS = "processingTimeMs"
        }
    }

    // MARK: - Result
    struct recipe: Codable {
        let id, usedIngredientCount, missedIngredientCount, likes: Int
        let title: String
        let image: String
        let imageType: String
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
        let gaps: String?
        let lowFodmap: Bool?
        let preparationMinutes, cookingMinutes, aggregateLikes, spoonacularScore: Int?
        let healthScore: Int?
        let creditsText, sourceName: String?
        let pricePerServing: Double?
        let extendedIngredients: [ExtendedIngredient]?
        let id: Int
        let title: String
        let readyInMinutes, servings: Int?
        let sourceURL: String?
        let image: String?
        let imageType, summary: String?
        let cuisines, dishTypes, diets, occasions: [String]?
        let winePairing: WinePairing?
        let instructions: String?
        let analyzedInstructions: [AnalyzedInstruction]?
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

    
    var all:allData?
    
    var recipes:[recipe] = []
    
    var recipeDetailList:[recipeDetail] = []
    
    // Create a button for new survey
    let button = UIButton()
    
    // MARK: - Button Customization
    func button_config(){
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 50
        button.frame = CGRect(
            x: self.view.frame.width/2 - buttonWidth/2,
            y: self.view.frame.height*0.83,
            width: buttonWidth,
            height: buttonHeight)
        button.layer.cornerRadius = 10
        button.backgroundColor = .link
        button.setTitle("New Survey", for: .normal)
        button.setTitle("Let's go!", for: .highlighted)
    }
    
    @IBAction func button_action(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "surveyViewController") as? SurveyViewController{
            vc.setGiveSurvey(give: true)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        navigationItem.title = "Recipes For You"
        
        button_config()
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(button_action(_:)), for: .touchUpInside)

        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        getAllData()
    }
    
    private func getIngredientNames()-> String? {
        let savedIngredients = IngredientTableViewController().loadIngredients()!
        var names = [String]()
        for ingredient in savedIngredients{
            names.append(ingredient.name)
        }
        print(names)
        return names.joined(separator: ",")
    }

    func getAllData()   {
        print("Trying to get all data")
        let headers = [
            "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        let surveyResponses:[SurveyResponse] = SurveyViewController().loadSurveyResponses()!
        let ingredients:String = getIngredientNames()!
        
        var queryItems:[URLQueryItem] = [
            URLQueryItem(name: "limitLicense", value: "false"), URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "number", value: "10"),URLQueryItem(name: "query", value: ""),
            URLQueryItem(name: "includeIngredients", value: ingredients)]
        
        for surveyResponse in surveyResponses{
            let queryItem:URLQueryItem = URLQueryItem(name: surveyResponse.key!, value: surveyResponse.value!)
            queryItems.append(queryItem)
        }
        
        var urlComps = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex")!
        urlComps.queryItems = queryItems
        
        var result = urlComps.string
        print(result)
        result = result!.replacingOccurrences(of: ",", with: "%2C")
        
        let request = NSMutableURLRequest(url: NSURL(string: result!)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 60)
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
                self.all = try JSONDecoder().decode(allData.self, from: jsonData)
                self.recipes = self.all!.results
                self.fillRecipeDetailData()
                //because we HAVE to refresh after we load the data to make sure the data is populated.
                //this is a separate task so we gotta use dispatch queue to tell it to go to the main thread
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
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



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        var cell = UICollectionViewCell()
        let index = indexPath.row
        
        //let recipeID = recipes[indexPath.row].id
        let recipeTitle = recipes[index].title
        let imageUrl = URL(string: recipes[index].image)!
        let data = try? Data(contentsOf: imageUrl)
        
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeAPI", for: indexPath) as? recipeCollectionViewCell{
            if let imageData = data {
                content.recipeImage.image = UIImage(data: imageData)!
            }
//            content.configure()
            content.recipeName.text = recipeTitle
            //content.configure(recipeTitle, image)
            cell = content
        }
    
        
        return cell
    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toRecipeDetail"{
            let detail = segue.destination as! recipeDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                
                detail.name = recipes[indexPath.row].title
                let imageUrl = URL(string: recipes[indexPath.row].image)!
                let data = try? Data(contentsOf: imageUrl)
                if let imageData = data {
                    detail.picture = UIImage(data: imageData)!
                }
                detail.descript = recipeDetailList[indexPath.row].instructions
            }
        }
    }
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
