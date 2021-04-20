//
//  explorePageCollectionViewController.swift
//  whats-in-the-fridge
//
//  Created by Qintian Wu on 3/25/21.
//

import UIKit
import Foundation
import SkeletonView

class explorePageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    // MARK: - RecipeSearch
    struct RecipeSearch: Codable {
        let recipes, groceryProducts, articles, menuItems: [Article?]?
        
        enum CodingKeys: String, CodingKey {
            case recipes = "Recipes"
            case groceryProducts = "Grocery Products"
            case articles = "Articles"
            case menuItems = "Menu Items"
        }
    }
    
    // MARK: - Article
    struct Article: Codable {
        let name: String
        let image: String
        let link: String
        let type: TypeEnum
        let relevance: Double
        let kvtable: String?
        let dataPoints: [DataPoint?]?
    }
    
    // MARK: - DataPoint
    struct DataPoint: Codable {
        let key: Key?
        let value: String?
        let show: Bool?
    }
    
    enum Key: String, Codable {
        case calories = "Calories"
        case carbs = "Carbs"
        case cost = "Cost"
        case date = "Date"
        case fat = "Fat"
        case protein = "Protein"
        case unknown = "unknown"
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            self = Key(rawValue: string) ?? .unknown
        }
    }
    
    enum TypeEnum: String, Codable {
        case html = "HTML"
    }
    
    struct RecipeRecs: Codable {
        let statusCode: Int
        let body: String
        let recomIDS: [Int?]?
        let rcpNames: [String]
        let rcpIdxs, minutes: [Int?]?
        let tags, nutritions: [String?]?
        let nSteps: [Int]?
        let steps, descriptions, ingredients: [String?]?
        let nIngredients: [Int]?
        
        enum CodingKeys: String, CodingKey {
            case statusCode, body
            case recomIDS = "recom_ids"
            case rcpNames = "rcp_names"
            case rcpIdxs = "rcp_idxs"
            case minutes, tags, nutritions
            case nSteps = "n_steps"
            case steps, descriptions, ingredients
            case nIngredients = "n_ingredients"
        }
    }
    
    // MARK: - class attributes
    let transitionInterval = 0.25
    
    var recipeRecs: RecipeRecs?
    var recipeToImage: [String: UIImage] = [:]
    var recipeToIndex: [String: Int] = [:]
    var recipesWithImages: [String] = []
    //dummy data for now
    let postTitle =  ["Tomato Egg", "Egg Tomato", "Potato beef", "Beff Potato"]
    let postImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    let postDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
    
    // MARK: - View and Skeleton View Setup
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func createGetAllDataThread(){
        // move get data to async thread to show loading animation
        DispatchQueue.main.async {
            self.getAllData()
            // for loop of 10 seconds
            for _ in 0..<60{
                if self.recipeToImage.count > 0{
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
        print("loading viewDidLoad")
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        navigationItem.title = "Recipes For You"
        getAllData()
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
    
    func getAllData()   {
        
        print("Trying to get all data")
        let parameters: [String: Any] = [
            "liked_recoms": [],
            "user_id": 222,
            "recom_amount": 15
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        
        let url = URL(string: "https://4t2d1vr498.execute-api.us-east-1.amazonaws.com/default/recom_v2")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.allHTTPHeaderFields = [
            "X-API-Key": "gXj2IxaxTc1YededFaHXgab6xFHbO2I76RNEmwzW"
        ]
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
                self.recipeRecs = try JSONDecoder().decode(RecipeRecs.self, from: jsonData)
                print("finished loading data")
                print(self.recipeRecs!)
                self.getImages()
                //because we HAVE to refresh after we load the data to make sure the data is populated.
                //this is a separate task so we gotta use dispatch queue to tell it to go to the main thread
                //                DispatchQueue.main.async {
                //                    self.collectionView.reloadData()
                //                }
            } catch {
                print("JSONDecoder error: \(error)")
            }
        })
        
        dataTask.resume()
        
    }
    
    func getImages()    {
        print("getting images")
        let recipeNames: [String] = self.recipeRecs!.rcpNames
        var counter: Int = 0
        for recipe in recipeNames   {
            self.recipeToIndex[recipe] = counter
            counter = counter + 1
            let headers = [
                "x-rapidapi-key": "6f1810ca34msh227332a299bf704p13f30bjsn1ba98259af85",
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
            ]
            print(recipe)
            let recipeCleaned: String = recipe.removeExtraSpaces()
            let queryItems:[URLQueryItem] = [
                URLQueryItem(name: "query", value: recipeCleaned)]
            
            var urlComps = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/site/search")!
            urlComps.queryItems = queryItems
            let result = urlComps.string
            print(result)
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
                    let recipeData: RecipeSearch = try JSONDecoder().decode(RecipeSearch.self, from: jsonData)
                    print("got image")
                    if (recipeData.recipes != nil) {
                        let imageUrl = URL(string: recipeData.recipes![0]!.image)!
                        let data = try? Data(contentsOf: imageUrl)
                        if let imageData = data {
                            let image = UIImage(data: imageData)!
                            self.recipeToImage[recipe] = image
                        }
                        
                        
                        self.recipesWithImages.append(recipe)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                    //                    else if (recipeData.articles != nil)    {
                    //                        self.recipeToImage[recipe] = recipeData.articles![0]?.image
                    //                        self.recipesWithImages.append(recipe)
                    //
                    //                        DispatchQueue.main.async {
                    //                            self.collectionView.reloadData()
                    //                        }
                    //                    }
                    print(self.recipeToImage)
                } catch {
                    print("JSONDecoder error: \(error)")
                }
            })
            
            dataTask.resume()
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let detail = segue.destination as! explorePageDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                //                detail.name = postTitle[indexPath.row]
                //                detail.picture = postImage
                //                detail.descript = postDescript
                let title = recipesWithImages[indexPath.row]
                detail.name = title
                detail.picture = self.recipeToImage[title]!
                detail.descript = self.recipeRecs?.steps![self.recipeToIndex[title]!]
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //        return postTitle.count
        return recipeToImage.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let index = indexPath.row
        //        let title = postTitle[index]
        let title = recipesWithImages[index]
        
        let image = self.recipeToImage[title]
        if (image != nil)   {
            if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? exploreItemCollectionViewCell{
                content.configure(title, image!)
                cell = content
            }
        }
        
        else    {
            if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? exploreItemCollectionViewCell{
                content.configure(title, postImage)
                cell = content
            }
        }
        
        
        return cell
    }
    
    //attempt to configure the cell size to accomodate different deviced, not done yet
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize : CGRect = UIScreen.main.bounds
        
        var widthCell = 0
        var heightCell = 0
        
        //iPhone x, 6,7,8
        if screenSize.width == 375 && screenSize.height == 667{
            widthCell = 172
            heightCell = 150
        }
        
        //iPhone 6+,6s+, 7+,8+
        if screenSize.width == 414 && screenSize.width == 736{
            widthCell = 191
            heightCell = 160
        }
        
        //iPhone 11 Pro, X, Xs
        if screenSize.width == 375 && heightCell == 812 {
            widthCell = 172
            heightCell = 170
        }
        
        
        //iPhone 11 Pro Max, Xs Max
        if screenSize.width == 414 && screenSize.height == 896{
            widthCell = 191
            heightCell = 190
        }
        
        //every other iphone
        if screenSize.width == 320 {
            widthCell = 144
            heightCell = 125
            
        }
        
        return CGSize(width: widthCell, height: heightCell)
    }
    
    
}

extension String {
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
}


