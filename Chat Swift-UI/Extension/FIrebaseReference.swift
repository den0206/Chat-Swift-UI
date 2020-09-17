//
//  FIrebaseReference.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import Foundation
import FirebaseFirestore

enum References : String {
    case User
    case Message
   
    
}

func firebaseReference(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}

