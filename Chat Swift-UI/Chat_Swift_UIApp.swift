//
//  Chat_Swift_UIApp.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import SwiftUI
import Firebase

@main
struct Chat_Swift_UIApp: App {
    
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        FirebaseApp.configure()
        return true
    }
}
