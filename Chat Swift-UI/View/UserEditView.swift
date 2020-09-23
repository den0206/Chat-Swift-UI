//
//  UserEditView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/23.
//

import SwiftUI


struct UserEditView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false


    var body: some View {
        
        VStack {
            
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
                
                Button(action: {print("present ip")}) {
              
                        Image(uiImage: downloadImageFromData(picturedata: userInfo.user.avatarString)!)
                            .resizable()
                            .frame(width:150, height:150)
                            .clipShape(Circle())
                 
                }
                
                Spacer(minLength: 0)
            }
            
            /// text fields
           
            Spacer().frame(width: UIScreen.main.bounds.width, height: 30)
            
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
            
            Spacer(minLength: 0)
        }
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditView()
    }
}
