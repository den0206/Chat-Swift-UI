//
//  SignUpView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var vm : AuthViewModel
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top) , content: {
            
            
            /// Z1
            authBackground()
                .ignoresSafeArea(.all, edges: .all)
            
            /// Z2
                
                VStack {
        
                    Spacer(minLength: 30)
                    
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    
                    Spacer(minLength: 0)

                    
                    VStack(spacing : 20) {
                        CustomTextField(imageName: "person", placeholder: "Email", text: $vm.signUpEmail)
                        CustomTextField(imageName: "lock", placeholder: "Password", text: $vm.signUpPassword)
                        CustomTextField(imageName: "lock", placeholder: "Password Confirmation", text: $vm.PasswordConfirmation)
                        
                    }.padding(.top)
                    
                  

                    
                    Button(action: {
                        vm.signUp()
                    }) {
                        
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.vertical)
                            .frame(width : UIScreen.main.bounds.width - 30)
                            .background(vm.disableSignUpColor)
                            .clipShape(Capsule())
                            
                    }
                    .disabled(vm.disableSignUpButton)
                    .alert(isPresented: $vm.showAlert) {
                        
                        Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
                    
                    }
                    
                    Spacer(minLength: 0)
                }
           
            
            /// Z3
            
            Button(action: {
                vm.showSignUp = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top,12)
            
        })
        
        
        
        
    }
}
