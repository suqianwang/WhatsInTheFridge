//
//  ChildViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/18/21.
//

import UIKit
import XLPagerTabStrip

class ChildViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var label: UILabel!
    var childNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = childNumber
        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
         return IndicatorInfo(title: "\(childNumber)")
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
