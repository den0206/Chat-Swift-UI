//
//  Global Extensions.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import Foundation

func getExampleImageUrl(_ word : String = "people") -> URL {
    let iValue = Int.random(in: 1 ... 99)
    let urlString : String = "https://source.unsplash.com/random/450×450/?\(word)\(iValue)"

    let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    return URL(string: encodeUrlString)!
}
