//
//  LoginView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct LoginView: View {
    
    enum Action {
        case none
        case signUp, resetPassword
    }
    
    @State private var showSheet  = false
    @State private var action = Action.none {
        willSet {
            showSheet = newValue != .none
        }
    }
    
    var body: some View {
    
        SignInWithEmailView(showSheet: $showSheet, action: $action)
            .sheet(isPresented: $showSheet) {
                
                if self.action == .signUp {
                    SignUpView()
                }
                
                if self.action == .resetPassword {
                    ForgotPasswordView()
                }
            }
            
       
    }
    
  
}
