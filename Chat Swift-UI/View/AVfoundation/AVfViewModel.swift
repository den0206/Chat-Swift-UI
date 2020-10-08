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

class AVfViewModel : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate,ObservableObject {
    
    @Published var image : UIImage?
    @Published var showAlert = false
    @Published var alert : Alert = Alert(title: Text(""))
    
    var previewLayer : CALayer!
    
    private var _takePhoto : Bool = false
    private let captureSession = AVCaptureSession()
    private var capturepDevice : AVCaptureDevice!
    
    
    override init() {
        super.init()
        prepareCamera()
        beginSession()
    }
    
    func takePhoto() {
        _takePhoto = true
    }
    
    /// init
    private func prepareCamera() {
        captureSession.sessionPreset = .photo
        
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        } else {
//            self.errorMessage = "カメラの動作する端末が必要です"
            self.alert = Alert(title: Text("カメラの動作する端末が必要です"), message: nil, dismissButton: .default(Text("OK")))
            self.showAlert = true
            return
        }
    }
    
    private func beginSession()  {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        
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
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
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
}
