//
//  AVVIew.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/08.
//

import SwiftUI

struct AVView: View {
    
    @ObservedObject private var vm = AVfViewModel()
    
    var body: some View {
        VStack {
            /// no photo
            if vm.image == nil {
                Spacer()
                ZStack(alignment: .bottom) {
                    /// Z1
                    CAlayerView(caLayer: vm.previewLayer)
                    
                    /// Z2
                    Button(action: {
                        self.vm.takePhoto()
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    .padding(.bottom,50)
                }
                .onAppear {
                    self.vm.startSession()
                }
                .onDisappear{
                    self.vm.endSession()
                }
                Spacer()
            } else {
                /// exist photo
                ZStack(alignment: .topLeading) {
                    /// Z1
                    VStack {
                        Spacer()
                        
                        Image(uiImage: vm.image!)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                        
                        Spacer()
                    }
                    /// Z2
                    Button(action: { self.vm.image = nil}) {
                        Image(systemName: "xmark.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.gray)
                    }
                    .frame(width: 80, height: 80, alignment: .center)
                }
            }
        }
        .alert(isPresented: $vm.showAlert, content: {
            vm.alert
        })
    }
}


struct CAlayerView : UIViewControllerRepresentable {
    
    var caLayer : CALayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CAlayerView>) -> UIViewController {
        
        let vc = UIViewController()
        vc.view.layer.addSublayer(caLayer)
        caLayer.frame = vc.view.layer.frame
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CAlayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
    }
}
