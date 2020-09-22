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
    @Binding var withUserAvatar : UIImage
    @Binding var showTab : Bool
    
    var body: some View {
        
        VStack(spacing : 0) {
            
            
            ScrollViewReader { reader in

                ScrollView {

                    VStack(spacing : 15) {

                        ForEach(vm.messages) { message in
                            
                            MessageCell(message: message, currentId: userInfo.user.uid, withUserAvatar: withUserAvatar)

                        }
                        .onChange(of: vm.messages) { (value) in
                            /// scroll to bottom get New Chat
                            reader.scrollTo(vm.messages.last?.id, anchor: .bottom)
                        }
                    }
                    .padding(.vertical)
                }

            }
            /// Text field
            MGTextField(text: $vm.text, sendAction: {vm.sendMessage(chatRoomId : chatRoomId, memberIds: memberIds, senderId: userInfo.user.uid)})
            
        }
        .onAppear {
            self.showTab = false
            self.vm.loadMessage(chatRoomId: chatRoomId, userId: userInfo.user.uid)
        }
        .onDisappear {
            
            self.showTab = true
        }
      
        
        
    }
}

/// Message Cell

struct MessageCell : View {
    var message : Message
    var currentId : String
    var withUserAvatar : UIImage

    var body: some View {
        
        HStack(spacing : 15) {
            
            if message.userId != currentId {
                AvatarView(withUserAvatar: withUserAvatar)
            } else {
                Spacer(minLength: 0)
            }
            
            VStack(alignment: message.userId == currentId ? .trailing : .leading , spacing: 5) {
                
                Text(message.msg)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(message.userId == currentId ? Color.green : Color.gray)
                     /// tail
                    .clipShape(ChatBubble(myMessage: message.userId == currentId))
                
                Text(message.timeStamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.userId != currentId ? .trailing : .leading, 10)
            }
            
            if message.userId == currentId {
                /// currentUser Avatar
            } else {
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 15)
        .id(message.id)
        
        
    }
}

struct AvatarView : View {
    
    var withUserAvatar : UIImage

    var body: some View {
        
        Image(uiImage: withUserAvatar)
            .resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
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
                .padding(.trailing, 5)
            }
            
            
        }.padding(.bottom, 5)
        
  
        
        
    }
}
