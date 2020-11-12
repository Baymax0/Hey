//
//  BaseVC.swift
//  wangfuAgent
//
//  Created by YiMi on 2018/7/11.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

// 页面离开的方式
enum BMVCDismissType {
    case pop    //返回上一级 页面注销
    case push   //跳转新页面
    case none   //空
}

class BaseVC: UIViewController {
    ///隐藏导航栏下面的黑线
    var hideNavBottonLine:Bool!
    /// 隐藏导航栏
    var hideNav = false
    /// 谁否可以测划返回
    var popGestureEnable = true
    /// viewwillappear 调用次数
    var appearTimes:Int = 0
    /// BaseVC.currentVC 或的当前展示的页面
    static var currentVC:String?
    /// 状态栏颜色  需要指定的  重写该属性
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return hideNav ? .lightContent : .default }
    }
    
    var autoHideKeyboard:Bool = true
    
    //页面传参回调
    var backClosure: ((Dictionary<String, Any>) -> ())?
    func setBackClosure(_ closure : @escaping (Dictionary<String, Any>) -> ()){ backClosure = closure}
    
    /// 页面离开的方式
    var dismissType:BMVCDismissType = .none

    //记录上次请求的时间戳
    var lastLoadTime:Date = Date(timeIntervalSince1970: 0)
    var reloadIntervalTime:Double = 600
    //判断距离上次请求的时间 决定是否刷新
    var needLoadWhenAppear:Bool{
        return Date().timeIntervalSince(lastLoadTime) > (reloadIntervalTime)
    }

    // 弹出框使用的 灰背景
    lazy var maskView : UIButton = {
        let mask = UIButton.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        mask.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        return mask
    }()

    var window:UIWindow! {
        return UIApplication.shared.keyWindow
    }

    // ===================  func   ===================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearTimes = appearTimes + 1
        BaseVC.currentVC = String(describing: self.classForCoder)
        navigationController?.setNavigationBarHidden(hideNav, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureEnable
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = self.autoHideKeyboard
        if let b = self.hideNavBottonLine, b == true{
            self.findHairlineImageViewUnder(sView: self.navigationController?.navigationBar)?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.dismissType == .pop{
            backClosure = nil
        }
        if let b = self.hideNavBottonLine, b == true{
            self.findHairlineImageViewUnder(sView: self.navigationController?.navigationBar)?.isHidden = false
        }
    }
    
    // 返回事件
    @objc func back() {
        if let _ = self.navigationController {
            self.pop()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    func showMaskView() -> Void {
        maskView.alpha = 0
        window.addSubview(maskView)
        UIView.animate(withDuration: 0.2) {
            self.maskView.alpha = 1
        }
    }
    @objc func hideMaskView() -> Void {
        UIView.animate(withDuration: 0.15, animations: {
            self.maskView.alpha = 0
        }) { (_) in
            self.maskView.removeFromSuperview()
        }
    }

    func addTapCloseKeyBoard(_ view:UIView) {
        let tag = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tag)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    /// 忽略自适应内边距
    func ignoreAutoAdjustScrollViewInsets(_ sc:UIScrollView?) {
        if #available(iOS 11.0, *) {
            sc?.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO
        }
    }
    
    func findHairlineImageViewUnder(sView: UIView?) -> UIImageView?{
        if sView == nil{
            return nil
        }
        if sView! is UIImageView && sView!.bounds.height <= 1 {
            return sView as? UIImageView
        }
        for sview in sView!.subviews {
            let imgs = self.findHairlineImageViewUnder(sView: sview)
            if imgs != nil && imgs!.bounds.height <= 1 {
                return imgs
            }
        }
        return nil
    }
}



extension BaseVC {
    
    class func fromStoryboard(_ identify: String? = nil) -> BaseVC {
        let id = identify ?? String(describing: type(of:self.init()))
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id) as! BaseVC
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func pushViewController(_ vc:UIViewController, _ animation:Bool = true) {
        if let n = self.navigationController{
            n.pushViewController(vc, animated: animation)
            self.dismissType = .push
        }
    }
    
    func pop(_ animation:Bool = true) -> Void{
        if let n = self.navigationController{
            n.popViewController(animated: animation)
            self.dismissType = .pop
        }
    }
    
    /// -1 = 前一个，
    func pop(index:Int) -> Void{
        if let arr = self.navigationController?.children {
            let newIndex = arr.count - 1 + index
            let vc = arr[newIndex]
            self.navigationController?.popToViewController(vc, animated: YES)
            self.dismissType = .pop
        }
    }
}


extension UIViewController {
    func barItem(_ target:(Any), title:String, imgName:String?, action:Selector , color:UIColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)) -> UIBarButtonItem {
        let btn = self.barBtn(target, title: title, imgName: imgName, action: action, color: color)
        let item = UIBarButtonItem(customView: btn)
        return item
    }
    
    func barBtn(_ target:(Any), title:String, imgName:String?, action:Selector , color:UIColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.tintColor = color
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        var margin = 10
        if #available(iOS 10.0, *) {
            margin = 2
        }
        var w = 18 * title.count + margin
        w = w > 30 ? w : 30
        
        btn.frame = CGRect(x: 0, y: 0, width: w, height: 44)
        if imgName != nil {
            let img = UIImage(named:imgName!)?.withRenderingMode(.alwaysTemplate)
            btn.setImage(img, for: .normal)
        }
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(color, for: .normal)
        return btn
    }
}

