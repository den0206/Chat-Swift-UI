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
    @Published var isLoading = false

    var errorMessage : String = ""
    
    func loadUser(currentUid : String) {
        self.isLoading = true
        
        FBFiresore.fetchUsers(currentUid: currentUid) { (result) in
            
            
            switch result {
            
            case .success(let users):
                self.users = users
                self.isLoading = false

            case .failure(let error):
                self.isLoading = false

                self.errorMessage = error.localizedDescription
                print(self.errorMessage)
            }
        }
    }

}
