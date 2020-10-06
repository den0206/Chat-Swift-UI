//
//  RecentsViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation
import SwiftUI
import UIKit
import MLKit

enum RecentViewAlert {
    case checkDownload
    case errorMessage
}

enum ModelType {
    case Users
    case Edit
    case Profile
}

class RecentsViewModel : ObservableObject {
    
    @Published var showAlert = false
    @Published var alertType : RecentViewAlert = .errorMessage
    @Published var modelType : ModelType = .Users
    @Published var showModel = false
    @Published var chatRoomId = ""
    @Published var memberIds = [String]()
    @Published var withUserAvatar : UIImage = .init()
    @Published var withUserLang : TranslateLanguage = .english
    @Published var pushNav = false
    @Published var alert : Alert = Alert(title: Text(""))
    @Published var progress : Progress = Progress()
    @Published var recents = [Recent]()
    @Published var isLoading = false
    
    func checkDownloadedLang(  completion : @escaping(Bool) -> ())  {
        
        let langModel = TranslateRemoteModel.translateRemoteModel(language: self.withUserLang)
        
        if ModelManager.modelManager().isModelDownloaded(langModel) {
           completion(true)
        } else {
            
            
            self.alertType = .checkDownload
            self.showAlert = true
            self.alert = Alert(title: Text("モデルのダウンロード"), message: Text("相手の言語モデルをダウンロードしても宜しいでしょうか？"), primaryButton: .cancel(Text("Cancel").foregroundColor(.red)), secondaryButton: .default(Text("Download"), action: { [self] in
             
                
                progress = ModelManager.modelManager().download(langModel, conditions: ModelDownloadConditions(
                    allowsCellularAccess: false,
                    allowsBackgroundDownloading: true
                ))
                print(progress)
                if progress.completedUnitCount == 1 {
                    print("Call")
                    completion(true)
                }
                
                
            
            }))
           
        }
    }
    
    func fetchRecents(userId : String) {
        self.isLoading = true
        
        firebaseReference(.Recents).whereField(kUSERID, isEqualTo: userId).order(by: kDATE, descending: true).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.alertType = .errorMessage
                self.alert = Alert(title:Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
                self.showAlert = true
                return
            }
            guard let snapshot = snapshot else {return}
            
            guard !snapshot.isEmpty else {
                self.alertType = .errorMessage
                self.alert = Alert(title:Text("Error"), message: Text( "Not found Recents"), dismissButton: .default(Text("OK")))
                self.showAlert = true
                return
            }
            
          
            snapshot.documentChanges.forEach { (diff) in
                
                switch diff.type {
                
                case .added:
                    
                    let recent = Recent(dic: diff.document.data())
                    
                    if recent.lastMessage != "" {
                        self.recents.append( recent)
                        
                        if self.recents.count == snapshot.documents.count {
                            self.isLoading = false
                        }
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
