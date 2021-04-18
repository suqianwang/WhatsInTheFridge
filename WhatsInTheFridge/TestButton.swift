//
//  ButtonViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/18/21.
//

import UIKit

class TestButton: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // TODO: questionable design choice
    @IBAction func button(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "surveyViewController") as? SurveyViewController{
            vc.setGiveSurvey(give: true)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
}
