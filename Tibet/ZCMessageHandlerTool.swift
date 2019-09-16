//
//  ZCMessageHandlerTool.swift
//  Tibet
//
//  Created by zchao on 2019/9/16.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import UIKit
import WebKit

class ZCMessageHandlerTool: NSObject {

    /// 保存截屏到系统相册
    class func saveScreenshotToLibrary(_ webView: WKWebView) {
        let screenshot = UIImage.screenshot() ?? UIImage()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(image(_:didFinishSavingWith:contextInfo:)), nil)
    }
    
    /// 保存网络图片
    class func saveWebImageTpLibrary(_ webView: WKWebView, imageUrl url: URL) {
        
    }
    
    
    /// 保存图片的结果回调
    @objc class func image(_ image: UIImage, didFinishSavingWith error: Error?, contextInfo info: Any) {
        
        if let err = error { //failed
            MBProgressHUD.showBottomText(err.localizedDescription)
        }else { // success
            MBProgressHUD.showBottomText("保存成功")
        }
    }
    
    
    
}



extension UIImage {
    
    static func screenshot() -> UIImage? {
        
        var imageSize = CGSize.zero
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            imageSize = UIScreen.main.bounds.size
        }else {
            imageSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        for window in UIApplication.shared.windows {
            context?.saveGState()
            context?.translateBy(x: window.center.x, y: window.center.y)
            context?.concatenate(window.transform)
            context?.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            
            switch orientation {
            case UIInterfaceOrientation.landscapeLeft:
                context?.rotate(by: .pi/2)
                context?.translateBy(x: 0, y: -imageSize.width)
            case UIInterfaceOrientation.landscapeRight:
                context?.rotate(by: -.pi/2)
                context?.translateBy(x: -imageSize.height, y: 0)
            case UIInterfaceOrientation.portraitUpsideDown:
                context?.rotate(by: .pi)
                context?.translateBy(x: -imageSize.width, y: -imageSize.height)
            default:
                break
            }
            
            if window.responds(to: #selector(window.drawHierarchy(in:afterScreenUpdates:))) {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }else {
                window.layer.render(in: context!)
            }
            context?.restoreGState()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
}
