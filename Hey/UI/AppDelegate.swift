//
//  AppDelegate.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var maskView:UIView = {
        let view = UIView(frame: window!.bounds)
        let view2 = UIView(frame: window!.bounds)
        view2.backgroundColor = #colorLiteral(red: 0.9273675444, green: 0.631502671, blue: 0.4286897548, alpha: 1)
        view2.alpha = 0.1
        view.addSubview(view2)
        
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        let btn = UIButton(frame: view.bounds)
        btn.addTarget(self, action: #selector(maskViewAction), for: .touchUpInside)
        view.addSubview(btn)
        
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        img.center = view.center
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .white
        img.alpha = 0.4
        let path = Bundle.main.path(forResource: "613779", ofType: "gif")
        let url = URL(fileURLWithPath: path!)
        img.kf.setImage(with: LocalFileImageDataProvider(fileURL: url), placeholder: nil, options: [KingfisherOptionsInfoItem.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil)
        view.addSubview(img)
        return view
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = BubbleTabBarControllerMy()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        // 配置数据库
        RealmManager.configRealm()
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        //配置One请求数据默认参数
        var oneRequestDic = cache[.oneRequestDic]
        if oneRequestDic == nil{
            oneRequestDic = [:]
            oneRequestDic!["platform"]  = "ios"
            oneRequestDic!["sign"]      = "6cb37b72948f6de5aabc4508c61b9ac1"
            oneRequestDic!["user_id"]   = "9881182"
            oneRequestDic!["uuid"]      = "55E6ABAA-A19C-490C-BEBE-9E54857D9584"
            oneRequestDic!["version"]   = "v5.1.1"
            cache[.oneRequestDic] = oneRequestDic
        }
        cache[.newsList] = nil
        return true
    }
    
    
    
    @objc func maskViewAction(){
        self.showMaskView(false)
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        self.showMaskView(true)
        /// save cache
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    // 显示 或 隐藏 mask
    func showMaskView(_ show:Bool) {
        if show{
            maskView.frame = window!.bounds
            for v in maskView.subviews{
                v.frame = window!.bounds
            }
            if maskView.superview == nil{
                maskView.alpha = 0
                window?.addSubview(maskView)
                UIView.animate(withDuration: 0.2) {
                    self.maskView.alpha = 1
                }}
        }else{
            UIView.animate(withDuration: 0.2, animations: {
                self.maskView.alpha = 0
            }) { (_) in
                self.maskView.removeFromSuperview()
            }}
    }
    

}

