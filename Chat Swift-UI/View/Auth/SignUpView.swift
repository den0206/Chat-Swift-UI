//
//  SignUpView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/16.
//

import SwiftUI
import UIKit

struct SignUpView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var user : UserViewModel = UserViewModel()
    @State private var showPicker : Bool = false {
        didSet {
            print(showPicker)
        }
    }
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAllert : Bool = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                /// image
                if !user.selectedImage() {
                    Text(user.validImageText).font(.caption).foregroundColor(.red)

                }
                
                Button(action: {
                    self.showPicker = true
                }) {
                    if user.imageData.count == 0 {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)
                    } else {
                        Image(uiImage: UIImage(data: user.imageData)!)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                    }
                    
                }
                .padding(.bottom, 15)
                .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $user.imageData)
                }
                
                
                Spacer()
                
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
                            .autocapitalization(.none)
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
                        FBAuth.createUser(email: user.email, name: user.fullname, password: user.password, imagedata: user.imageData) { (result) in
                            
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

//MARK: - Image Pickert
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Data
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let data = uiImage.jpegData(compressionQuality: 0.2)
                
                let dataToKB = Double(data!.count) / 1000.0
                print(dataToKB)
                
                if dataToKB < 1000.0 {
                    self.parent.image = data!

                } else {
                    print("Over size")
                }
                
                
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}
