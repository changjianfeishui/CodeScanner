//
//  CodeScannerPresenter.swift
//  CodeScanner
//
//  Created by XB on 16/8/2.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
import AVFoundation
protocol CodeScannerViewProtocol:NSObjectProtocol {
    func setupSession(session:AVCaptureSession)
    func showCodeScanResult(result:String)
    func getVideoLayer()->AVCaptureVideoPreviewLayer
    func rectOfInterest() -> CGRect
}

class CodeScannerPresenter: NSObject {
    
    weak private var view:CodeScannerViewProtocol?
    
    private var scannerModel: CodeScannerModel!
    
    convenience init(view:CodeScannerViewProtocol){
        self.init()
        self.view = view
        self.scannerModel = CodeScannerModel()
        weak var ws = self
        self.scannerModel.didDetectionCodes = { codes in
            if codes.count > 0 {
                let videoLayer = ws!.view?.getVideoLayer()
                let meta = videoLayer?.transformedMetadataObjectForMetadataObject((codes[0] as! AVMetadataObject))
                let result = (meta as! AVMetadataMachineReadableCodeObject).stringValue
                ws!.view?.showCodeScanResult(result)
            }
        }
        if self.scannerModel.setupSession() {
            ws!.view?.setupSession(ws!.scannerModel.session)
            ws!.scannerModel.startSession()
            ws!.scannerModel.interestRect = self.view?.rectOfInterest()

        }
    }
    
    deinit{
        print("CodeScannerPresenter delloc")
    }
}
