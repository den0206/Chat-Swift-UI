//
//  UserInfo.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation
import FirebaseAuth

class UserInfo : ObservableObject {
    
    enum AuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenTicated : AuthState = .undefined
    @Published var user : FBUser = .init(uid : "", name : "", email : "", avatarString : "")
    
    var listnerHandle : AuthStateDidChangeListenerHandle?
    
    func configureStateDidChange() {
        listnerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            
            guard let user = user else {
                self.isUserAuthenTicated = .signedOut
                return
            }
            
            self.isUserAuthenTicated = .signedIn
//            FBFiresore.fetchFBUser(uid: user.uid) { (result) in
//                switch result {
//                case .failure(let error) :
//                    print(error.localizedDescription)
//                case .success(let user) :
//                    self.user = user
//                }
//            }
        })
      
        
    }
}
