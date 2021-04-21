//
//  explorePageCollectionViewController.swift
//  whats-in-the-fridge
//
//  Created by Qintian Wu on 3/25/21.
//  Modified by Suqian Wang on 4/20/21.

import UIKit
import Foundation
import SkeletonView
import os.log

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
        let body: String?
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
    
    var bg: UIImageView!
    
    var recipeRecs: RecipeRecs?
    var recipeToImage: [String: UIImage] = [:]
    var recipeToIndex: [String: Int] = [:]
    var recipesWithImages: [String] = []
    
    //dummy data for default
    let postTitle =  ["Tomato Egg", "Egg Tomato", "Potato beef", "Beff Potato"]
    let postImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    let postDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
    
    // MARK: - View and Skeleton View Setup
    
    func createGetAllDataThread(){
        // move get data to async thread to show loading animation
        DispatchQueue.main.async {
            for _ in 0..<100{
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
        bg = Styler.setBackground(bg: "background")
        view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        // Set collectionView background and padding
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        // Set navigation title
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
        
        let parameters: [String: Any] = [
            "liked_recoms": getPastLikes()!,
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
                self.getImages()
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
    
    //Mark: Data persistence stuff. Getting past liked IDS from memory.
    private func getPastLikes()->[Int]?{
        let likeIDSObjArr = getLikesAsObjects()!
        var pastLikes = [Int]()
        
        for id in likeIDSObjArr{
            pastLikes.append(id.id!)
        }
        
        return pastLikes
    }
    
    private func getLikesAsObjects()->[likedRecipeID]?{
        do {
            let data = try Data(contentsOf: likedRecipeID.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [likedRecipeID]
        }catch{
            os_log(.error, log: OSLog.default, "failed to load past like ids")
        }
        return []
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
            let recipeCleaned: String = recipe.removeExtraSpaces()
            let queryItems:[URLQueryItem] = [
                URLQueryItem(name: "query", value: recipeCleaned)]
            
            var urlComps = URLComponents(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/site/search")!
            urlComps.queryItems = queryItems
            let result = urlComps.string
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
                    //                    print("got image")
                    if (recipeData.recipes != nil) {
                        let imageUrl = URL(string: recipeData.recipes![0]!.image)!
                        let data = try? Data(contentsOf: imageUrl)
                        if let imageData = data {
                            let image = UIImage(data: imageData)!
                            self.recipeToImage[recipe] = image
                            print(image)
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
                let title = recipesWithImages[indexPath.row]
                detail.name = title
                detail.picture = self.recipeToImage[title]!
                detail.descript = self.recipeRecs?.steps![self.recipeToIndex[title]!]
                let id = self.recipeRecs?.recomIDS![self.recipeToIndex[title]!]
                detail.id = id
                print("ID for what we're saving is: " + String(id!))
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeToImage.count
        
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: exploreItemCollectionViewCell = exploreItemCollectionViewCell()
        let index = indexPath.row
        let title = recipesWithImages[index]
        let image = self.recipeToImage[title]
        if (image != nil)   {
            if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? exploreItemCollectionViewCell{
                content.Image.image = image!
                content.Title.text = title
                cell = content
            }
        }
        
        else    {
            if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? exploreItemCollectionViewCell{
                content.Image.image = image!
                content.Title.text = title
                cell = content
            }
        }
        
        // Customize Cell
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 20
        //        cell.contentView.alpha = 0.6
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetsWidth = collectionView.contentInset.left + collectionView.contentInset.right + 10
        let cellSize = (collectionView.frame.width - insetsWidth)/2
        return CGSize(width: cellSize, height: cellSize)
    }
    
}

extension String {
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
}


