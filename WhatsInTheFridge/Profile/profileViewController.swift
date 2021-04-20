//
//  profileViewController.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/19/21.
//

import UIKit

class profileViewController: UIViewController {
    var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
