//
//  AVfViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/10/08.
//

import UIKit
import SwiftUI
import Combine
import AVFoundation
import MLKit

func imageOrientation(
    deviceOrientation: UIDeviceOrientation,
    cameraPosition: AVCaptureDevice.Position
) -> UIImage.Orientation {
    switch deviceOrientation {
    case .portrait:
        return cameraPosition == .front ? .leftMirrored : .right
    case .landscapeLeft:
        return cameraPosition == .front ? .downMirrored : .up
    case .portraitUpsideDown:
        return cameraPosition == .front ? .rightMirrored : .left
    case .landscapeRight:
        return cameraPosition == .front ? .upMirrored : .down
    case .faceDown, .faceUp, .unknown:
        return .up
    }
}


class AVfViewModel : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate,ObservableObject {
    
    @Published var image : UIImage?
    @Published var showAlert = false
    @Published var alert : Alert = Alert(title: Text(""))
    
    private var englishJapaneseTranslator : Translator?
    @Published var translated : [String] = [String]()
    @Published var tframe : CGRect?
    
    
    var previewLayer : CALayer!
    
    private var _takePhoto : Bool = false
    private let captureSession = AVCaptureSession()
    private var capturepDevice : AVCaptureDevice!
    private let photoSetting = AVCapturePhotoSettings()
    
    
    override init() {
        super.init()
        beginSession()
    }
    
    func takePhoto() {
        _takePhoto = true
    }
    
    /// init
    
    
    private func beginSession()  {
        captureSession.sessionPreset = .high
        
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
            capturepDevice.isFocusModeSupported(.continuousAutoFocus)
            
            try! availableDevice.lockForConfiguration()
            availableDevice.focusMode = .continuousAutoFocus
            availableDevice.unlockForConfiguration()
            
        } else {
            self.alert = Alert(title: Text("カメラの動作する端末が必要です"), message: nil, dismissButton: .default(Text("OK")))
            self.showAlert = true
            return
        }
        
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.masksToBounds = true
        self.previewLayer = previewLayer
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "Chat-SwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    func startSession() {
        if captureSession.isRunning {return}
        captureSession.startRunning()
    }
    
    func endSession() {
        if !captureSession.isRunning {return}
        captureSession.stopRunning()
    }
    
    /// delegate  capture
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if _takePhoto {
            _takePhoto = false
            let visionImage = VisionImage(buffer: sampleBuffer)
            visionImage.orientation =  imageOrientation(deviceOrientation:.portrait, cameraPosition: .back)
            
            let textRecoganizer = TextRecognizer.textRecognizer()
            
            
            textRecoganizer.process(visionImage) { (result, error) in
                
                guard error == nil, let result = result else {
                    print("[ERROR]: " + error.debugDescription)
                    return
                }
                
                for block in result.blocks {
                    
                    let blockText = block.text
                    
                    if block.frame.width < 100 || block.frame.height < 100 {
                        continue
                    }
                   
                    let option = TranslatorOptions(sourceLanguage: .english, targetLanguage: .japanese)
                    self.englishJapaneseTranslator = Translator.translator(options: option)
                    
                    self.englishJapaneseTranslator?.translate(blockText, completion: { (translated, error) in
                        
                        guard error == nil, let translated = translated else {
                            print("[ERROR]: " + error.debugDescription)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.translated.append(translated)
                            print( self.translated)
                            
                        }
      
                    })
                    
                }
 
            }
        }
    }
    
    private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        
        return nil
    }
    
    
    /// translator
    
  
}
