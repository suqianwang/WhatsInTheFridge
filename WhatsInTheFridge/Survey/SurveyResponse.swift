//
//  Survey.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/16/21.
//

import Foundation
import OSLog

class SurveyResponse: NSObject, NSCoding{
    
    // attributes
    var value:String?
    var key:String?
    
    //Mark: Archiving paths to data storage
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let surveyResponseArchiveURL = documentsDirectory.appendingPathComponent("surveyResponse")
    
    //Mark: Types?
    struct PropertyKey {
        static let key = "key"
        static let value = "value"
    }
    
    //Mark: Initialization
    init?(key:String, value:[String]){
        self.key = key
        self.value = value.joined(separator: ",")
    }

    init?(key:String, value:String){
        self.key = key
        self.value = value
    }
    
    //Mark: NSCoding for data persistence
    func encode(with aCoder: NSCoder){
        aCoder.encode(key, forKey: PropertyKey.key)
        aCoder.encode(value, forKey: PropertyKey.value)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let key = aDecoder.decodeObject(forKey: PropertyKey.key) as? String
        else{
            os_log("Unable to decode survey response question.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let value = aDecoder.decodeObject(forKey: PropertyKey.value) as? String
        else{
            os_log("Unable to decode survey response choices.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(key: key,value: value)
    }
    
}
