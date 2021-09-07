//
//  MyWebVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/14.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import WebKit

class MyWebVC: BaseVC, WKNavigationDelegate {

    var urlString :String? = nil
    
    var webView:WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:0, width:KScreenWidth, height:KHeightInNav))
        web.backgroundColor = .KBGGray
        return web
    }()
    
    var barItemColor:UIColor?
    
    var progressView:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x:0, y:0, width:KScreenWidth, height:2))
        progress.progressTintColor = .green
        progress.trackTintColor = .KBGGray
        progress.alpha = 1
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = false
        
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        
        if let url = URL(string: urlString ?? ""){
            webView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let str = navigationResponse.response.url?.absoluteString{
            print("跳转：" + str)
        }
        decisionHandler(.allow)
    }
    

//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        // 加载进度
//        if keyPath == "estimatedProgress" {
//            let newprogress = (change?[.newKey] as? NSNumber)!.floatValue
//            let oldprogress = (change?[.oldKey] as? NSNumber)?.floatValue ?? 0.0
//            //不要让进度条倒着走...有时候goback会出现这种情况
//            if newprogress < oldprogress { return }
//
//            if newprogress == 1 {
//                progressView.setProgress(1, animated:true)
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.progressView.alpha = 0
//                }) { (_) in
//                    self.progressView.setProgress(0, animated:false)
//                }
//            }
//
//            else {
//                self.progressView.alpha = 1
//                let progress = 0.05 + 0.95 * newprogress
//                progressView.setProgress(progress, animated:true)
//            }
//        }
//    }
    
//    deinit {
//        webView.removeObserver(self, forKeyPath:"estimatedProgress")
//        webView.navigationDelegate = nil
//    }
    
}
