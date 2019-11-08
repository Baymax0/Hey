//
//  BMIndicatorView.swift
//  BaseUtilsDemo
//
//  Created by yimi on 2019/8/9.
//  Copyright © 2019 yimi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BMIndicatorView: UIView {
    
    var myMaskView:UIView!
    
    var activityIndicatorView:NVActivityIndicatorView!
    var activityIndicatorLab:UILabel!
    
    var contentBG:UIView!
    
    var contentImgView:UIImageView!
    var contentLab:UILabel!
    var noDataImageName:String?
    
    var requestImageName:String!
    var requestBtn:UIButton!
    
    var color:UIColor?{
        didSet{ activityIndicatorView.color = color!
            activityIndicatorLab.textColor = color!}
    }
    
    class func showInView(_ view:UIView,frame:CGRect) -> BMIndicatorView {
        let v = BMIndicatorView(frame: frame)
        v.initUI()
        v.alpha = 0;
        view.addSubview(v)
        return v
    }
    
    
    func initUI() {
        
        myMaskView = UIView(frame: self.bounds)
        myMaskView.isHidden = true
        self.addSubview(myMaskView)
        
        var w = CGFloat(35)
        var rect = CGRect(x: (self.w-w)/2, y: (self.h-w)/2, width: w, height: w)
        activityIndicatorView = NVActivityIndicatorView(frame: rect,
                                                        type: NVActivityIndicatorType.ballBeat)
        activityIndicatorView!.color = .KTextLightGray
        self.addSubview(activityIndicatorView!)
        
        w = CGFloat(70)
        rect = CGRect(x: (self.w-w)/2, y: (self.h+w)/2+4, width: w, height: 20)
        activityIndicatorLab = UILabel(frame: rect)
        activityIndicatorLab.text = "加载中.."
        activityIndicatorLab.textAlignment = .center
        activityIndicatorLab.font = UIFont.systemFont(ofSize: 15)
        activityIndicatorLab.textColor = .KTextLightGray
        activityIndicatorLab.isHidden = YES
        self.addSubview(activityIndicatorLab)
        
        
        w = CGFloat(160)
        let h = CGFloat(200)
        self.contentBG = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        self.contentBG.center = self.center
        //        self.contentBG.backgroundColor = .gray
        self.addSubview(self.contentBG)
        
        let imgH = CGFloat(150)
        self.contentImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: w, height: imgH))
        self.contentImgView.contentMode = .bottom
        self.contentBG.addSubview(self.contentImgView)
        
        requestBtn = UIButton(type: .system)
        requestBtn.frame = CGRect(x: 0, y: imgH+10, width: 85, height: 34)
        requestBtn.x = (self.contentBG.w - requestBtn.w)/2
        requestBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        requestBtn.setTitle("点击刷新", for: .normal)
        requestBtn.setTitleColor(.KTextLightGray, for: .normal)
        requestBtn.layer.cornerRadius = 10
        requestBtn.layer.borderWidth = 1
        requestBtn.layer.masksToBounds = true
        requestBtn.layer.borderColor = UIColor.KTextLightGray.cgColor
        self.contentBG.addSubview(requestBtn)
        
        self.contentLab = UILabel()
        self.contentLab.frame = CGRect(x: 0, y: imgH+10, width: w, height: 48)
        self.contentLab.text = "暂无数据\n"
        self.contentLab.numberOfLines = 0
        self.contentLab.textAlignment = .center
        self.contentLab.font = UIFont.systemFont(ofSize: 16)
        self.contentLab.textColor = .KTextLightGray
        self.contentBG.addSubview(self.contentLab)
        
        
        requestImageName = "wuwangluo"
        self.activityIndicatorView.alpha = 1;
        self.activityIndicatorLab.alpha = 0
        self.contentBG.alpha = 0
        self.requestBtn.alpha = 0
        self.contentLab.alpha = 0
        self.contentImgView.alpha = 0;
    }
    
    // 可以在初始化的时候链式调用
    @discardableResult
    func setBackgroundColor(_ color:UIColor = #colorLiteral(red: 0.9612547589, green: 0.9591583015, blue: 0.8952967111, alpha: 1)) -> BMIndicatorView{
        self.myMaskView.isHidden = false;
        self.myMaskView.backgroundColor = color
        return self;
    }
    
    /// 显示等待
    func showWait(){
        self.alpha = 1;
        
        self.activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.15, animations: {
            self.activityIndicatorView.alpha = 1;
            self.activityIndicatorLab.alpha = 1
            self.contentImgView.alpha = 0;
            self.contentBG.alpha = 0
            self.requestBtn.alpha = 0
            self.contentLab.alpha = 0
        }) { (_) in
        }
    }
    
    /// 显示无数据
    func showNoData(){
        self.alpha = 1;
        
        var imageAlpha:CGFloat = 0
        if noDataImageName != nil{
            self.contentImgView?.image = UIImage(named: self.noDataImageName!)
            contentLab.y = self.contentImgView.maxY + 10
            imageAlpha = 1;
        }else{
            imageAlpha = 0;
            contentLab.y = self.contentBG.h / 2 - contentLab.h/2
        }
        
        self.activityIndicatorView.stopAnimating()
        
        UIView.animate(withDuration: 0.15, animations: {
            self.contentImgView.alpha = imageAlpha;
            self.activityIndicatorView.alpha = 0;
            self.activityIndicatorLab.alpha = 0
            self.contentBG.alpha = 1
            self.requestBtn.alpha = 0
            self.contentLab.alpha = 1
        }) { (_) in
        }
    }
    
    /// 显示从新请求
    func showRequest(){
        self.alpha = 1;
        var imageAlpha:CGFloat = 0
        if requestImageName != nil  && self.h > 240{
            self.contentImgView?.image = UIImage(named: self.requestImageName!)
            imageAlpha = 1;
            requestBtn.y = self.contentImgView.maxY + 10
        }else{
            imageAlpha = 0;
            requestBtn.y = self.contentBG.h / 2 - requestBtn.h/2
        }
        
        self.activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentImgView.alpha = imageAlpha;
            self.activityIndicatorView.alpha = 0;
            self.activityIndicatorLab.alpha = 0
            self.contentBG.alpha = 1
            self.requestBtn.alpha = 1
            self.contentLab.alpha = 0
        }) { (_) in
        }
    }
    
    /// 隐藏
    func hide(){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (_) in
            self.activityIndicatorView?.stopAnimating()
            self.activityIndicatorLab?.isHidden = true
            self.contentBG!.isHidden = true
            self.removeFromSuperview()
        }
    }
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
