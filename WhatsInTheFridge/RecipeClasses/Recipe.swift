//
//  Recipe.swift
//  WhatsInTheFridge
//
//  Created by D on 4/14/21.
//

import UIKit
import os.log

//Source Class. Need two subclasses for different storage areas.

class Recipe : NSObject, NSCoding {
    
    //Mark: Class Properties
    var name: String
    var desc: String
    var image: UIImage //based on likedDetailViewController
    
    //Mark: Default image
    let defaultImage = #imageLiteral(resourceName: "egg_tomato.jpeg")
    
    //Mark: Types?
    struct PropertyKey {
        static let name = "name"
        static let image = "image"
        static let desc = "description"
    }
    
    //Mark: Initialization
    init?(name: String, desc: String, image: UIImage){
        guard !name.isEmpty else {
            return nil
        }
        guard !desc.isEmpty else {
            return nil
        }
        
        self.name = name
        self.desc = desc
        
        //default image if something funky got passed in. note: cannot do nil check here since UIImage cannot be nil by default unless the source was optional (marked with?)
        if image.size.width != 0 {
            self.image = image
        }
        else {
            self.image = defaultImage
        }
    }
    
    //Mark: NSCoding (stuff related to data persistence)
    func encode(with aCoder: NSCoder){
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(desc, forKey: PropertyKey.desc)
        aCoder.encode(image, forKey: PropertyKey.image)
    }

    //Mark: TODO: Default values for bad decodes.
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        else{
            os_log("Unable to decode recipe name.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as? String
        else{
            os_log("Unable to decode recipe desc.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        else{
            os_log("Unable to decode recipe image.", log: OSLog.default, type: .debug)
            return nil
        }
                                               
        self.init(name: name, desc:desc, image:image)
    }
}
