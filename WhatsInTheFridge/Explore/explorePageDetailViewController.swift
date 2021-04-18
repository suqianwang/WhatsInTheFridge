//
//  explorePageDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//

import UIKit
import os.log

class explorePageDetailViewController: UIViewController {

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDescription: UITextView!
    
    var picture:UIImage!
    var name:String!
    var descript: String!
    
    var liked = false
    var collected = false
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set background to custom
        bg_imageView = Styler.setBackground()
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)

        // Do any additional setup after loading the view.
        recipeName.text = name
        recipePicture.image = picture
        recipeDescription.text = descript
        
    }
    

    @IBAction func likePost(_ sender: UIButton) {
        var heart: UIImage
        if liked{
            heart = UIImage(systemName: "heart")!
            print("You dislike this post")
            //[coredata] deleting
        } else{
            heart = UIImage(systemName: "heart.fill")!
            print("You like this post")
            saveNewLike()
        }
        sender.setImage(heart, for: .normal)
        liked = !liked
    }
    
    @IBAction func collectPost(_ sender: UIButton) {
        var heart: UIImage
        if collected{
            heart = UIImage(systemName: "star")!
            print("You discollect this post")
            //[coredata] deleting
        } else{
            heart = UIImage(systemName: "star.fill")!
            print("You collect this post")
            //[coredata] saving
        }
        sender.setImage(heart, for: .normal)
        collected = !collected
    }
    
    // Mark: - Updating local save data.
    private func saveNewLike(){
        //TODO DIAN: CHECK LIKED AND COLLECTED FOR GUARDS.
        
        print("We are saving a liked item.")
        
        //load current
        var currentSavedLikes = NSKeyedUnarchiver.unarchiveObject(withFile: likedRecipe.ArchiveURL.path) as? [likedRecipe]
        
        //conforming to the vars at the top
        let newLike = likedRecipe(name: name, desc: descript, image: picture)!
        
        if currentSavedLikes?.count == nil {
            currentSavedLikes = [newLike]
        }
        else{
            //add on the recipe we're looking at here
            currentSavedLikes?.append(newLike)
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentSavedLikes, toFile: likedRecipe.ArchiveURL.path)
        
        //save to file
        if isSuccessfulSave{
            os_log(.error, log: OSLog.default, "New like successfully saved.")
            //let testSave = NSKeyedUnarchiver.unarchiveObject(withFile: likedRecipe.ArchiveURL.path) as? [likedRecipe]
            //for recipe? in testSave {
              //  print(recipe.name)
            //}
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to save new like...")
        }
        print("- - -")
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
