//
//  FBUser.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation

struct FBUser {
    
    let uid : String
    let name : String
    let email : String
    
    init(uid : String, name : String, email : String) {
        
        self.uid = uid
        self.name = name
        self.email = email
    }
}

extension FBUser {
    
    init?(dic : [String : Any]) {
        
        let uid = dic[FBKeys.User.uid] as? String ?? ""
        let name = dic[FBKeys.User.name] as? String ?? ""
        let email = dic[FBKeys.User.email] as? String ?? ""
        
        self.init(uid: uid, name: name, email: email)
    }
    
    static func dataDict(uid : String, name : String, email : String) -> [String : Any] {
        
        var data : [String : Any]
        
        if name != "" {
            data = [
                FBKeys.User.name : name,
                FBKeys.User.email : email,
                FBKeys.User.uid : uid
            ]
            
        } else {
            data = [
                FBKeys.User.email : email,
                FBKeys.User.uid : uid
            ]
        }
        
        return data
    }
}
