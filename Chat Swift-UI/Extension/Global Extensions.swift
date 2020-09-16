//
//  Global Extensions.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import Foundation
import SwiftUI


func authBackground() -> LinearGradient {
    
    return LinearGradient(gradient: .init(colors: [Color.black, Color.green]), startPoint: .top, endPoint: .bottom)
    
}

func isValidEmail(_ string: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       let result = emailTest.evaluate(with: string)
       return result
}

func getExampleImageUrl(_ word : String = "people") -> URL {
    let iValue = Int.random(in: 1 ... 99)
    let urlString : String = "https://source.unsplash.com/random/450×450/?\(word)\(iValue)"

    let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return URL(string: encodeUrlString)!
}
