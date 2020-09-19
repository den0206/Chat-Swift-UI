//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        
        NavigationView {
            Text("Logedin User, \(userInfo.user.name)")
                .navigationBarTitle("Chat")
                .navigationBarItems(trailing:
                   Button(action: {
                    self.userInfo.isUserAuthenTicated = .signedOut
                   }, label: {
                        Text("Logout")
                    })
                )
                .onAppear {
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    FBFiresore.fetchFBUser(uid: uid) { (result) in
                        switch result {
                        case .failure(let error) :
                            print(error.localizedDescription)
                        case .success(let user) :
                            self.userInfo.user = user
                        }
                    }
                    
                }
        }
        
        
    }
}

