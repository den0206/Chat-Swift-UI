//
//  LoadingView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/29.
//

import SwiftUI
import UIKit

extension View {
    
    func loading(ishowing : Binding<Bool>) -> some View {
        
        LoadingView(isShowing: ishowing, presenting: {self})
    }
}

struct LoadingView<Presenting>: View where Presenting : View{
    
    @Binding var  isShowing : Bool
    let presenting: () -> Presenting
  
    
    var body: some View {
        
        
        ZStack(alignment: .center) {
            
            self.presenting()
                .background(Color.black.opacity(0.7).opacity(isShowing ? 1 : 0))
            
            
            ActivityIndicator(isAnimating: $isShowing, style: .large, color: .white)
                .opacity((isShowing ? 1 : 0))
            
            
            
        }
        
        
    }
}

struct ActivityIndicator: UIViewRepresentable {
   @Binding var isAnimating: Bool
   let style: UIActivityIndicatorView.Style
   let color: UIColor
   func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
       let indigatorView = UIActivityIndicatorView(style: style)
       indigatorView.color = color
       return indigatorView
   }
   func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
       isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
   }
}


