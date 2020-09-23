//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI
import Firebase

struct RecentsView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : RecentsViewModel = RecentsViewModel()
    @State private var didAppear = false
    @Binding var showTab : Bool
 
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                ForEach(vm.recents) { recent in
                    
                    NavigationLink(destination: MessageView(chatRoomId: $vm.chatRoomId, memberIds: $vm.memberIds, withUserAvatar: $vm.withUserAvatar, showTab: $showTab), isActive: $vm.pushNav) {
                        
                        RecentCell(recent: recent)
                            .onTapGesture {
                                self.vm.chatRoomId = recent.chatRoomId
                                self.vm.memberIds = [userInfo.user.uid, recent.withUserId]
                                self.vm.withUserAvatar = downloadImageFromData(picturedata: recent.withUserAvatar)!
                                self.showTab = false
                                self.vm.pushNav = true
                            }
                    }

                }

            }
            .navigationBarTitle("Chat", displayMode : .inline)
            .navigationBarItems(leading: Button(action: {
                self.vm.modelType = .Edit
                self.vm.showModel = true
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
                    self.vm.modelType = .Users
                    self.vm.showModel = true
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                }))
            .sheet(isPresented: $vm.showModel, content: {
                
                switch vm.modelType {
                case .Users :
                    UsersView(chatRoomId: $vm.chatRoomId, membserIds: $vm.memberIds, pushNav : $vm.pushNav)
                case .Edit :
                    UserEditView()

                }
            })
            .alert(isPresented: $vm.showAlert, content: { () -> Alert in
                
                switch vm.alertType {
                
                case .logOut:
                    return Alert(title: Text("LogOut"), message: Text("ログアウトしますか？"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("ログアウト"), action: {
                        
                        FBAuth.logOut { (result) in
                            
                            switch result {
                            
                            case .success(_):
                               
                                self.userInfo.isUserAuthenTicated = .signedOut
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }))
                case .errorMessage:
                    return Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
                }
                
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
                
                guard !didAppear else {return}
                vm.fetchRecents(userId: uid)
                self.didAppear = true
                
            }
        }
        
        
        
        
    }
}

struct RecentCell : View {
    
    var recent : Recent
   
    var body: some View {
        
        VStack {
            HStack(spacing : 12) {
                
                if recent.withUserAvatar == "" {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 60, height: 60)
                } else {
                    Image(uiImage: downloadImageFromData(picturedata: recent.withUserAvatar)!)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(recent.withUserName)
                    Text(recent.lastMessage)
                        .font(.caption)
                }
                
                Spacer(minLength: 0)
                
                VStack {
                    Text(timeElapsed(date: dateFormatter().date(from: recent.date)!))
                    Spacer()
                }
                
                
            }
            
            Divider()
            
        }
        .foregroundColor(.black)
        .padding(.top, 20)
        .background(Color.white)
        
        

    }
}
