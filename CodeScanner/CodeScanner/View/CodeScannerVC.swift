//
//  CodeScannerVC.swift
//  CodeScanner
//
//  Created by XB on 16/8/2.
//  Copyright © 2016年 XB. All rights reserved.
//

import UIKit
import AVFoundation

class CodeScannerVC: UIViewController {

    private var presenter:CodeScannerPresenter!
    private var videoLayer:AVCaptureVideoPreviewLayer!
    private var scannerLayer:CALayer!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.presenter = CodeScannerPresenter(view: self)
    }
    
    func setupView() -> Void {
        
        self.videoLayer = AVCaptureVideoPreviewLayer()
        self.videoLayer.frame = self.view.bounds
        self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(self.videoLayer)
        
        self.scannerLayer = CALayer()
        self.scannerLayer.frame = CGRect(x: 0, y: 0, width: 150, height: 150);
        self.scannerLayer.position = self.view.center
        self.scannerLayer.borderWidth = 2
        self.scannerLayer.borderColor = UIColor.redColor().CGColor
        self.videoLayer.addSublayer(self.scannerLayer)
        
        self.view.bringSubviewToFront(self.resultLabel)        
    }
    
    deinit{
        print("CodeScannerVC delloc")
    }
}

extension CodeScannerVC:CodeScannerViewProtocol{
    func setupSession(session: AVCaptureSession) {
        self.videoLayer.session = session
    }
    func showCodeScanResult(result:String){
        print(result)
        self.resultLabel.text = result
    }
    func getVideoLayer()->AVCaptureVideoPreviewLayer
    {
        return self.videoLayer
    }
    func rectOfInterest() -> CGRect{
        let rect = self.videoLayer.metadataOutputRectOfInterestForRect(self.scannerLayer.frame)
        return rect;
        
    }
    
}