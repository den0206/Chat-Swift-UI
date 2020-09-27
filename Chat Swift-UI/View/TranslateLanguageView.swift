//
//  TranslateLanguageView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/27.
//

import SwiftUI
import MLKit

struct TranslateLanguageView: View {
    
    @Binding var currentUser : FBUser
    @Binding var withUserLang : TranslateLanguage
    @ObservedObject var vm : MessageViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var editing : Bool = false

    

    var body: some View {
        
        VStack( spacing : 15) {
            
            HStack{
                Spacer()
                
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                }
                .padding(10)
            }
           
            
            Spacer().frame(height : 20)
            
            Text(currentUser.lang.title)
            
            TextEditor(text: $vm.text)
                .font(.body)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                .overlay(
                    /// border
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .onChange(of: vm.text, perform: { value in
                    editing = true
                    
                    vm.translateLanguage(source: .japanese, target: .english)
                    
                })
            
            HStack(spacing : 10) {
                
                Text("Translationg...")
                    .foregroundColor(.black)
                    .opacity(editing ? 1 :0)
                
            }
            .padding(.vertical,30)
            
            
            Text(withUserLang.title)
            
            Text(vm.translated)
                .foregroundColor(.black)
                .lineLimit(nil)
                .padding(5)
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            
        }
        
        Spacer(minLength: 0)
        
        
        
    }
}


struct TranslateLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
