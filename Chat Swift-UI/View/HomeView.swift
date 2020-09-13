//
//  HomeView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/13.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @StateObject var vm = HomeViewModel()
    @AppStorage("current_user") var user = ""
    
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach(vm.messages) { message in
                    Text(message.msg)
                }
            }
        }
        .onAppear {
            
            vm.onAppear()
        }
    }
}

class HomeViewModel : ObservableObject {
    
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
        
        firebaseReference(.Message).addSnapshotListener { (snapshot, error) in
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
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
