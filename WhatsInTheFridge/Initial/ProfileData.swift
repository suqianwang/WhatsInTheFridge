//
//  ProfileData.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/19/21.
//

import Foundation
import OSLog

// class object representing profile information of user
class ProfileData: NSObject, NSCoding{
    
    // attributes
    var userName:String?
    
    struct PropertyKey {
        static let username = "username"
    }
    
    //MARK: Archiving paths to data storage
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let profileResponseArchiveURL = documentsDirectory.appendingPathComponent("profile")
    
    //MARK: initializers
    override init() {
        // empty
    }
    
    init?(username:String){
        self.userName = username
    }
    
    //MARK: NSCoding for data persistence
    func encode(with aCoder: NSCoder){
        aCoder.encode(userName, forKey: PropertyKey.username)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.username) as? String
        else{
            os_log("Unable to decode user's name.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(username: name)
    }
    
}
