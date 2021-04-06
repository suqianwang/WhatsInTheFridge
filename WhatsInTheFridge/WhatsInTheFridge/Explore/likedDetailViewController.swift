//
//  likedDetailViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
