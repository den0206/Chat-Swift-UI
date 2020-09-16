//
//  AuthViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    var disableLoginButton : Bool {
        return !(loginEmail != "" && loginPassword != "")
    }
    var disableLoginColor : Color {
        return !(loginEmail != "" && loginPassword != "") ? Color.gray : Color.white
    }
    
    /// signUop
    @Published var signUpEmail = ""
    @Published var signUpPassword = ""
    @Published var PasswordConfirmation = ""
    
    var disableSignUpButton : Bool {
        return !(signUpPassword != "" && signUpEmail != "" && PasswordConfirmation != "")
    }
    var disableSignUpColor : Color {
        return !(signUpPassword != "" && signUpEmail != "" && PasswordConfirmation != "") ? Color.gray : Color.white
    }
    
    @Published var showSignUp = false
    @Published var showAlert = false
    var errorMessage = ""
    
    //MARK: - Functions
    
    
    func login() {
        
        guard loginEmail != "" && loginPassword != "" else {
            showAlert = true
            errorMessage = "項目を埋めてください"
            return
        }
        
        guard isValidEmail(loginEmail) else {
            showAlert = true
            errorMessage = "Emailの書式ではありません"
            return
        }
        
        print("Login")
        
    }
    
    //MARK: - Sign Up
    
    
    func signUp() {
        
        guard signUpPassword != "" && signUpEmail != "" && PasswordConfirmation != "" else {
            showAlert = true
            errorMessage = "項目を埋めてください"
            return
        }
        
        guard isValidEmail(signUpEmail) else {
            showAlert = true
            errorMessage = "Emailの書式ではありません"
            return
        }
        
        guard signUpPassword == PasswordConfirmation  else {
            showAlert = true
            errorMessage = "パスワードが一致しません"
            return
        }
        
        print("Sign Up")
        
    }
    
}
