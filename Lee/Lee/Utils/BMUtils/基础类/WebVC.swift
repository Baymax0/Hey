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

    var urlString :String? = nil
    
    var htmlContent:String? = nil
    
    var barItemColor:UIColor?

    var webView:WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:0, width:KScreenWidth, height:KHeightInNav))
        web.backgroundColor = .KBGGray
        return web
    }()

    var progressView:UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x:0, y:0, width:KScreenWidth, height:2))
        progress.progressTintColor = .KBlue
        progress.trackTintColor = .KBGGray
        progress.alpha = 1
        return progress
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = false;
        
        self.view.addSubview(webView)
        
        self.initUI()
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if urlString != nil{
            let newStr = urlString!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if let url = URL(string: newStr!){
                webView.load(URLRequest(url: url))
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.htmlContent != nil{
            self.webView.loadHTMLString(self.htmlContent!, baseURL: nil)
        }else{
            let newStr = urlString!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if let url = URL(string: newStr!){
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    func initUI() {
        let naviView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
        naviView.backgroundColor = .white
        
        if self.navigationController == nil{
            let naviView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
            let lab = UILabel(frame: CGRect(x: 0, y: KNaviBarH-44, width: KScreenWidth, height: 44))
            lab.text = self.title
            lab.textAlignment = .center
            lab.font = UIFont.boldSystemFont(ofSize: 16)
            naviView.addSubview(lab)
            
            let back = UIButton(frame: CGRect(x: 10, y: KNaviBarH-44, width: 50, height: 44))
            back.setImage(UIImage(named: "BMback_Icon"), for: .normal)
            back.tag = 0
            back.addTarget(self, action: #selector(WebVC.back), for: .touchUpInside)
            
            naviView.addSubview(back)
            naviView.backgroundColor = .white
            
            webView.y = KNaviBarH
            progressView.y = KNaviBarH
            
            self.view.addSubview(naviView)
        }
        
        progressView.setProgress(0.05, animated:true)
        self.view.addSubview(progressView)
    }

    @objc func myBack(_ btn:UIButton){
        if btn.tag == 0{
            super.back()
        }else{
            let count = webView.backForwardList.backList.count
            print(count)
            if count >= 1{
                webView.goBack()
            }else{
                super.back()
            }
        }
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
