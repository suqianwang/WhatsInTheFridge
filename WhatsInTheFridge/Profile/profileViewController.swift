//
//  profileViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/19/21.
//  Modified by Suqian Wang on 4/20/21.
// TODO: Load user name saved date to profile

import UIKit

class profileViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    
    let profile:ProfileData = SignupViewController.loadProfile()!
    var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = profile.userName
        bg = Styler.setBackground(bg: "background")
        view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
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
