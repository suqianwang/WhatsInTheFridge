//
//  collectedPageCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//

import UIKit
import os.log

private let reuseIdentifier = "collectedCell"

class collectedPageCollectionViewController: UICollectionViewController {
    var collectedRecipes = [savedRecipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let savedCollects = loadCollected()
        
        if savedCollects?.count == 0{
            print("There are no saved collected recipes: you should see the defaults.")
            loadDefaults()
        }
        
        //otherwise use the default.
        else{
            print("There are saved collected recipes: attempting to load them.")
            collectedRecipes += savedCollects!
        }
        

        navigationItem.title = "Your Collected Recipes"
    }
    
    private func loadDefaults() {
        let defaultImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
        let defaultDescript = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. "
        
        guard let recipe1 = savedRecipe(name: "Tomato Egg", desc: defaultDescript, image: defaultImage) else {
            fatalError("Unable to load default recipe 1.")
        }
        
        guard let recipe2 = savedRecipe(name: "Egg Tomato", desc: defaultDescript, image: defaultImage) else {
            fatalError("Unable to load default recipe 2.")
        }
        
        collectedRecipes += [recipe1, recipe2]
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCollected"{
            let detail = segue.destination as! collectDetailViewController
            if let indexPath = self.collectionView?.indexPath(for: sender as! UICollectionViewCell){
                let selectedRecipe = collectedRecipes[indexPath.row]
                detail.name = selectedRecipe.name
                detail.picture = selectedRecipe.image
                detail.descript = selectedRecipe.description
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
        return collectedRecipes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        _ = indexPath.row
        let title = collectedRecipes[indexPath.row].name
        let image = collectedRecipes[indexPath.row].image
        if let content = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? collectedCollectionViewCell{
            content.configure(title, image)
            cell = content
        }
        
        return cell
    }
    
    private func loadCollected()->[savedRecipe]?{
        do {
            let data = try Data(contentsOf: savedRecipe.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [savedRecipe]
        }catch{
            os_log(.error, log: OSLog.default, "failed to load past collected")
        }
        return []
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
