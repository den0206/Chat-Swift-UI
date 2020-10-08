//
//  UserProfileView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/06.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var vm = UserProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    var uid : String
    
    
    var body: some View {
        VStack {
            
            HStack {
                
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                })
                
                Spacer(minLength: 0)
            }
            .padding()
            
            if downloadImageFromData(picturedata: vm.user.avatarString) != nil {
                Image(uiImage: downloadImageFromData(picturedata: vm.user.avatarString)!)
                    .resizable()
                    .frame(width:90, height:90)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width:90, height:90)
                    .clipShape(Circle())
            }
            
            Spacer().frame(width: UIScreen.main.bounds.width, height: 30)
            
            VStack(spacing : 20) {
                
                Text(vm.user.name)
                    .font(.title)
                
                Text(vm.user.email)
                    .font(.caption2)
            }
            
            Spacer().frame(width: UIScreen.main.bounds.width, height: 70)
            
            HStack {
                
                Button(action: {
                        self.presentationMode.wrappedValue.dismiss()}, label: {
                    Text("Close")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal,40)
                        .background(Color.red)
                        .clipShape(Capsule())
                        
                })
                
                Button(action: {print("Message")}, label: {
                    Text("Message")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal,40)
                        .background(Color.green)
                        .clipShape(Capsule())
                })
            }
            
            Spacer()
        }
        .onAppear {
            vm.loadUser(uid: uid)
        }
        
    }

}

