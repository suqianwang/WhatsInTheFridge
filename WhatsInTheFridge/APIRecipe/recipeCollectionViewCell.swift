//
//  recipeCollectionViewCell.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/18/21.
//

import UIKit

class recipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
        print("inside")
//      container.layer.cornerRadius = 6
//      container.layer.masksToBounds = true
    }
}
