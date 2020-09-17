//
//  Service.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import Foundation
import FirebaseAuth
import SwiftUI

class AuthService {
    
    static func registerUser(email : String, password : String , name : String,completion :  @escaping(Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            
            let value = [kEMAIL : email,
                         kUSERID : uid,
                         kNAME : name ]
            
            setUserDefaults(values: value, key: kCURRENTUSER)
            firebaseReference(.User).document(uid).setData(value, completion: completion)
        }
        
    }
    
    static func loginUser(email : String, password : String , complation : AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: complation)
    }
    
    static func fetchCurrentUser(uid : String, completion : @escaping(User) -> Void) {
        
        firebaseReference(.User).document(uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dictionary = snapshot.data()!
                //
                //                UserDefaults.standard.setValue(snapshot.data()! as [String : Any], forKey: kCURRENTUSER)
                //                UserDefaults.standard.synchronize()
                //
                setUserDefaults(values: snapshot.data()! as [String : Any], key: kCURRENTUSER)
                
                
                let user = User(dictionary: dictionary)
                completion(user)
            }
        }
        
    }
}
