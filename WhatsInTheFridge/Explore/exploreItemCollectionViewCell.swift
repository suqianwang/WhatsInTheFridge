//
//  exploreItemCollectionViewCell.swift
//  whats-in-the-fridge
//
//  Created by Qintian Wu on 3/25/21.
//

import UIKit

class exploreItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    func configure(_ title: String,_ image:UIImage ){
        Title.text = title
        Image.image = image
    }

    
}
