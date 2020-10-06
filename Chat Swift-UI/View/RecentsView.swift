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

    @State private var withUserId = ""
 
    var body: some View {
        
        NavigationView {
        
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(vm.recents) { recent in
                        
                        ZStack {
                            
                            /// swipe background
                            HStack {
                                Color.green.frame(width: 90)
                                    .opacity(recent.offSet > 0 ? 1 : 0 )
                                
                                Spacer()
                                
                                Color.red.frame(width: 90)
                                    .opacity(recent.offSet < 0 ? 1 : 0 )
                            }
                            .animation(.default)
                           
                            /// swipe Buttons
                            HStack {
                                /// favorite Action
                                Button(action: {
                                   print("Favorite")
                                    
                                }) {
                                    Image(systemName: "suit.heart")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(width: 90)
                                
                                Spacer()
                                
                                
                                /// delete Action
                                Button(action: {
                                    /// can't
                                    vm.recents.removeAll { (recent1) -> Bool in
                                        if recent.id == recent1.id {return true}
                                        else {return false}
                                    }
                                    
                                    /// delete firestore
                                }) {
                                    Image(systemName: "trash.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                    
                                }
                                .frame(width: 90)
                            }
                            
                            NavigationLink(destination: MessageView( chatRoomId: $vm.chatRoomId, memberIds: $vm.memberIds, withUserAvatar: $vm.withUserAvatar, withUserLang: $vm.withUserLang, showTab: $showTab), isActive: $vm.pushNav) {
                                
                                /// BUG ! No active push nav when first Touch because exclude recents..
                                
                                RecentCell(recent: recent, withUserId: $withUserId, function: {
                                    
                                    /// profile
                                    self.vm.modelType = .Profile
                                    self.vm.showModel = true
                                    
                                })
                                .contentShape(Rectangle())
                                    .offset(x: recent.offSet)
                                    .onTapGesture {
                                        vm.withUserLang = recent.withUserLang
                                        
                                        vm.checkDownloadedLang() { (already) in
                                            
                                            if already {
                                                self.vm.chatRoomId = recent.chatRoomId
                                                self.vm.memberIds = [userInfo.user.uid, recent.withUserId]
                                                self.vm.withUserAvatar = downloadImageFromData(picturedata: recent.withUserAvatar)!
                                                self.showTab = false
                                                self.vm.pushNav = true
                                            }
                                        }
                                    
                                    
                                    }
                                    .gesture(DragGesture().onChanged({ (value) in
                                        self.vm.objectWillChange.send()
                                        vm.recents[getIndex(recentId: recent.id)].offSet = value.translation.width
                                        
                                    }).onEnded(
                                        { (value) in
                                            if value.translation.width > 80 {
                                                vm.recents[getIndex(recentId: recent.id)].offSet = 90
                                            } else  if value.translation.width < -80 {
                                                vm.recents[getIndex(recentId: recent.id)].offSet = -90
                                            } else {
                                                vm.recents[getIndex(recentId: recent.id)].offSet = 0
                                            }
                                            
                                        }))
                                   
                                    
                                    .animation(.default)
                            }
                            .buttonStyle(PlainButtonStyle())
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
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.black)
                        .font(.system(size: 22))
                }))
            .sheet(isPresented: $vm.showModel, content: {
                
                switch vm.modelType {
                case .Users :
                    UsersView(chatRoomId: $vm.chatRoomId, membserIds: $vm.memberIds, withUserLang: $vm.withUserLang, withUserImage: $vm.withUserAvatar, pushNav: $vm.pushNav)

                case .Edit :
                    UserEditView()

                case .Profile:
                    
                    UserProfileView(uid: withUserId)
                }
            })
            .alert(isPresented: $vm.showAlert, content: { () -> Alert in
                vm.alert
                
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
//        .loading(ishowing: $vm.isLoading)
       
    }
    
    //MARK: - functins
    
    func getIndex(recentId : String) -> Int {
        
        var index = 0
        
        for i in 0..<vm.recents.count {
            
            if recentId == vm.recents[i].id {
                index = i
            }
        }
        
        return index
    }
}

struct RecentCell : View {
    
    var recent : Recent
    @Binding var withUserId : String
    var function : () -> Void
    
   
   
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
                        .onTapGesture {
                            /// profile View
                            self.withUserId = recent.withUserId
                            self.function()
                        }
                        
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing : 5) {
                        Text(recent.withUserName)
                        
                        Text("(\(recent.withUserLang.title))")
                    }
                   
                    Text(recent.lastMessage)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer(minLength: 0)
                
                VStack {
                    Text(timeElapsed(date: dateFormatter().date(from: recent.date)!))
                    Spacer()
                }
                
            }
            
            Divider()
            
        }
            .padding(.all)
            .foregroundColor(.black)
            .background(Color.white)


    }
}
