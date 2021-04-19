//
//  collectDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.

import UIKit

class collectDetailViewController: UIViewController {
    
    
    @IBOutlet weak var recipePicture: UIImageView!
    
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipeName: UILabel!
    
    var picture:UIImage!
    var name:String!
    var descript: String!
    
    // check whether the recipe is saved first
    // then configure the button to be liked or not liked in the viewDidLoad
    // fake it to be false at this time
    var liked = false
    var collected = false
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add custom background
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
        // Do any additional setup after loading the view.
        recipeName.text = name
        recipePicture.image = picture
        recipeDescription.text = descript
        
        //set up initial button status here -> detect whether or not recipe was already liked. 
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
            //[coredata] saving
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
    
    
}
