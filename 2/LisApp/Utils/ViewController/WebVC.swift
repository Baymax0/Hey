//
//  WebVC.swift
//  wangfuAgent
//
//  Created by lzw on 2018/9/19.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import WebKit

class WebVC: BaseVC ,WKNavigationDelegate{

    var urlString :String? = nil{
        didSet{
            if urlString != nil{
                let newStr = urlString!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                if let url = URL(string: newStr!){
                    webView.load(URLRequest(url: url))
                }
            }
        }
    }
    
    var htmlContent:String?

    var webView:WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:64, width:KScreenWidth, height:KScreenHeight-64))
        web.backgroundColor = KBGGray
        return web
    }()

    var progressView:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x:0, y:0, width:KScreenWidth, height:2))
        progress.progressTintColor = KGreen
        progress.trackTintColor = KBGGray
        progress.alpha = 1
        return progress
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController == nil{
            let naviView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 64))
            let lab = UILabel(frame: CGRect(x: 0, y: 20, width: KScreenWidth, height: 44))
            lab.text = self.title
            lab.textAlignment = .center
            lab.font = UIFont.boldSystemFont(ofSize: 16)
            naviView.addSubview(lab)

            naviView.backgroundColor = .white

            webView.mj_y = 64
            progressView.mj_y = 64

            self.view.addSubview(naviView)
        }
        
        self.addSlideBack(self.view)
        
        if self.htmlContent != nil{
            self.webView.loadHTMLString(self.htmlContent!, baseURL: nil)
        }

        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(webView)

        progressView.setProgress(0.05, animated:true)
        self.view.addSubview(progressView)
    }

    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let str = navigationResponse.response.url?.absoluteString{
            print("跳转：" + str)
        }
        decisionHandler(.allow)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 加载进度
        if keyPath == "estimatedProgress" {
            let newprogress = (change?[.newKey] as? NSNumber)!.floatValue
            let oldprogress = (change?[.oldKey] as? NSNumber)?.floatValue ?? 0.0
            //不要让进度条倒着走...有时候goback会出现这种情况
            if newprogress < oldprogress { return }

            if newprogress == 1 {
                progressView.setProgress(1, animated:true)
                UIView.animate(withDuration: 0.4, animations: {
                    self.progressView.alpha = 0
                }) { (_) in
                    self.progressView.setProgress(0, animated:false)
                }
            }

            else {
                self.progressView.alpha = 1
                let progress = 0.05 + 0.95 * newprogress
                progressView.setProgress(progress, animated:true)
            }
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath:"estimatedProgress")
        webView.navigationDelegate = nil
    }
}
