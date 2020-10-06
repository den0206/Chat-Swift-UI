//
//  UserProfileView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/06.
//

import SwiftUI

struct UserProfileView: View {
    
    var uid : String
    @ObservedObject var vm = UserProfileViewModel()
    
    var body: some View {
        VStack {
            Text(vm.user.name)
        }
        .onAppear {
            vm.loadUser(uid: uid)
        }
        
    }

}

