//
//  RecipesCollectionViewCell.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/4/21.
//

import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    static let identifier = "recipeCollectionViewCell"
    
    private let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.textColor = .red
        
        // disables automatic constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
//        contentView.addSubview(nameLabel)
        let images = [UIImage(named: "cow"),
                      UIImage(named: "chicken"),
                      UIImage(named: "salad"),
                      UIImage(named: "crab"),
                      UIImage(named: "pizza")]
        imageView.image = images.randomElement() as? UIImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
}
