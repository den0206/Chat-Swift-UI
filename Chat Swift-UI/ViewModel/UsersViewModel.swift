//
//  UsersViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import Foundation

class UsersViewModel : ObservableObject {
    
//    @EnvironmentObject var userInfo : UserInfo
    @Published var users = [FBUser]()
    @Published var showAlert = false

    var errorMessage : String = ""
    
    func loadUser(currentUid : String) {
        FBFiresore.fetchUsers(currentUid: currentUid) { (result) in
            
            switch result {
            
            case .success(let users):
                self.users = users
                print(users.count)

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print(self.errorMessage)
            }
        }
    }

}
