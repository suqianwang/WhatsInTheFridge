//
//  likedDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//  Updated by D on 4/15/21

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
        bg_imageView = Styler.setBackground()
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
        
        // Do any additional setup after loading the view.
        recipeName.text = name
        recipePicture.image = picture
        recipeDescription.text = descript
        
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
            saveLikedPost()
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
    private func saveLikedPost(){
        //load current likes
        var currentLikes = NSKeyedUnarchiver.unarchiveObject(withFile: likedRecipe.ArchiveURL.path) as? [likedRecipe]
        //cast the current recipe to something
        var newLikedRecipe = likedRecipe(name: name, desc: descript, image: picture)
        //addit to the currentLikes
        currentLikes!.append(newLikedRecipe!)
        
        //save and check.
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currentLikes, toFile: likedRecipe.ArchiveURL.path)
        
        print("The save for liked post was successful: " + String(isSuccessfulSave))
        if isSuccessfulSave{
            os_log(.error, log: OSLog.default, "Ingredients successfully saved.")
        }
        else{
            os_log(.error, log: OSLog.default, "Failed to saved ingredients...")
        }
    }
    
}
