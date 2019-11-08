//
//  UIView+uploadImg.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/25.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let progressTag = 98362

extension UIButton{

    var isUploading:Bool{
        if let v = self.viewWithTag(progressTag){
            if v.alpha == 0{
                return false
            }else{
                return true
            }
        }
        return false
    }

    func upload(img:UIImage,showPrograss:Bool,complish:@escaping (_ btn:UIButton?,_ success:Bool,_ url:String?) -> ()){
        Network.upload(img, uploading:{[weak self]  (progress) in
            self?.setPrograss(showPrograss,progress)
        }) {[weak self] (url) in
            self?.setPrograss(showPrograss,100)
            if url != nil{
                complish(self,true,url)
            }else{
                self?.setFaild()
                complish(self,false,url)
            }
        }
    }

    func setPrograss(_ show:Bool, _ prograss:Double){
        if !show {
            return
        }
        var progressView = self.viewWithTag(progressTag);
        if progressView == nil {
            progressView = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-5, width: 15, height: 5))
            progressView!.backgroundColor = .KBlue
            progressView!.tag = progressTag
            self.addSubview(progressView!)
        }

        if prograss == 100{
            UIView.animate(withDuration: 0.15, animations: {
                progressView!.alpha = 0
            })
        }else{
            progressView!.alpha = 1
            UIView.animate(withDuration: 0.15, animations: {
                progressView!.frame.size.width = 15.0 + (self.frame.size.width - 15) * CGFloat(prograss)
            })
        }
    }

    func setFaild(){
        var progressView = self.viewWithTag(progressTag);
        if progressView == nil {
            progressView = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-5, width: 15, height: 5))
            progressView!.backgroundColor = .KRed
            progressView!.tag = progressTag
            self.addSubview(progressView!)
        }
        progressView!.backgroundColor = .KRed

        progressView!.alpha = 1
        UIView.animate(withDuration: 0.15, animations: {
            progressView!.frame.size.width = self.frame.size.width
        })
    }

    // 是否已显示加载器
    var isShowIndicator:Bool{
        if let view = self.viewWithTag(93339) as? NVActivityIndicatorView {
            return view.isAnimating
        }
        return false
    }

    // 显示等待 加载器
    func showIndicator() -> Void {
        let lab = UILabel()
        lab.text = self.titleLabel?.text
        lab.isHidden = true
        lab.tag = 93338
        self.isUserInteractionEnabled = false
        self.addSubview(lab)
        self.setTitle("", for: .normal)


        let rect = CGRect(x: (self.frame.size.width-30) / 2, y: 7, width: 30, height: 30)
        let activityIndicatorView = NVActivityIndicatorView(frame: rect,
                                                        type: NVActivityIndicatorType.circleStrokeSpin)
        activityIndicatorView.tag = 93339
        activityIndicatorView.color = .white
        activityIndicatorView.startAnimating()
        self.addSubview(activityIndicatorView)
    }

    // 显示等待 加载器
    func hideIndicator() -> Void {
        if let lab = self.viewWithTag(93338) as? UILabel{
            lab.removeFromSuperview()
            self.setTitle(lab.text, for: .normal)
        }
        if let view = self.viewWithTag(93339) as? NVActivityIndicatorView {
            view.removeFromSuperview()
            view.stopAnimating()
        }
        self.isUserInteractionEnabled = true
    }



}




