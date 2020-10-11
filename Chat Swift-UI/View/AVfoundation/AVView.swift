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
       
            ZStack(alignment: .bottom) {
                /// Z1
                if vm.previewLayer != nil  {
                    CAlayerView(caLayer: vm.previewLayer)
                        .onTapGesture {
                            self.vm.image = nil
                            self.vm.translated = nil
                        }
                        
               
                }
                
                if vm.translated != nil {
                    
                    GeometryReader { geo in
                        
                        Text(vm.translated!)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .position(x: geo.size.width / 2, y: geo.size.height / 4)
                    }
                    
                        
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
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
//                DispatchQueue.main.async {
//                    AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
//                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
//
//                    UINavigationController.attemptRotationToDeviceOrientation()
//
//
//                }

                self.vm.startSession()
            }
            .onDisappear{
                
//                DispatchQueue.main.async {
//
//                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
//
//                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//
//                    UINavigationController.attemptRotationToDeviceOrientation()
//
//                }
                self.vm.endSession()
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
