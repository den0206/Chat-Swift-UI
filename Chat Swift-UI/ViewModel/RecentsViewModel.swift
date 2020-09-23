//
//  RecentsViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation
import UIKit

enum RecentViewAlert {
    case logOut
    case errorMessage
}

enum ModelType {
    case Users
    case Edit
}

class RecentsViewModel : ObservableObject {
    
    @Published var showAlert = false
    @Published var alertType : RecentViewAlert = .logOut
    @Published var modelType : ModelType = .Users
    @Published var showModel = false
    @Published var chatRoomId = ""
    @Published var memberIds = [String]()
    @Published var withUserAvatar : UIImage = .init()
    @Published var pushNav = false
    @Published var errorMessage = ""
    
    @Published var recents = [Recent]()
    
    func fetchRecents(userId : String) {
  
        firebaseReference(.Recents).whereField(kUSERID, isEqualTo: userId).order(by: kDATE, descending: true).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.alertType = .errorMessage
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            guard let snapshot = snapshot else {return}
            
            guard !snapshot.isEmpty else {
                self.alertType = .errorMessage
                self.errorMessage = "Not found Recents"
                self.showAlert = true
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                
                switch diff.type {
                
                case .added:
                    
                    let recent = Recent(dic: diff.document.data())
                    
                    if recent.lastMessage != "" {
                        self.recents.append( recent)
                    }
                    
                case .modified:
                    
                    let changeId = diff.document.documentID
                    
                    let changeRecent = Recent(dic: diff.document.data())
                    
                    for i in 0..<self.recents.count {
                        
                        if self.recents[i].id == changeId {
                            self.recents[i] = changeRecent
                            self.recents.sort(by: {$0.date > $1.date})
                        }
                        
                        if changeRecent.lastMessage != "" {
                            if !self.recents.contains(where: {return $0.id == changeRecent.id }) {
                                self.recents.append(changeRecent)
                            }
                        }
                        
                    }
                case .removed:
                    return
                }
            }
            
            
        }
        
    }
    
    
    
}
