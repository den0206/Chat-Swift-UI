//
//  LoginView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct LoginView: View {
    
    enum Action : Identifiable{
        case signUp, resetPassword
        
        var id : Int {
            hashValue
        }
    }
    
    @State private var showSheet  = false
    @State private var action : Action?
    
    var body: some View {
    
        SignInWithEmailView(showSheet: $showSheet, action: $action)
            .sheet(item: $action) { item in
                switch item {
                case .signUp :
                    SignUpView()
                case .resetPassword :
                    ForgotPasswordView()
                }
            }
//            .sheet(isPresented: $showSheet) {
//
//                if self.action == .signUp {
//                    SignUpView()
//                }
//
//                if self.action == .resetPassword {
//                    ForgotPasswordView()
//                }
//            }
            
       
    }
    
  
}
