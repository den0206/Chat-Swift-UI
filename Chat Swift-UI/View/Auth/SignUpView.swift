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
    
    @State private var showAllert : Bool = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Group {
                    VStack(alignment: .leading) {
                        TextField("Fullname", text: $user.fullname)
                            .autocapitalization(.none)
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
                    
                    Button(action: {
                        FBAuth.createUser(email: user.email, name: user.fullname, password: user.password) { (result) in
                            
                            switch result {
                            
                            case .success(_):
                                print("Create")
                            case .failure(let error):
                                print(error.localizedDescription)
                                errorMessage = error.localizedDescription
                                self.showAllert = true
                                return
                            }
                        }
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding(.vertical,15)
                            .frame(width: 200)
                            .background(Color.green)
                            .cornerRadius(8)
                            .opacity(user.isSignUpComplete ? 1 : 0.7)
                    }
                    .disabled(!user.isSignUpComplete)
                    .alert(isPresented: $showAllert) {
                        
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
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
