//
//  likedCollectionViewCell.swift
//  WhatsInTheFridge
//
//  Created by Qintian Wu on 4/5/21.
//

import UIKit

class likedCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    func configure(_ title: String,_ image:UIImage ){
        Title.text = title
        Image.image = image
    }
}
