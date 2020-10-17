//
//  MainView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/17.
//

import SwiftUI
import Firebase

//extension Identifiable where Self: Hashable {
//    typealias ID = Self
//    var id: Self { self }
//}
//

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
                        
                        NavigationLink(destination: MessageView( chatRoomId: $vm.chatRoomId, memberIds: $vm.memberIds, withUserAvatar: $vm.withUserAvatar, withUserLang: $vm.withUserLang, showTab: $showTab), isActive: $vm.pushNav) {
                            
                            /// BUG ! No active push nav when first Touch because exclude recents..
                           
                            RecentCell(recent: $vm.recents[getIndex(recent: recent)], withUserId: $withUserId, function: {
                                
                                /// profile
                                self.vm.modelType = .Profile
                                self.vm.showModel = true
                                
                            })
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
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    
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
    }
    
    //MARK: - functins
    
    func getIndex(recent : Recent) -> Int {
        return vm.recents.firstIndex { (recent1) -> Bool in
            return recent.id == recent1.id
        } ?? 0
    }
    
//    func getIndex(recentId : String) -> Int {
//
//        var index = 0
//
//        for i in 0..<vm.recents.count {
//
//            if recentId == vm.recents[i].id {
//                index = i
//            }
//        }
//
//        return index
//    }
}

struct RecentCell : View {
    
    @Binding var recent : Recent
//    var recent : Recent
    @Binding var withUserId : String
    var function : () -> Void
    
    
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(gradient: .init(colors: [Color.white, Color.red]), startPoint: .leading, endPoint: .trailing)
            
            HStack {
                Spacer()
                
                Button(action:{}) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 90)
                }
            }
            
            HStack(spacing : 12) {
                
                //                if recent.withUserAvatar == "" {
                //                    Circle()
                //                        .fill(Color.gray)
                //                        .frame(width: 60, height: 60)
                //                } else {
                //
                //                    //MARK: - Because of Memoryweak
                //
                //                    Image(uiImage: downloadImageFromData(picturedata: recent.withUserAvatar)!)
                //                        .resizable()
                //                        .frame(width: 60, height: 60)
                //                        .clipShape(Circle())
                //                        .onTapGesture {
                //                            /// profile View
                //                            self.withUserId = recent.withUserId
                //                            self.function()
                //                        }
                //
                //                }
                
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
            .padding()
            .background(Color.white)
            .contentShape(Rectangle())
            .offset(x: recent.offSet)
            .gesture(DragGesture().onChanged(onChange(value:)).onEnded(onEnd(value:)))
                        
        }
        
    }
    
    func onChange(value : DragGesture.Value) {
        if value.translation.width < 0 {
           if recent.isSwiped {
                recent.offSet = value.translation.width - 90
           } else {
            recent.offSet = value.translation.width
            print(recent.offSet)
           }
        }
    }
    
    func onEnd(value: DragGesture.Value){
           
           withAnimation(.easeOut){
               
               if value.translation.width < 0{
                   
                // Checking...
                
                if -value.translation.width > UIScreen.main.bounds.width / 2{
                    
                    recent.offSet = -1000
                    //                       deleteItem()
                    print("Delete")
                }
                else if -recent.offSet > 50{
                    // updating is Swipng...
                    recent.isSwiped = true
                    recent.offSet = -90
                }
                else{
                    recent.isSwiped = false
                    recent.offSet = 0
                }
               }
               else{
                recent.isSwiped = false
                recent.offSet = 0
               }
           }
    }
}

