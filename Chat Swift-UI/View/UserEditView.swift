//
//  UserEditView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/23.
//

import SwiftUI
import MLKit


struct UserEditView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var user : UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showPicker = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    

    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack {
                Spacer(minLength: 0)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
                
                
               
            }
            .padding()
            
            Spacer().frame(width: UIScreen.main.bounds.width, height: 30)
            
            /// image
            HStack {
                Spacer(minLength: 0)
                
                Button(action: {self.showPicker = true}) {
                    
                    if !(user.imageData.count == 0) {
                        Image(uiImage: UIImage(data: user.imageData)!)
                            .resizable()
                            .frame(width:90, height:90)
                            .clipShape(Circle())
                        
                    } else {
                        Image(uiImage: downloadImageFromData(picturedata: userInfo.user.avatarString)!)
                            .resizable()
                            .frame(width:90, height:90)
                            .clipShape(Circle())
                    }
                    
                    
                }
                .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $user.imageData, errorMessage : $errorMessage, showAlert : $showAlert)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            
            VStack {
                
                Group {
                    
                    VStack(alignment: .leading) {
                        TextField("", text: $user.fullname)
                            .onAppear {
                                self.user.fullname = userInfo.user.name
                            }
                        
                        if !user.validNameText.isEmpty {
                          Text(user.validNameText).font(.caption).foregroundColor(.red)
                          }
                        
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("", text : $user.email)
                            .onAppear {
                                self.user.email = userInfo.user.email
                            }
                        
                        if !user.validEmailText.isEmpty {
                            Text(user.validEmailText).font(.caption).foregroundColor(.red)
                        }
                    }
          
                    
                }
                .foregroundColor(.black)
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            }
            .padding()
                       
            Spacer().frame(width: UIScreen.main.bounds.width, height: 30)
            
            
            LangagePicker(selectrdLangage: $user.language)
                .padding(.top,20)
                .frame(width: UIScreen.main.bounds.width - 30)
                .onAppear {
                    self.user.language = userInfo.user.lang
                }
            
            
            Spacer().frame(width: UIScreen.main.bounds.width, height: 30)
            
            
            Button(action: {print(user)}) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,40)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .opacity(user.didChangeStatus ? 1 : 0.6)
                
            }
            .disabled(!user.didChangeStatus)
            
            Button(action: {self.showAlert = true}) {
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal,40)
                    .background(Color.red)
                    .clipShape(Capsule())
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("LogOut"), message: Text("ログアウトしますか？"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .destructive(Text("ログアウト"), action: {
                    
                    FBAuth.logOut { (result) in
                        
                        switch result {
                        
                        case .success(_):
                            self.presentationMode.wrappedValue.dismiss()
                            self.userInfo.isUserAuthenTicated = .signedOut
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }))
            }
        
            
        }
        .onAppear {
            user.currentUser = userInfo.user
        }
    }
}

