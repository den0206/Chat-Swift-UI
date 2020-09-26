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
    

}


