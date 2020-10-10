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
               
                ZStack(alignment: .bottom) {
                    /// Z1
                    if vm.previewLayer != nil  {
                        CAlayerView(caLayer: vm.previewLayer)

                    }
                    
                    Spacer()
                    /// Z2
                    Button(action: {
                        self.vm.takePhoto()
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    .padding(.bottom,30)
                }
                .onAppear {
                    self.vm.startSession()
                }
                .onDisappear{
                    self.vm.endSession()
                }
            } else {
                /// exist photo
                ZStack(alignment: .topLeading) {
                    /// Z1
                    VStack {
                        
                        Spacer()
                        
                        if vm.translated != nil {
                            Image(uiImage: vm.image!)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    
                                    Rectangle()
                                        .fill(Color.green)
                                        .position(<#T##position: CGPoint##CGPoint#>)
                                    
//                                        Text(vm.translated!)
//                                            .foregroundColor(.white)
//                                            .background(Color.green)
//                                            .position(x: vm.tframe!.minX, y: vm.tframe!.maxY)
                               
                                )
                            
                        } else {
                            Image(uiImage: vm.image!)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                              
                        }
                    
                        Spacer()
                    }
                    
                    
                    
                    /// Z2
                    Button(action: {
                        self.vm.image = nil
                        self.vm.translated = nil
                    }) {
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
