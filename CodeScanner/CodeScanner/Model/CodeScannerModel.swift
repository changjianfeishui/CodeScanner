//
//  CodeScannerModel.swift
//  CodeScanner
//
//  Created by XB on 16/8/2.
//  Copyright © 2016年 XB. All rights reserved.
//

import AVFoundation

struct ScannerResult {
    let result: String
}

typealias didDetectionCodesBlock = ([AnyObject])->Void

class CodeScannerModel:NSObject {
    var session: AVCaptureSession!
    
    
    var interestRect:CGRect!{
        didSet{
            self.medaDataOutput.rectOfInterest = interestRect
        }
    }
    
    var medaDataOutput:AVCaptureMetadataOutput!
    
    var didDetectionCodes:didDetectionCodesBlock?
    
    let videoQueue = dispatch_queue_create("codeScanner",nil)
    
    func setupSession() -> Bool {
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPreset640x480
        if !self.setupInputs() {
            return false
        }
        if !self.setupOutputs() {
            return false
        }
        return true
    }
    
    private func setupInputs() -> Bool {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let deviceInput = try? AVCaptureDeviceInput(device: device)
        if deviceInput == nil {
            return false
        }
        if self.session.canAddInput(deviceInput) {
            self.session.addInput(deviceInput)
        }else{
            return false
        }
        return true
    }
    
    private func setupOutputs() -> Bool {
        self.medaDataOutput = AVCaptureMetadataOutput()
        if self.session.canAddOutput(self.medaDataOutput) {
            self.session.addOutput(self.medaDataOutput)
        }else{
            return false
        }
        self.medaDataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        self.medaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeUPCECode]
        return true
    }
    
    func startSession() {
        if !self.session.running {
            dispatch_async(self.videoQueue, { 
                self.session.startRunning()
            })
        }
    }
    
    func stopSession() -> Void {
        if self.session.running {
            dispatch_async(self.videoQueue, { 
                self.session.stopRunning()
            })
        }
    }
    
    deinit{
        print("CodeScannerModel delloc")
    }
    
}

extension CodeScannerModel:AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        self.didDetectionCodes?(metadataObjects)
    }
}
