//
//  WkwebViewController.swift
//  Tibet
//
//  Created by zchao on 2019/7/17.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

class WkwebViewController: UIViewController {

    var keyBoardPoint = CGPoint.zero    ///键盘弹起是webView的偏移量
    
    
    lazy var webView: WKWebView = {
        /*
         禁止长按(超链接、图片、文本...)弹出效果
         document.documentElement.style.webkitTouchCallout='none';
         去除长按后出现的文本选取框
         document.documentElement.style.webkitUserSelect='none'; */
        let jsString = "document.documentElement.style.webkitTouchCallout='none';document.documentElement.style.webkitUserSelect='none';"
        let userScript = WKUserScript(source: jsString, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        config.userContentController.addUserScript(userScript)
        
        // 插入JS函数，以此传值给web
        let data = try? JSONSerialization.data(withJSONObject: ["statusHeight":StatusBarHeight,"indicatorHomeHeight":IndicatorHomeHeight], options: [])
        let layoutInfo = "window.iOSInfo = " + String(data: data!, encoding: String.Encoding.utf8)!
        let layoutScript = WKUserScript(source: layoutInfo, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        config.userContentController.addUserScript(layoutScript)
        config.userContentController.add(self, name: "saveScreenshotToLibrary")
        config.userContentController.add(self, name: "saveWebImageToLibrary")
        
        
        let web = WKWebView.init(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-CGFloat(IndicatorHomeHeight)), configuration: config)
        web.navigationDelegate = self
        web.uiDelegate = self
        web.allowsBackForwardNavigationGestures = true
        web.allowsLinkPreview = false
        web.scrollView.bounces = false
        web.scrollView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            web.scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.webView)
        
        let mRequest = URLRequest(url: URL(string: WebBaseUrl)!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
        self.webView.load(mRequest)
        
        Alamofire.request(updateVersion, method: .post, parameters: ["appname":AppName,"type":"2","version":AppVersion], encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"]).responseJSON { (response) in

            print("value:\(String(describing: response.result.value))==\(AppName)==\(AppVersion)")

            guard response.result.isSuccess else {
                print("response Error!!")
                return
            }

            if let json = response.result.value {
                let data = JSON(json)["data"]
                ZCUpdateAlert.showUpdateAlert(withModel: UpdateVersionModel.init(jsonData: JSON(data)))
            }
        }
        
        
        if #available(iOS 12.0, *) {/// 修复当 contentInsetAdjustmentBehavior = .never 时页面顶上之后不恢复
            NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)) , name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    @objc func keyboardWillShow(_ notif: Notification) {
        keyBoardPoint = self.webView.scrollView.contentOffset
    }
    
    @objc func keyboardWillHide(_ notif: Notification) {
        self.webView.scrollView.setContentOffset(keyBoardPoint, animated: true)
    }

    deinit {
        if #available(iOS 12.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}


extension WkwebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let scheme = url?.scheme
        
        if scheme != nil && scheme == "tel" {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
}


extension WkwebViewController : WKUIDelegate,WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name, message.body)
        switch message.name {
        case "saveScreenshotToLibrary":
            ZCMessageHandlerTool.saveScreenshotToLibrary(self.webView)
        case "saveWebImageToLibrary":
            if let body = message.body as? String {
                ZCMessageHandlerTool.saveWebImageTpLibrary(self.webView, imageUrl: URL(string: body))
            }
        default:
            break
        }
        
    }
    
    
}

