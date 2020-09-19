//
//  ForgotPasswordView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var  user : UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                TextField("Your Email", text : $user.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                Button(action: {}) {
                    Text("Rest Password")
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .frame(width : 200)
                        .background(Color.red)
                        .cornerRadius(8)
                        .opacity(user.isEmailValid(_email: user.email) ? 1 : 0.7)
                }
                .disabled(!user.isEmailValid(_email: user.email))
                Spacer()
            }
            .padding(.top)
            .frame(width : 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Dismiss")
            }))
        }
    }
}

