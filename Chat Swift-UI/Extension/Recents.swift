//
//  Recents.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore

func startPrivateChat(currentUser : FBUser, user2 : FBUser) -> String {
    let currentUID = currentUser.uid
    let user2Id = user2.uid
    var chatRoomId : String
    
    let value = currentUID.compare(user2Id).rawValue
    
    if value < 0 {
        chatRoomId = currentUID + user2Id
    } else {
        chatRoomId = currentUID + user2Id
    }
    
    let userIds = [currentUID, user2Id]
    
    createRecentChat(userIds: userIds, currentUID: currentUID, chatRoomId: chatRoomId, users: [currentUser,user2])
    return chatRoomId
}

func createRecentChat(userIds : [String], currentUID : String, chatRoomId : String, users : [FBUser]) {
    
    var tempMembsers = userIds
    
    firebaseReference(.Recents).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data()
                
                if let currentUserId = currentRecent[kUSERID] {
                    if userIds.contains(currentUserId as! String) {
                        tempMembsers.remove(at: tempMembsers.firstIndex(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in tempMembsers {
            createRecentToFireStore(userId: userId, currentUID: currentUID, chatRoomId: chatRoomId, userIds: userIds, users: users)
        }
    }
    
    
}

func createRecentToFireStore(userId : String, currentUID : String,chatRoomId : String, userIds : [String], users : [FBUser]?){
    
    let localReference = firebaseReference(.Recents).document()
    let recentId = localReference.documentID
    
    var withUser : FBUser?
    
    

    if users != nil && users!.count > 0 {
        
        if userId == currentUID {
            withUser = users?.last
        } else {
            withUser = users?.first
        }
    }
    
   let  recent = [kRECENTID : recentId,
              kUSERID : userId,
              kCHATROOMID : chatRoomId,
              kMEMBERS : userIds,
              kWITHUSERFULLNAME : withUser!.name,
              kWITHUSERUSERID : withUser!.uid,
              kPROFILE_IMAGE : withUser!.avatarString,
              kLASTMESSAGE : "",
              kCOUNTER : 0,
              kDATE : Timestamp(date: Date())
             
   ] as [String : Any]
    
    localReference.setData(recent)
    
    
}
