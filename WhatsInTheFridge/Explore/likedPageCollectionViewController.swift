//
//  likedPageCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//  Modified by D on 4/14/21.
//
//  To do: default load for a detail view should be liked.
//

import UIKit
import os.log

class likedPageCollectionViewController: UICollectionViewController {
    // Mark : - Structure to store all of the recipes to show.
    var likedRecipes = [likedRecipe]() //from the custom class in /RecipeClasses/likedRecipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom background
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        let savedLikes = loadLikes()
        
        if savedLikes?.count == 0{
            print("There are no saved like recipes: you should see the defaults.")
            loadDefaultLikes()
        }
        
        //otherwise use the default.
        else{
            print("There are saved liked recipes: attempting to load them.")
            likedRecipes += savedLikes!
        }
        
        navigationItem.title = "Your liked Recipes"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    // Mark: Function for resetting past likes. Call under viewDidLoad to remove all past likes.
    // DON'T USE IN PRODUCTION.
    private func removeSavedLikes(){
        let currentLikes = [likedRecipe]()
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentLikes, toFile: likedRecipe.ArchiveURL.path)
        
        print("The save for liked post was successful: " + String(isSuccessfulSave))
        if isSuccessfulSave{
            os_log(.error, log: OSLog.default, "Ingredients successfully saved.")
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to saved ingredients...")
        }
    }
    
    // Mark : - Default data load & Local saved data load
    private func loadDefaultLikes(){
        //using previous dummy data.
        let defaultImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
        let defaultDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
        
        guard let recipe1 = likedRecipe(name: "Tomato Egg", desc: defaultDescript, image: defaultImage) else {
            fatalError("Unable to load default recipe 1.")
        }
        
        guard let recipe2 = likedRecipe(name: "Egg Tomato", desc: defaultDescript, image: defaultImage) else {
            fatalError("Unable to load default recipe 2.")
        }
        
        likedRecipes += [recipe1, recipe2]
    }
    
    // local saved data load through path defined in likerecipe.
    private func loadLikes()->[likedRecipe]?{
        do {
            let data = try Data(contentsOf: likedRecipe.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [likedRecipe]
        }catch{
            os_log(.error, log: OSLog.default, "failed to load ingredients")
        }
        return []
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showLiked"{
            let detail = segue.destination as! likedDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                let selectedRecipe = likedRecipes[indexPath.row]
                detail.name = selectedRecipe.name
                detail.picture = selectedRecipe.image
                detail.descript = selectedRecipe.desc
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
        return likedRecipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        let index = indexPath.row
        let title = likedRecipes[index].name
        let image = likedRecipes[index].image
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as? likedCollectionViewCell{
            content.configure(title, image)
            cell = content
        }

        return cell
    }


}
