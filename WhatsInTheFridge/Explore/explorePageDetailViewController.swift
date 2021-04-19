//
//  explorePageDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//  Modified by D 4/17/21.
//
//  To do: upon loading, check if item is in liked or saved collections already so the heart is filled.
//

import UIKit
import os.log

class explorePageDetailViewController: UIViewController {

    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var Heart: UIButton!
    
    var picture:UIImage!
    var name:String!
    var descript: String!
    
    var liked = false
    var collected = false
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set background to custom
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)

        // Do any additional setup after loading the view.
        recipeName.text = name
        recipePicture.image = picture
        recipeDescription.text = descript
        
        liked = recipeAlreadyLiked(name: name, description: description)
        
        if liked{
            let initialHeart = UIImage(systemName: "heart.fill")
            Heart.setImage(initialHeart, for: .normal)
        }
        else{
            let initialHeart = UIImage(systemName: "heart")
            Heart.setImage(initialHeart, for: .normal)
        }
    }

    @IBAction func likePost(_ sender: UIButton) {
        var heart: UIImage
        print("Upon clicking heart button, was the item already liked?: " + String(liked))
        if liked{
            heart = UIImage(systemName: "heart")!
            print("You dislike this post")
            removeNewLike()
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
    
    //Mark: Check if the current item was already saved.
    private func recipeAlreadyLiked(name: String, description: String) -> Bool {
        var currentSavedLikes = NSKeyedUnarchiver.unarchiveObject(withFile: likedRecipe.ArchiveURL.path) as? [likedRecipe]
        var wasLiked : Bool
        let index = (currentSavedLikes?.firstIndex(where: {$0.name == name}))
        
        if index != nil{
            wasLiked = true
        }
        else{
            wasLiked = false
        }
        
        return wasLiked
    }
    
    //Mark: Update local save when a post is unliked.
    private func removeNewLike(){
        print("Attempting to remove like.")
        //load current likes
        var currentSavedLikes = NSKeyedUnarchiver.unarchiveObject(withFile: likedRecipe.ArchiveURL.path) as? [likedRecipe]
        
        //remove the like from it
        if let index = currentSavedLikes?.firstIndex(where: {$0.name == name}){
            currentSavedLikes?.remove(at: index)
            print("     Correctly detected place in the persisted data.")
        }
        
        print(currentSavedLikes?.count)
        
        //save it again
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentSavedLikes, toFile: likedRecipe.ArchiveURL.path)
    }
    
    // Mark: - Backend action when a post is liked.
    private func saveNewLike(){
        //load current likes
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
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to save new like...")
        }
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
