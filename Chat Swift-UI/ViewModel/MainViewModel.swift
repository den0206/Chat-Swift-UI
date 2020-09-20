//
//  MainVIewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI
import Foundation

class MainViewModel: ObservableObject {

    @Published var user : FBUser?
    
    var userName : String{
        return user!.name
    }
    
//    var avatarImage : UIImage? {
//        
//        guard let image = downloadImageFromData(picturedata: user!.avatarString) else {return nil}
//        return image
//    }
    
    func configureVM(userInfo : UserInfo) {
        
        self.user = userInfo.user
    }

}
