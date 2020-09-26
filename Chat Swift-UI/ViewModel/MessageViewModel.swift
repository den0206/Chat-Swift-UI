//
//  MessageViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation
import Firebase
import MLKit

class MessageViewModel : ObservableObject {
    
    @Published var text = ""
    @Published var messages = [Message]()
 
    
    func loadMessage(chatRoomId : String, userId : String) {
        
        firebaseReference(.Message).document(userId).collection(chatRoomId).order(by: "timeStamp", descending: false).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            guard !snapshot.isEmpty else {print("Empty") ; return}
            
            snapshot.documentChanges.forEach { (doc) in
                
                switch doc.type {
                
                case .added:
                    let message = try! doc.document.data(as: Message.self)
                    
                    DispatchQueue.main.async {
                        self.messages.append(message!)
                        print(self.messages.count)
                    }
                default :
                    return
                }
            }
            
            
        }
        
        
    }
    
    func sendMessage(chatRoomId : String, memberIds : [String], senderId : String) {
        
        let options = TranslatorOptions(sourceLanguage: .japanese, targetLanguage: .english)
      
        
        let translater = Translator.translator(options: options)
        
        guard ModelManager.modelManager().isModelDownloaded(TranslateRemoteModel.translateRemoteModel(language: .japanese)) && ModelManager.modelManager().isModelDownloaded(TranslateRemoteModel.translateRemoteModel(language: .english)) else {
            
            print("Not yet download")
            return
        }
        
        translater.translate(text) { (result, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            print(result)
        }
        
//        let message = Message(userId: senderId, msg: text, timeStamp: Date())
//
//        for id in memberIds {
//
//            do {
//                let _ = try firebaseReference(.Message).document(id).collection(chatRoomId).addDocument(from: message)
//
//
//            } catch(let error) {
//                print(error.localizedDescription)
//                return
//            }
//
//
//        }
//
//        updateRecent(chatRoomId: chatRoomId, lastMessage: text, currentId: senderId)
//
//        text = ""
//
//
        
    }
    
    
    
    
    
}
