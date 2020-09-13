//
//  Message.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import Foundation
import FirebaseFirestoreSwift

struct Message : Codable, Identifiable, Hashable {
    
    @DocumentID var id : String?
    var user : String
    var msg : String
    var timeStamp : Date
    
    enum CodingKeys : String, CodingKey {
        case id
        case user
        case msg
        case timeStamp
    }
}
