//
//  UserProfileViewXModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/06.
//

import Foundation

class UserProfileViewModel : ObservableObject {
    
    @Published var user : FBUser = FBUser(uid: "", name: "", email: "", avatarString: "", lang: .japanese)
    
    
    func loadUser(uid : String) {
        FBFiresore.fetchFBUser(uid: uid) { (result) in
            switch result {
            
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
