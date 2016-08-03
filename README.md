
[原文: http://www.devzhang.cn/2016/08/03/条码扫描/](http://www.devzhang.cn/2016/08/03/%E6%9D%A1%E7%A0%81%E6%89%AB%E6%8F%8F/)

与人脸检测类似,修改AVCaptureMetadataOutput的metadataObjectTypes为条码类型时,AVFoundation就能实现条码扫描功能了.

另外,代码中尝试使用了面向协议的MVP模式.代码链接:[CodeScanner](https://github.com/changjianfeishui/CodeScanner)


# 代码清单

由于代码与之前相似,这里仅列出部分代码.

## 设置支持的条码类型

    self.medaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeUPCECode]

## 设置扫描范围

在CodeScannerModel中有下面一个属性:

    var interestRect:CGRect!{
        didSet{
            self.medaDataOutput.rectOfInterest = interestRect
        }
    }
该属性通过设置medaDataOutput的rectOfInterest属性来表明感兴趣的扫描范围,即只扫描屏幕上该范围内的条码,超出范围外的则不进行扫描.

需要注意的是, rectOfInterest是基于设备坐标的,所以我们需要将屏幕上扫描框的frame转换到设备坐标系,幸运的是,AVCaptureVideoPreviewLayer提供了转换方法:

    let rect = self.videoLayer.metadataOutputRectOfInterestForRect(self.scannerLayer.frame)
    
但是,这个转换只有在AVCaptureSession初始化完成后调用才会正确返回设备坐标系. 