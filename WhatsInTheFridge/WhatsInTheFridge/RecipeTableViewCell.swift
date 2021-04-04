//
//  RecipeTableViewCell.swift
//  WhatsInTheFridge
//
//  Created by Billy Luqiu on 4/3/21.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeID: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
