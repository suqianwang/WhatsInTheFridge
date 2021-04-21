//
//  likedPageCollectionViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//  Modified by D on 4/14/21.
//  Modified by Suqian on 4/20/21.
//

import UIKit
import OSLog
import SkeletonView

class likedPageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    
    // MARK: - Attributes
    // Structure to store all of the recipes to show.
    var likedRecipes = [likedRecipe]() //from the custom class in /RecipeClasses/likedRecipes
    
    var bg: UIImageView!
    
    // MARK: - View Setup
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add custom background
        bg = Styler.setBackground(bg: "background")
        view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        navigationItem.title = "Your liked Recipes"
        
        // Set collectionView background and padding
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        collectionView.isSkeletonable = true
        collectionView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: UIColor.brown), animation: .none, transition: .none)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //        createGetAllDataThread()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        os_log("entering liked page collection")
        createGetAllDataThread()
    }
    
    func createGetAllDataThread(){
        // move get data to async thread to show loading animation
        DispatchQueue.main.async {
            // load saved liked recipes
            os_log("retrieving saved 'liked recipes' from archive")
            let savedLikes = self.loadLikes()
            if savedLikes?.count == 0{
                os_log("There are no saved like recipes: you should see the defaults.")
                self.loadDefaultLikes()
            }
            //otherwise use the default.
            else{
                os_log("There are saved liked recipes: attempting to load them.")
                self.likedRecipes += savedLikes!
            }
            
            self.collectionView.stopSkeletonAnimation()
            self.view.hideSkeleton(reloadDataAfter: true, transition: .none)
        }
    }
    
    // MARK: Function for resetting past likes. Call under viewDidLoad to remove all past likes.
    // FIXME: DON'T USE IN PRODUCTION ... what does this do?
    private func removeSavedLikes(){
        let emptyLikes = [likedRecipe]()
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: emptyLikes, requiringSecureCoding: false)
            try data.write(to: likedRecipe.ArchiveURL)
            os_log("liked recipes have been cleaned")
        }catch{
            os_log("could not clean liked recipes")
        }
        
    }
    
    // MARK: - Default data load & Local saved data load
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
    
    // MARK: - public methods to load
    // local saved data load through path defined in likerecipe.
    func loadLikes()->[likedRecipe]?{
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
    
    // MARK: UICollectionViewDataSource and customization
    
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
        // Customize Cell
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insetsWidth = collectionView.contentInset.left + collectionView.contentInset.right + 40
        let cellSize = (collectionView.frame.width - insetsWidth)/2
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "likedCell"
    }
    
}
