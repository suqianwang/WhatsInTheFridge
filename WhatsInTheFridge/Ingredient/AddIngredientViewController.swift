//
//  AddIngredientViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/5/21.
//

import UIKit

class AddIngredientViewController: UIViewController {


    @IBOutlet weak var ingredientName: UITextField!
    var ingredient = Ingredient(name: "Default Ingredient")
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add background
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue"{
            ingredient = Ingredient(name: ingredientName.text!)!
        }
    }

}
