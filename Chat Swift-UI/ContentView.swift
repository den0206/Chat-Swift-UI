//
//  ContentView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        
        Group {
            if userInfo.isUserAuthenTicated == .undefined {
                Text("Loading")
            } else if userInfo.isUserAuthenTicated == .signedOut {
                LoginView()
            } else {
                MainView()
            }
        }
        .onAppear {
            self.userInfo.configureStateDidChange()
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
