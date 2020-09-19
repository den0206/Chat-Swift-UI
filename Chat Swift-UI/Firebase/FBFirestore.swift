//
//  FBFirestore.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation
import FirebaseFirestore

enum FBFiresore {
    static func fetchFBUser(uid : String, completion :  @escaping(Result<FBUser, Error>) -> Void) {
        
        let ref = Firestore.firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        
        getDocument(ref: ref) { (result) in
            
            switch result {
            
            case.success(let data) :
                guard let user = FBUser(dic: data) else {
                    completion(.failure(FirestoreError.noUser))
                    return
                }
                
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
 
        
    }
    
    static func updateFBUser(data : [String : Any], uid : String, completion : @escaping(Result<Bool, Error>) -> Void) {
        
        let ref = Firestore.firestore().collection(FBKeys.CollectionPath.users).document(uid)
        
        ref.setData(data, merge: true) { (error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
        }
    }
    
    fileprivate static func getDocument(ref : DocumentReference, comletion :  @escaping(Result<[String : Any] , Error>) -> Void) {
        
        ref.getDocument { (snaoshot, error) in
            
            if let error = error {
                comletion(.failure(error))
                return
            }
            
            guard let snapshot = snaoshot else {
                comletion(.failure(FirestoreError.noDocumentSNapshot))
                return
            }
            
            guard let data = snapshot.data() else {
                comletion(.failure(FirestoreError.noSnapshotData))
                return
            }
            comletion(.success(data))
    
        }
    }
}
