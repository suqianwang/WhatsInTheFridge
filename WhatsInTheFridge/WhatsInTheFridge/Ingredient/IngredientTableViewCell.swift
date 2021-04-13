//
//  IngredientTableViewCell.swift
//  WhatsInTheFridge
//
//  Created by D on 4/12/21.
//

import UIKit
import os.log

//accroding to a post on stackoverflow, UITableView Already inherits from NSCoding
//Accoridng to a blogpost, all UIKit stuff inherits NSOBject
class IngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var ingredientName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Mark: Data structure for storage
    struct Ingredient{
        static let name = "name"
    }
    
    //Mark: NSCoding (stuff related to data persistence)
    override func encode(with aCoder: NSCoder){
        aCoder.encode(ingredientName, forKey:Ingredient.name)
    }
    
    //Mark: Properties. Specifies file location for storing data.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ingredients")
    
    required convenience init?(code aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Ingredient.name) as? String
        else{
            os_log("Unable to decode ingredient name.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name:ingredientName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
