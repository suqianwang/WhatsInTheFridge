//
//  RecipesViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/4/21.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet weak var data: UILabel!
    var responses: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.text = "response"
        // Do any additional setup after loading the view.
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
