//
//  OneDetailVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/16.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import WebKit

class OneDetailVC: BaseVC, WKNavigationDelegate{
    
    var model:One_Today_Content_Model!
    
    var contentModel:One_Html_Model?
    
    var web:WKWebView = {
        let web = WKWebView( frame: CGRect(x:0, y:0, width:KScreenWidth, height:KHeightInNav))
        web.backgroundColor = .KBGGray
        return web
    }()
    
    var indicatorView :BMIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.model.categoryName
        web.navigationDelegate = self
        web.alpha = 0
        self.view.addSubview(web)
        
        indicatorView = BMIndicatorView.showInView(view, frame: web.frame)
        indicatorView.showWait()
        indicatorView.requestImageName = "nonetwork"
        indicatorView.requestBtn.addTarget(self, action: #selector(requestContent), for: .touchUpOutside)
        
        self.requestContent()
        
    }
    
    @objc func requestContent() {
        contentModel = RealmManager.ONE.getDetailHtml(self.model.category, self.model.item_id)
        if contentModel?.html_content != nil{
            self.loadHtml()
            return
        }
        network.oneApp_Content_Detail(key: contentModel!.primaryKey).request { (resp) in
            if resp?.data != nil{
                self.contentModel = resp?.data
                RealmManager.ONE.save(self.contentModel)
                self.loadHtml()
            }else{
                self.indicatorView.showRequest()
            }
        }
    }
    
    func loadHtml() {
        var html:String! = self.contentModel!.html_content
        html = html.replacingOccurrences(of: "\n", with: "")
        
        html = html.hideDicWithClass("one-author-follow")
        html = html.hideDicWithClass("one-relates-box")
        html = html.hideDicWithClass("one-comments-box")
        web.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.hide()
        web.showWithAnimation(0.4)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicatorView.showRequest()
    }

}


fileprivate extension String{
    func hideDicWithClass(_ className:String) -> String {
        let occuStr = "class=\"\(className)\""
        return self.replacingOccurrences(of: occuStr, with: "style=\"display: none;\"")
    }
}
