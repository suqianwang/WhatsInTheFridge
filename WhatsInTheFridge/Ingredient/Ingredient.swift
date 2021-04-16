//
//  Ingredient.swift
//  WhatsInTheFridge
//
//  Created by D on 4/13/21.
//

import UIKit
import os.log

class Ingredient : NSObject, NSCoding {
    
    //Mark: Properties
    var name: String
    
    //Mark: Archiving paths to data storage
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("ingredients")
    
    //Mark: Types?
    struct PropertyKey {
        static let name = "name"
    }
    
    //Mark: Initialization
    init?(name: String){
        guard !name.isEmpty else {
            return nil
        }
        self.name = name
    }
    
    //Mark: NSCoding (stuff related to data persistence)
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: PropertyKey.name)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        else{
            os_log("Unable to decode ingredient name.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(name:name)
    }
}

