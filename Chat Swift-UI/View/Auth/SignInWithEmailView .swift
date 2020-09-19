//
//  SignInWithEmailView .swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import SwiftUI

struct SignInWithEmailView: View {
 
    @EnvironmentObject var userInfo : UserInfo
    @State private var user : UserViewModel = UserViewModel()
    @Binding var showSheet : Bool
    @Binding var action : LoginView.Action
    
    var body: some View {
        
      
        VStack {

            Group {
                TextField("Email Addres", text: $user.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("paasword", text: $user.password)
            }
            .frame(width : 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())


            HStack {
                Spacer()
                Button(action: {
                    self.action = .resetPassword
                    self.showSheet = true
                }) {

                    Text("Reset Passowrd")
                        .foregroundColor(.black)
                }
            }.padding(.bottom)
            .padding(.trailing,10)

            VStack(spacing : 10) {

                Button(action: {}) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .frame(width : 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .opacity(user.isLoginComplete ? 1 : 0.7)
                }
                .disabled(!user.isLoginComplete)

                Button(action: {
                    self.action = .signUp
                    self.showSheet = true
                    
                }) {
                    Text("SignUp")
                        .foregroundColor(.white)
                        .padding(.vertical,15)
                        .frame(width : 200)
                        .background(Color.blue)
                        .cornerRadius(8)

                }

            }

        }
        
    }
    
}

