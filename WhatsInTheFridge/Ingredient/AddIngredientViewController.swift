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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue"{
            ingredient = Ingredient(name: ingredientName.text!)!
        }
    }

}
