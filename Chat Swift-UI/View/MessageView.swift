//
//  MessageView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI

struct MessageView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Binding var chatRoomId : String
    
    var body: some View {
        
        VStack(spacing : 0) {
            
            
            /// Text field
            
            Text(chatRoomId)
        }
        
        
    }
}

