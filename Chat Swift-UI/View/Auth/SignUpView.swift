//
//  SignUpView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var user : UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                Group {
                    VStack(alignment: .leading) {
                        TextField("Fullname", text: $user.fullname)
                      if !user.validNameText.isEmpty {
                        Text(user.validNameText).font(.caption).foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        TextField("Email Address", text: $user.email)
                        if !user.validEmailText.isEmpty {
                            Text(user.validEmailText).font(.caption).foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        SecureField("password", text: $user.password)
                        if !user.validPasswordText.isEmpty {
                            Text(user.validPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        SecureField("password", text: $user.confirmPassword)
                        if !user.passwordsMatch(_confirmPW: user.confirmPassword) {
                            Text(user.validConfirmPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                    
                    
                }
                .frame(width : 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack(spacing : 20) {
                    
                    Button(action: {}) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding(.vertical,15)
                            .frame(width: 200)
                            .background(Color.green)
                            .cornerRadius(8)
                            .opacity(user.isSignUpComplete ? 1 : 0.7)
                    }
                    .disabled(!user.isSignUpComplete)
                    
                    Spacer()
                }
                .padding()
                
            }
            .padding(.top)
            
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Dismiss")
            }))
            
        }
    }
}
