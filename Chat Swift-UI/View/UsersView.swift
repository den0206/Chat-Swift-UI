//
//  UsersView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var userInfo : UserInfo

    @State private var isSearchng = false
    @State private var searchText : String = ""
    @Binding var chatRoomId : String
    @Binding var membserIds : [String]
    @Binding var pushNav : Bool
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm : UsersViewModel = UsersViewModel()
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                SearchView(isSearchng: $isSearchng, searchText: $searchText)
                    .padding()
                
                Divider()
                
                List(vm.users, id : \.self) { user in
                    
                    Button(action: {
                        
                        self.chatRoomId = startPrivateChat(currentUser: userInfo.user, user2: user)
                        self.membserIds = [userInfo.user.uid, user.uid]
                        self.presentationMode.wrappedValue.dismiss()
                                        
                        self.pushNav = true

                    }) {
                        UserCell(user: user)
                    }
                   
                      
                }
                
                
            }
            .onAppear(perform: {
                vm.loadUser(currentUid: userInfo.user.uid)
            })
            
            .navigationBarTitle("Users", displayMode : .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                
            }))
        }
    
       
    }
}

struct UserCell : View {
    
    var user : FBUser
    
    var body: some View {
        
        HStack(spacing : 24) {
            
            if user.avatarString == "" {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 60, height: 60)
            } else {
                Image(uiImage: downloadImageFromData(picturedata: user.avatarString)!)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
         
             
            HStack {
                Text(user.name)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                
                Text("(\(user.lang.title))")
                    .font(.caption2)
            }
     
            Spacer()
            
        }
        .padding(.horizontal)
        
    }
}

struct SearchView : View {
    
    @Binding var isSearchng : Bool
    @Binding var searchText : String
    
    var body: some View {
        
        HStack {
            /// search field
            HStack {
                TextField("Search Users", text: $searchText)
                    .padding(.leading,24)
                    .onTapGesture {
                        self.isSearchng = true
                    }
            }
            .padding()
            .background(Color(.systemGray3))
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        Spacer()
                    if isSearchng {
                        Button(action: {self.searchText = ""}) {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal,32)
                .foregroundColor(.gray)
            )
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearchng {
                Button(action: {
                    isSearchng = false
                    searchText = ""
                    
                    hideKeyBord()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing,24)
                .padding(.leading,0)
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
        }
    }
}
