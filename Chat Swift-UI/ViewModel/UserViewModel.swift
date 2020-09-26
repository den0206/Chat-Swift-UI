//
//  UserViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation
import MLKit

struct UserViewModel {
    var email = ""
    var password = ""
    var fullname = ""
    var confirmPassword = ""
    var imageData : Data = .init(count : 0)
    var language : TranslateLanguage = .english
    
    var isSignUpComplete : Bool {
        if test_Mode {
            if !selectedImage() || !isEmailValid(_email: email) || isEmpty(_field: fullname) || !passwordsMatch(_confirmPW: confirmPassword) {
                return false
            }
            return true
        } else {
            if !selectedImage() || !isEmailValid(_email: email) || isEmpty(_field: fullname) || !isPasswordValid(_password: password) || !passwordsMatch(_confirmPW: confirmPassword) {
                return false
            }
            return true
        }
       
    }
    
    var isLoginComplete : Bool {
        
        if isEmpty(_field: email) || isEmpty(_field: password){
            return false
        }
        return true
    }
    //MARK: - Validates
    
    func passwordsMatch(_confirmPW : String) -> Bool {
        return _confirmPW == password
    
    }
    
    func isEmpty(_field : String) -> Bool {
        
        return _field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func selectedImage() -> Bool {
        return !(self.imageData == .init(count :0))
    }
    func isEmailValid(_email : String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
   
    func isPasswordValid(_password : String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluate(with: password)
    }
    
    //MARK: - Error String
    
    var validImageText : String {
        if selectedImage() {
            return ""
        } else {
            return "画像を選択してください"

        }
    }
    
    var validNameText : String {
        if !isEmpty(_field: fullname) {
            return ""
        } else {
            return "名前を入力してください"
        }
    }
    
    
    var validEmailText : String {
        if isEmailValid(_email: email) {
            return ""
        } else {
            return "Emailの書式を入力してください"
        }
    }
    
    var validPasswordText : String {
        if isPasswordValid(_password: password){
            return ""
        } else {
            return "8文字以上で、大文字もふくめてください"
        }
    }
    
    var validConfirmPasswordText : String {
        if passwordsMatch(_confirmPW: confirmPassword) {
            return ""
        } else {
            return "確認用パスワードが一致しません"
        }
    }
    
    
   
}
