//
//  BubbleView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import SwiftUI

struct ChatCell: View {
    
    var message : Message
    @AppStorage("current_user") var user = ""

    
    var body: some View {
        HStack(spacing : 15) {
            
            if message.userId != user {
                NickNameView(name: message.userId)
            } else {
                Spacer(minLength: 0)
            }
            
            VStack(alignment: message.userId == user ? .trailing : .leading, spacing: 5, content: {
                
                Text(message.msg)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(message.userId == user ? Color.green : Color.gray)
                    /// Bubble Tail
                    .clipShape(ChatBubble(myMessage: message.userId == user))
                    
                
                Text(message.timeStamp,style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.msg != user ? .trailing : .leading, 10)
            })
            
            if message.userId == user {
                NickNameView(name: message.userId)
            } else {
                Spacer(minLength: 0)
            }
            
        }
        .padding(.horizontal, 15)
        .id(message.id)
    }
}

//MARK: - Thunbnail

struct NickNameView : View {
    
    var name : String
    @AppStorage("current_user") var user = ""
    
    var body: some View {
        
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((name == user ? Color.gray : Color.green).opacity(0.5))
            .clipShape(Circle())
            /// menu Style
            .contentShape(Circle())
            .contextMenu {
                Text(name)
                    .fontWeight(.bold)
            }
           
    }
}

//MARK: - Bubble

struct ChatBubble : Shape {
    
    var myMessage : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, myMessage ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}
