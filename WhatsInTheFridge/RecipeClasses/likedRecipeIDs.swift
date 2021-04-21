//
//  likedRecipeWithID.swift
//  WhatsInTheFridge
//
//  Created by D on 4/20/21.
//

import UIKit
import os.log

class likedRecipeID: NSObject, NSCoding {
    
    //Mark: Class Properties
    var id: Int?
    
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = documentsDirectory.appendingPathComponent("likedRecipeID")
    
    //Mark: Types?
    struct PropertyKey {
        static let id = "id"
    }
    
    //Mark: Initialization
    init?(id: Int){
        self.id = id
    }
    
    //Mark: NSCoding (stuff related to data persistence)
    func encode(with aCoder: NSCoder){
        aCoder.encode(id, forKey: PropertyKey.id)
    }

    //Mark: TODO: Default values for bad decodes.
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? Int
        else{
            os_log("Unable to decode recipe ID.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(id:id)
    }
}
