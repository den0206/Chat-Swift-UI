//
//  RecentsViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation

class RecentsViewModel : ObservableObject {
    
    @Published var showAlert = false
    @Published var showModel = false
    @Published var chatRoomId = ""
    @Published var pushNav = false
    
    @Published var recents = [Recent]()
    
    func fetchRecents(userId : String) {
        
        FBFiresore.fetchRecents(userId: userId) { (result) in
            
            switch result {
            
            case .success(let recents):
                self.recents = recents
                print(recents.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
}
