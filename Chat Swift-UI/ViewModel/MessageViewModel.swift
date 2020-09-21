//
//  MessageViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/21.
//

import Foundation

class MessageViewModel : ObservableObject {
    
    @Published var text = ""
    @Published var messages = [Message]()
    
    
}
