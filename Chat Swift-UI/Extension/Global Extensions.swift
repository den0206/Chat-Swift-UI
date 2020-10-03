//
//  Global Extensions.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import Foundation
import SwiftUI
import UIKit



func hideKeyBord() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}


private let dateFormat = "yyyyMMddHHmmss"


func dateFormatter() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}

func timeElapsed(date: Date) -> String {
    
    let seconds = NSDate().timeIntervalSince(date)
    
    var elapsed: String?
    
    
    if (seconds < 60) {
        elapsed = "Just now"
    } else if (seconds < 60 * 60) {
        let minutes = Int(seconds / 60)
        
        var minText = "min"
        if minutes > 1 {
            minText = "mins"
        }
        elapsed = "\(minutes) \(minText)"
        
    } else if (seconds < 24 * 60 * 60) {
        let hours = Int(seconds / (60 * 60))
        var hourText = "hour"
        if hours > 1 {
            hourText = "hours"
        }
        elapsed = "\(hours) \(hourText)"
    } else {
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "dd/MM/YYYY"
        
        elapsed = "\(currentDateFormater.string(from: date))"
    }
    
    return elapsed!
}


func authBackground() -> LinearGradient {
    
    return LinearGradient(gradient: .init(colors: [Color.black, Color.green]), startPoint: .top, endPoint: .bottom)
    
}

func setUserDefaults(values : [String : Any], key : String) {
    UserDefaults.standard.setValue(values, forKey: key)
    UserDefaults.standard.synchronize()
    
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



class KeyboardHeightHelper: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        self.listenForKeyboardNotifications()
    }
    
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                guard let userInfo = notification.userInfo,
                                                    let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                
                                                self.keyboardHeight = keyboardRect.height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: .main) { (notification) in
                                                self.keyboardHeight = 0
        }
    }
}


