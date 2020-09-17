//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vm = MainViewModel()
    
    
    var body: some View {
        
        VStack {
            Text(vm.currentUser!.name)
            
            Button(action: {vm.logout()}) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .background(Color.red)
                    .clipShape(Capsule())
            }
            .fullScreenCover(isPresented: $vm.showAuth) {
                LoginView()
            }
        }

    }
}

