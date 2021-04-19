//
//  IngredientTableViewCell.swift
//  WhatsInTheFridge
//
//  Created by Dian Niu on 4/12/21.
//

import UIKit

//accroding to a post on stackoverflow, UITableView Already inherits from NSCoding
//Accoridng to a blogpost, all UIKit stuff inherits NSOBject
class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientName.borderStyle = .none
        ingredientName.textColor = UIColor.brown
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
