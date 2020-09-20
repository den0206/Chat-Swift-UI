//
//  MessageView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI

struct MessageView: View {
    
    @Binding var chatRoomId : String
    
    var body: some View {
        Text(chatRoomId)
    }
}

