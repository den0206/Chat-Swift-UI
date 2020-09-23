//
//  HomeView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import SwiftUI
import Firebase

struct exHomeView: View {
    
    @StateObject var vm = HomeViewModel()
    @AppStorage("current_user") var user = ""
    @State private var  scrolled = false
    
    var body: some View {
        
        VStack(spacing : 0) {
            
            /// navbar
            
            HStack {
                Text("Chat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color(.green))
            
            
            
            ScrollViewReader { reader in
                
                ScrollView {
                    
                    VStack(spacing : 15) {
                        ForEach(vm.messages) { message in
                            exChatCell(message: message)
                                .onAppear {
                                    /// scroll Bottom when FirstLoad
                                    
                                    
                                    if message.id == self.vm.messages.last!.id && !scrolled {
                                        reader.scrollTo(vm.messages.last!.id, anchor : .bottom)
                                        
                                        scrolled = true

                                    }
                                }
                        }
                        .onChange(of: vm.messages) { (value) in
                            /// scroll to bottom get New Chat
                            reader.scrollTo(vm.messages.last!.id, anchor : .bottom)
                        }
                    }
                    .padding(.vertical)
                    
                    
                    
                }
            }
            
            /// Text Field
            
            HStack(spacing : 15) {
                
                TextField("Enter Message", text: $vm.text)
                    .padding(.horizontal)
                    .frame( height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if vm.text != "" {
                    Button(action: {vm.sendMessage()}) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.bottom, 5)
            
            
            
        }
        .onAppear {
            
            vm.onAppear()
        }
        .animation(.default)
        .ignoresSafeArea(.all, edges: .top)
    }
}

class HomeViewModel : ObservableObject {
    
    @Published var text = ""
    @Published var messages = [Message]()
    @AppStorage("current_user") var user = ""
    
    init() {
        fetchAllMessages()
    }
    
    func onAppear() {
        if user == "" {
            UIApplication.shared.windows.first?.rootViewController?.present(showAlertView(), animated: true, completion: nil)
        }
    }
    
    func showAlertView() -> UIAlertController {
        
        let alert = UIAlertController(title: "Join Chat", message: "Nick Name", preferredStyle: .alert)
        
        alert.addTextField { (txt) in
            txt.placeholder = "Nick Name"
        }
        
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            let user = alert.textFields?[0].text ?? ""
            
            guard user != "" else {
                /// REPresent
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                return}
            
            self.user = user
            
        }
        
        alert.addAction(submit)
        
        return alert
    }
    
    func fetchAllMessages() {
        
        firebaseReference(.Message).order(by: "timeStamp", descending: false).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                
                snapshot.documentChanges.forEach { (doc) in
                    
                    switch doc.type {
                    
                    case .added:
                        let messgae = try! doc.document.data(as: Message.self)
                        
                        DispatchQueue.main.async {
                            self.messages.append(messgae!)
                        }
                    default :
                        return
                    }
                }
                
            } else {
                print("Empty")
            }
        }
    }
    
    func sendMessage() {
        
        let msg = Message(userId: user, msg: text, timeStamp: Date())
        
        let _ = try! firebaseReference(.Message).addDocument(from: msg) { (error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.text = ""
        }
    }
        
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
