//
//  likedDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//  Updated by D on 4/15/21
//
// To do: default load for a detail view heart image should be liked (filled).

import UIKit
import os.log

class likedDetailViewController: UIViewController {
    
    @IBOutlet weak var recipePicture: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeDescription: UITextView!
    
    var picture:UIImage!
    var name:String!
    var descript: String!
    
    //fake the buttons to be false here
    var liked = false
    var collected = false
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add custom background
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
        
        recipePicture.image = picture
        recipeDescription.text = descript
        
        
        //We already know this item was liked. Should only have the ability to remove recipes here. 
    }
    
    @IBAction func like(_ sender: UIButton) {
        var heart: UIImage
        if liked{
            heart = UIImage(systemName: "heart")!
            print("You dislike this post")
            //[coredata] deleting
        } else{
            heart = UIImage(systemName: "heart.fill")!
            print("You like this post")
            //saveLikedPost()
        }
        sender.setImage(heart, for: .normal)
        liked = !liked
    }
    
    @IBAction func collect(_ sender: UIButton) {
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
    
    //Mark : - Functions to update and load from persistent data.
    //NOTE: THIS IS THE SECTION OF THE APP TO SEE PREVIOUS SAVED RECIPES.
    private func saveLikedPost(){
        let url = likedRecipe.ArchiveURL
        do{
            let data = try Data(contentsOf: url)
            //load current likes
            var currentLikes:[likedRecipe] = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [likedRecipe]
            
            //cast the current recipe to something
            let newLikedRecipe = likedRecipe(name: name, desc: descript, image: picture)
            
            //add the current thing to the array we're saving
            if currentLikes.count > 0{
                currentLikes.append(newLikedRecipe!)
            }
            else {
                currentLikes = [newLikedRecipe!]
            }
            
            // save data to archive
            let updatedLikes = try NSKeyedArchiver.archivedData(withRootObject: currentLikes, requiringSecureCoding: false)
            try updatedLikes.write(to: url)
            os_log("The save for liked post was successful")
        }catch{
            os_log("could not save liked posts into archive")
        }
        
    }
    
}
