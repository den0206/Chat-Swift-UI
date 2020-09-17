//
//  User.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import Foundation
import FirebaseAuth

class User {
    
    var name : String
    var uid : String
    var email : String
    
    init(dictionary : [String : Any]) {
        self.name = dictionary[kNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        self.uid = dictionary[kUSERID] as? String ?? ""
//        self.profileImageData = dictionary[kPROFILE_IMAGE] as? String ?? ""
//        self.bio = dictionary[kBIO] as? String ?? ""
    }
    
    class func currentId() -> String {
        
        guard let currentUser = Auth.auth().currentUser else {return ""}
        
        return currentUser.uid
    }
       
    
    class func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            
            if let dictiobnary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return User(dictionary: dictiobnary as! [String : Any])
            }
        }
        
        return nil
    }
    
}


