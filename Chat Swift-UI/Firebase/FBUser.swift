//
//  FBUser.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation
import MLKit

struct FBUser : Hashable{
    
    let uid : String
    let name : String
    let email : String
    var avatarString : String
    var lang : TranslateLanguage = .japanese
    
    init(uid : String, name : String, email : String, avatarString : String, lang : TranslateLanguage) {
        
        self.uid = uid
        self.name = name
        self.email = email
        self.avatarString = avatarString
        self.lang = lang
    }
}

extension FBUser {
    
    init?(dic : [String : Any]) {
        
        let uid = dic[kUSERID] as? String ?? ""
        let name = dic[FBKeys.User.name] as? String ?? ""
        let email = dic[FBKeys.User.email] as? String ?? ""
        let avatar = dic[kAVATAR] as? String ?? ""

        let lang = encodelanguage(langString: dic[kLANG] as? String ?? "")
        
        self.init(uid: uid, name: name, email: email, avatarString : avatar, lang : lang)
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

func encodelanguage(langString : String) -> TranslateLanguage {
    
    var language : TranslateLanguage = .vietnamese
    
    TranslateLanguage.allLanguages().forEach { (lang) in
        if lang.title == langString {
            language = lang
        }
    }

    return language

}
