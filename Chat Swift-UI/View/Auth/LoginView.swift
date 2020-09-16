//
//  LoginView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm = AuthViewModel()
    
    var body: some View {
        
        ZStack {
            
            /// Z1
            authBackground()
                .ignoresSafeArea(.all, edges: .all)
            
            
            /// Z2
            VStack {
                Spacer(minLength: 0)
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                
                HStack(spacing : 8) {
                    Text("Busy")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight : .heavy))
                    Text("Now")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight : .heavy))
                }
                .padding(.vertical, 10)
                
                VStack(spacing : 20) {
                    
                    CustomTextField(imageName: "person", placeholder: "Email", text: $vm.loginEmail)
                    
                    CustomTextField(imageName: "person", placeholder: "Password", text: $vm.loginPassword)
                }
                
                Text("Let's Chat No Busy")
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    print("Login")
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(vm.disableLoginColor)
                        .clipShape(Capsule())
                }
                .disabled(vm.disableLoginButton)
                .alert(isPresented: $vm.showAlert) { 
                    Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing : 12) {
                    Text("Don't Have Account")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    Button(action: {
                        vm.showSignUp.toggle()
                    }) {
                        Text("Sign Up Now")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                    .sheet(isPresented: $vm.showSignUp) {
                        SignUpView(vm: vm)
                    }
                    
                }

            }
            .padding(.vertical,10)
            
        }
        
        
    }
}


struct CustomTextField : View {
    
    var imageName : String
    var placeholder : String
    
    @Binding var text : String
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            
            Image(systemName: imageName)
                .font(.system(size: 24))
                .foregroundColor(.gray)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .clipShape(Capsule())
            
            ZStack {
                switch placeholder {
                case "Password", "Password Confirmation" :
                    SecureField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                    
                default :
                    TextField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                }
                
            }
            .padding(.horizontal)
            .padding(.leading,65)
            .frame(height: 40)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
        }
        .padding()
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
