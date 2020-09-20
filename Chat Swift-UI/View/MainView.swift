//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI
import Firebase

struct MainView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var showAlert = false
    @State private var showModel = false
    @State private var chatRoomId = ""
    @State private var pushNav = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                NavigationLink(destination: MessageView(chatRoomId: $chatRoomId), isActive: $pushNav) {
                    
                }
                Text("Logedin User, \(userInfo.user.name)")
                Text(chatRoomId)
                
            }
            .navigationBarTitle("Chat", displayMode : .inline)
            .navigationBarItems(leading: Button(action: {
                
                self.showAlert = true
            }, label: {
                if userInfo.user.avatarString != "" {
                    Image(uiImage: downloadImageFromData(picturedata: userInfo.user.avatarString)!)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 30, height: 30)
                }
                
                
                
            }), trailing:
                Button(action: {
                    self.showModel = true
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                }))
            .sheet(isPresented: $showModel, content: {
                UsersView(selectedId: $chatRoomId, pushNav : $pushNav)
            })
            .alert(isPresented: $showAlert, content: { () -> Alert in
                
                Alert(title: Text("LogOut"), message: Text("ログアウトしますか？"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("ログアウト"), action: {
                    
                    FBAuth.logOut { (result) in
                        
                        switch result {
                        
                        case .success(_):
                            self.userInfo.isUserAuthenTicated = .signedOut
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }))
            })
            .onAppear {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                FBFiresore.fetchFBUser(uid: uid) { (result) in
                    switch result {
                    case .failure(let error) :
                        print(error.localizedDescription)
                    case .success(let user) :
                        self.userInfo.user = user
                    }
                }
                
            }
        }
        
        
        
        
    }
}

