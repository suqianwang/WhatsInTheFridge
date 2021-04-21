//
//  recipeCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/18/21.
//  Modified by Suqian Wang on 4/19/21.

import UIKit
import os.log
import SkeletonView

private let reuseIdentifier = "recipeCell"

class recipeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    // MARK: - Data Structures
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
        let id, usedIngredientCount, missedIngredientCount, likes: Int?
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
    
    // MARK: - RecipeDetail
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
        let extendedIngredients: [ExtendedIngredient?]?
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
        let id: Int?
        let aisle, image, consistency, name: String?
        let nameClean, original, originalString, originalName: String?
        let amount: Double?
        let unit: String?
        let meta, metaInformation: [String?]?
        let measures: Measures?
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
        let pairedWines: [String?]?
        let pairingText: String?
        let productMatches: [ProductMatch?]?
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
        
        let hashValue: Int = 0
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.hashValue)
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
    
    // MARK: - class attributes
    let postImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    var bg: UIImageView!
    
    // skeleton view attributes
    let transitionInterval = 0.25
    //    let collectionCellReuseIdentifier = "recipeCell"
    
    // recipe data attributes
    var all:allData?
    var recipes:[recipe] = []
    var recipeDetailList:[recipeDetail] = []
    
    // button for new survey
    let button = UIButton()
    
    // MARK: - Button
    
    // Button customization
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
    
    // button action
    @IBAction func button_action(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "surveyViewController") as? SurveyViewController{
            vc.setGiveSurvey(give: true)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    // MARK: - View and Skeleton View Setup
    func createGetAllDataThread(){
        // move get data to async thread to show loading animation
        DispatchQueue.main.async {
            self.getAllData()
            // for loop of 10 seconds
            for _ in 0..<100{
                if self.recipes.count > 0{
                    break
                }
                Thread.sleep(forTimeInterval: self.transitionInterval)
            }
            self.collectionView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .none)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add custom background
        bg = Styler.setBackground(bg: "background")
        view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        // Set collectionView background and padding
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        // Set navigation title
        navigationItem.title = "Recipes For You"
        // button setup
        button_config()
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(button_action(_:)), for: .touchUpInside)
        
        createGetAllDataThread()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // skeleton attributes
        let skeletonBaseColor = UIColor.brown
        
        // skeleton setup
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: skeletonBaseColor), animation: .none, transition: .none)
        
        createGetAllDataThread()
        
    }
    
    // MARK: - retrieve data from API
    func getAllData()   {
        let headers = [
            "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        ]
        
        let surveyResponses:[SurveyResponse] = SurveyViewController().loadSurveyResponses()!
        let ingredients:String = getIngredientNames()!
        
        var queryItems:[URLQueryItem] = [
            URLQueryItem(name: "limitLicense", value: "false"), URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "number", value: "10"),URLQueryItem(name: "query", value: ""),
            URLQueryItem(name: "includeIngredients", value: ingredients),
            URLQueryItem(name: "instructionsRequired", value: "true")]
        
        for surveyResponse in surveyResponses{
            let queryItem:URLQueryItem = URLQueryItem(name: surveyResponse.key!, value: surveyResponse.value!)
            queryItems.append(queryItem)
        }
        
        var urlComps = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex")!
        urlComps.queryItems = queryItems
        
        var result = urlComps.string
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
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error - ", message: "No data was returned from the survey specifications. :(", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            
            do{
                self.all = try JSONDecoder().decode(allData.self, from: jsonData)
                self.recipes = self.all!.results
                self.fillRecipeDetailData()
                // use dispatch queue to go to the main thread
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("JSONDecoder error: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error - ", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    func fillRecipeDetailData() {
        for recipe in recipes   {
            let id = recipe.id!
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
                    print("Error: No data")
                    return
                }
                
                do{
                    self.recipeDetailList.append(try JSONDecoder().decode(recipeDetail.self, from: jsonData))
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
        return recipes.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "recipeCell"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        var cell = recipeCollectionViewCell()
        let index = indexPath.row
        
        //let recipeID = recipes[indexPath.row].id
        let recipeTitle = recipes[index].title
        let imageUrl = URL(string: recipes[index].image)!
        let data = try? Data(contentsOf: imageUrl)
        
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as? recipeCollectionViewCell{
            if let imageData = data {
                content.recipeImage.image = UIImage(data: imageData)!
            }
            content.recipeName.text = recipeTitle
            cell = content
        }
        
        // Customize Cell
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetsWidth = self.collectionView.contentInset.right + self.collectionView.contentInset.left + 10
        let cellSize = (self.collectionView.frame.width - insetsWidth)/2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "RecipeDetail"{
            let detail = segue.destination as! recipeDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                
                detail.name = recipes[indexPath.row].title
                let imageUrl = URL(string: recipes[indexPath.row].image)!
                let data = try? Data(contentsOf: imageUrl)
                if let imageData = data {
                    detail.picture = UIImage(data: imageData)!
                }
                let default_descript = "Open your fridge and take out the ingredients. Cut them into proper shape and cook them. Put source into the pot and enjoy your meal!"
                detail.descript =
                    instruct_cleaning(descript: recipeDetailList[indexPath.row].instructions ?? default_descript)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // Load ingredient into comma seperated format
    private func getIngredientNames()-> String? {
        let savedIngredients = IngredientTableViewController().loadIngredients()!
        var names = [String]()
        for ingredient in savedIngredients{
            names.append(ingredient.name)
        }
        //        print(names)
        return names.joined(separator: ",")
    }
    
    // Data cleaning
    func instruct_cleaning(descript instruct:String)->String{
        
        let cleaning_instruct = removeTags(removeSpace(instruct))
        return cleaning_instruct
    }
    
    //removing the occurances of html tags such as <p> </p>
    func removeTags(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    //removing extra space
    func removeSpace(_ text: String) -> String{
        //leading and trailing space
        var trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        //extra space between words
        trimmed = trimmed.split(separator: " ").joined(separator: " ")
        return trimmed
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
