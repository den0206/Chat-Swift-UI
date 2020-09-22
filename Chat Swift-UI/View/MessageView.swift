//
//  MessageView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI

struct MessageView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : MessageViewModel = MessageViewModel()
    @Binding var chatRoomId : String
    @Binding var memberIds : [String]
    @Binding var showTab : Bool
    
    var body: some View {
        
        VStack(spacing : 0) {
            
            ForEach(memberIds, id : \.self) { id in
                Text(id)
                
            }
            /// Text field
            MGTextField(text: $vm.text, sendAction: {vm.sendMessage(chatRoomId : chatRoomId, memberIds: memberIds, senderId: userInfo.user.uid)})
            
        }
        .onAppear {
            self.showTab = false
        }
        .onDisappear {
            
            self.showTab = true
        }
      
        
        
    }
}

struct MGTextField : View {
    
    @Binding var text : String
    var sendAction : () -> Void
    
    var body: some View {
        
        HStack(spacing : 15) {
            TextField("Enter Message", text: $text)
                .padding(.horizontal)
                .frame(height : 45)
                .background(Color.primary.opacity(0.06))
                .clipShape(Capsule())
            
            if text != "" {
                Button(action: {self.sendAction()}) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                .padding(.horizontal)
            }
            
            
        }.padding(.bottom, 5)
        
  
        
        
    }
}
