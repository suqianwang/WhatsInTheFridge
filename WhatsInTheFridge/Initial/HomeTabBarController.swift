//
//  HomeViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/17/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    static let exploreTabIndex: Int = 0
    static let ingredientTabIndex: Int = 1
    static let mealTabIndex: Int = 2
    static let profileTabIndex: Int = 3

    @IBOutlet weak var TabBar: UITabBar!
    
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
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
