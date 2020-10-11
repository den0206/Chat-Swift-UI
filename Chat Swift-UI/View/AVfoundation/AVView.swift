//
//  AVVIew.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/08.
//

import SwiftUI

struct AVView: View {
    
    @ObservedObject private var vm = AVfViewModel()
    @State private var  baseZoomFactor : CGFloat = 1.0

   
    var body: some View {
       
            ZStack(alignment: .bottom) {
                /// Z1
                if vm.previewLayer != nil  {
                    CAlayerView(caLayer: vm.previewLayer)
                        .scaleEffect(baseZoomFactor)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    self.baseZoomFactor = value
                                }
                        )
                       
                    
                    
                }
                
                if !vm.translated.isEmpty {
                    GeometryReader { geo in
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            Spacer().frame(width: geo.size.width, height: geo.size.height / 2)
                            
                            VStack(spacing : 3) {
                                ForEach(vm.translated, id : \.self) { translate in
                                    
                                    Text(translate)
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                    
                                    
                                }
                            }
                            
                            
                        }
                        .onTapGesture {
                            self.vm.translated = [String]()
                        }
                        
                    }
     
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    /// Z2
                    Button(action: {
                        self.vm.translated = [String]()
                        self.vm.takePhoto()
                    }) {
                        Text("Scan")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
//                        Image(systemName: "camera.circle.fill")
//                            .renderingMode(.original)
//                            .resizable()
//                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    .padding()
                    
                }
             
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
