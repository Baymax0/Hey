//
//  BaseVC.swift
//  wangfuAgent
//
//  Created by YiMi on 2018/7/11.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView
import IQKeyboardManagerSwift

// 页面离开的方式
enum BMVCDismissType {
    case pop    //返回上一级 页面注销
    case push   //跳转新页面
    case none   //空
}

class BaseVC: UIViewController {

    /// 隐藏导航栏
    var hideNav = false
    /// 谁否可以测划返回
    var popGestureEnable = true
    /// viewwillappear 调用次数
    var appearTimes:Int = 0
    /// BaseVC.currentVC 或的当前展示的页面
    static var currentVC:String?
    /// 状态栏颜色  需要指定的  从写该属性
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return hideNav ? .lightContent : .darkContent }
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
    var bottomPopView:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: KScreenHeight-10, width: KScreenWidth, height: 1))
        return v
    }()

    // 弹出框使用的 灰背景
    lazy var maskView : UIButton = {
        let mask = UIButton.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        mask.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        mask.tap.addTouchUpAction(action: { (_) in
            self.hideMaskView()
        })
        return mask
    }()

    var window:UIWindow! {
        return UIApplication.shared.keyWindow
    }

    // ===================  func   ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        navigationController?.navigationBar.isTranslucent = false
        edgesForExtendedLayout = [];
        self.hero.isEnabled = true
        self.view.addSubview(bottomPopView)
        
        self.modalPresentationStyle = .fullScreen

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearTimes = appearTimes + 1
        BaseVC.currentVC = String(describing: self.classForCoder)
        navigationController?.setNavigationBarHidden(hideNav, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureEnable
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = self.autoHideKeyboard
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.dismissType == .pop{
            backClosure = nil
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
    
    //传需要接受侧滑手势的视图
    func addSlideBack(_ toView:UIView) -> Void {
        let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        screenEdgePanGR.edges = .left
        toView.addGestureRecognizer(screenEdgePanGR)
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
            self.closeKeyboard()
        case .changed:
            let progress = gr.translation(in: nil).x / view.bounds.width
            Hero.shared.update(progress)
        default:
            if (gr.translation(in: nil).x + gr.velocity(in: nil).x) / view.bounds.width > 0.38 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }

    func addTapCloseKeyBoard(_ view:UIView) {
        let tag = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tag)
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
}



extension BaseVC {
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
    
    class func fromStoryboard(_ identify: String? = nil) -> BaseVC {
        let id = identify ?? String(describing: type(of:self.init()))
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id) as! BaseVC
        vc.modalPresentationStyle = .fullScreen
        return vc
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
        var w = 18 * title.count + 2
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

