//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        
        NavigationView {
            Text("Logedin User")
                .navigationBarTitle("Chat")
                .navigationBarItems(trailing:
                   Button(action: {
                    self.userInfo.isUserAuthenTicated = .signedOut
                   }, label: {
                        Text("Logout")
                    })
                )
        }
        
        
    }
}

