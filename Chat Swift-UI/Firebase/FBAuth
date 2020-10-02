//
//  FBAuth.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/30.
//

import Firebase
import FirebaseFirestore
import MLKit

import Foundation

struct FBAuth{
     
    static func createUser(email: String , name: String, password: String, imagedata: Data, language: TranslateLanguage, completion :  @escaping( Result<Bool, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = result?.user else {
                completion(.failure(error!))
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let avatar = imagedata.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            let language = language.title
            
            let data = [kUSERID : uid,
                        kNAME : name,
                        kEMAIL : email,
                        kAVATAR : avatar,
                        kLANG : language]
            
            print(data)
            
            FBFiresore.updateFBUser(data: data, uid: uid) { (result) in
                completion(result)
            }
            
            completion(.success(true))
        }
        
        
    }
    
    static func loginUser(email : String, password : String,completion :  @escaping(Result<Bool, EmailAuthError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            var newError : NSError
            if let error = error {
                newError = error as NSError
                var authError : EmailAuthError?
                
                switch newError.code {
                case 17009:
                    authError = .incorrectPassword
                case 17008 :
                    authError = .invalidEmail
                case 17011 :
                    authError = .accountDoesnotExist
                default:
                    authError = .unknownError
                }
                completion(.failure(authError!))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func logOut(completion : @escaping(Result<Bool,Error>) -> Void) {
        
        do {  try Auth.auth().signOut()
            completion(.success(true))
        }
        catch let error {
            completion(.failure(error))
        }
       
    }
}
