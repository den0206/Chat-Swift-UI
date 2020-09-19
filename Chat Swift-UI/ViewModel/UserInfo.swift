//
//  UserInfo.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation

class UserInfo : ObservableObject {
    
    enum AuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenTicated : AuthState = .undefined
    
    func configureStateDidChange() {
        
        self.isUserAuthenTicated = .signedOut
        
    }
}
