//
//  CircularTabView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/20.
//

import SwiftUI

struct CircularTabView: View {
    
    @State private var index = 0
    @State private var showTab = true
    
    
    var body: some View {
        
        VStack {
            ZStack {
                switch index {
                case 0 :
                    RecentsView(showTab : $showTab)
                    
                case 2:
                    DownloadLangageView()
                    
                default:
                    Color.white
                    Text("No Index")
                }
            }
            
            if showTab {
                CircularTab(index: $index)
                    .frame(height: 70)
                    
            }
        
            
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct CircularTab : View {
    
    @Binding var index : Int
    
    var body: some View {
        
        HStack {
            
                
            tabButton(function: {index = 0}, systemImageName: "house", title: "Home", number: 0, index: index)
            
            Spacer(minLength: 15)
            
            tabButton(function: {index = 1}, systemImageName: "magnifyingglass", title: "Search", number: 1, index: index)
            
            Spacer(minLength: 15)
            
            tabButton(function: {index = 2}, imageName: "translation", title: "Langages", number: 2, index: index)
            
        }
        .padding(.top,-10)
        .padding(.horizontal,25)
        .background(Color(.systemGroupedBackground))
        .animation(.spring())
    }
}

struct tabButton : View {
    var function : ()->Void
    var systemImageName : String? = nil
    var imageName : String? = nil
    var title : String
    var number : Int
    var index : Int
    
    var picimage : Image {
        return systemImageName != nil ? Image(systemName: systemImageName!) : Image(imageName!)
    }
    var body: some View {
        VStack {
            Button(action: {self.function()}) {
                if index != number {
                    
                    if systemImageName != nil {
                        Image(systemName: systemImageName!)
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                        
                    } else {
                        Image(imageName!)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                    }
                  
                       
                } else {
                    if systemImageName != nil {
                        Image(systemName: systemImageName!)
                            .frame(width: 25, height: 23)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .offset(y : -20)
                            .padding(.bottom, 30)
                    } else {
                        Image(imageName!)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .offset(y : -20)
                            .padding(.bottom, 30)
                            
                    }
                
                       
                    
                    Text(title)
                        .foregroundColor(Color.black.opacity(0.8))
                }
                
                
            }
        }
        
    }
}



