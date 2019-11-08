//
//  AppDelegate.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

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
        
        let one = OneVC()
        one.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-dashboard"), selectedImage: nil, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

        let two = TwoVC()
        two.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-clock"), selectedImage: nil, color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))

        let three = ThreeVC()
        three.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-folder"), selectedImage: nil, color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))

        let four = FourVC()
        four.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-menu"), selectedImage: nil, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        
        let tabBarController = BubbleTabBarController()
        tabBarController.viewControllers = [one, two, three, four]
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.1579992771, green: 0.1818160117, blue: 0.5072338581, alpha: 1)
        tabBarController.tabBar.backgroundColor = .KBGGray

        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
    
    func getItem(title: String?, image: UIImage?, selectedImage: UIImage?,color:UIColor?) -> CBTabBarItem {
        let item = CBTabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tintColor = color
        return item;
    }
    
    @objc func maskViewAction(){
        self.showMaskView(false)}

    func applicationWillResignActive(_ application: UIApplication) {
        self.showMaskView(true)}
    
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

