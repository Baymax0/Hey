//
//  AppDelegate.swift
//  LisApp
//
//  Created by yimi on 2019/2/18.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

//com.yimi.test233
//baymax.lisapp

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
//        img.image = #imageLiteral(resourceName: "点击")
        let path = Bundle.main.path(forResource: "613779", ofType: "gif")
        let url = URL(fileURLWithPath: path!)
        img.kf.setImage(with: LocalFileImageDataProvider(fileURL: url), placeholder: nil, options: [KingfisherOptionsInfoItem.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil)
//        img.kf.setImage(with: "613779.gif".resource)

        view.addSubview(img)
        return view
    }()

    // MARK: -  ---------------------- func ------------------------
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
//        img.kf.setImage(with: "613779.gif".resource)
//        window?.addSubview(img)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.showMaskView(true)
    }
    
    @objc func maskViewAction(){
        self.showMaskView(false)
    }
    
    // 显示 或 隐藏 mask
    func showMaskView(_ show:Bool) {
        if show{
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BMCache.saveWhenQuit()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

}




/*
 橙色使用图标
 https://www.iconfont.cn/collections/detail?spm=a313x.7781069.1998910419.d9df05512&cid=15090
 

 
 */

