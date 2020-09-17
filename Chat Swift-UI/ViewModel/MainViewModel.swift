//
//  MainViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    
    var currentUser : User?
    @Published var showAuth = false
    

    init() {
        checkLogin()
    }
    
    func checkLogin() {
        if UserDefaults.standard.object(forKey: kCURRENTUSER) == nil {
            AuthService.fetchCurrentUser(uid: User.currentId()) { (user) in
                self.currentUser = user
                
            }
        } else {
            currentUser = User.currentUser()!
        }
    }
    
    func logout() {
        
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            showAuth = true
            
            print("Logout")
            
        } catch {
            print("Can't Log out")
        }
    }
    
}

