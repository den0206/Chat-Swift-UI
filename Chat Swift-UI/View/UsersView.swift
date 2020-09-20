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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm : UsersViewModel = UsersViewModel()
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                SearchView(isSearchng: $isSearchng, searchText: $searchText)
                    .padding()
                
                Divider()
                
                List(vm.users, id : \.self) { user in
                    
                    Button(action: {print(user.uid)}) {
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
    
    var user : FBUser {
        didSet {
            print(user)
        }
    }
    
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
         
            
            VStack(alignment:.leading, spacing: 12) {
                Text(user.name)
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                
                Text(user.uid)
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

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
