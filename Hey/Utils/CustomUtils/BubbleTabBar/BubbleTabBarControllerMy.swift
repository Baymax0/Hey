//
//  BubbleTabBarControllerMy.swift
//  Lee
//
//  Created by 李志伟 on 2020/9/27.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

class BubbleTabBarControllerMy: BubbleTabBarController {

    var launchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = #colorLiteral(red: 0.1579992771, green: 0.1818160117, blue: 0.5072338581, alpha: 1)
        self.tabBar.backgroundColor = .KBGGray
        
        
        let one = OneVC()
        one.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-news"), selectedImage: nil, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
//        let two = TwoVC()
//        two.tabBarItem = self.getItem(title: "Clock", image: #imageLiteral(resourceName: "tabbar-clock"), selectedImage: nil, color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
//
        let three = ThreeVC()
        three.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-smile"), selectedImage: nil, color: #colorLiteral(red: 0.236158222, green: 0.5290616751, blue: 0.6408655047, alpha: 1))

        let four = FourVC()
        four.tabBarItem = self.getItem(title: "Events", image: #imageLiteral(resourceName: "tabbar-Home"), selectedImage: nil, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        self.viewControllers = [
            BaseNavigationVC(rootViewController: one),
//            BaseNavigationVC(rootViewController: two),
            BaseNavigationVC(rootViewController: three),
            BaseNavigationVC(rootViewController: four)
        ]
        
//        launchView = UIView()
//        launchView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
//        launchView.backgroundColor = #colorLiteral(red: 0.2086526453, green: 0.2038630247, blue: 0.195168227, alpha: 1)
//        self.view.addSubview(launchView)
//
//        let tempView = UIView()
//        tempView.frame = CGRect(x: 0, y: KScreenHeight/2, width: KScreenWidth, height: KScreenHeight/2)
//        tempView.backgroundColor = .white
//        launchView.addSubview(tempView)
//
//        let imgView = UIImageView()
//        imgView.frame = CGRect(x: (KScreenWidth-620)/2, y: 0, width: 620, height: KScreenHeight)
//        imgView.image = UIImage(named: "launch")
//        imgView.contentMode = .scaleAspectFit
//        launchView.addSubview(imgView)
//
//        // 延迟调用
//        UIView.animate(withDuration: 0.7, delay: 1, options: [.curveEaseOut,]) {
//            tempView.y -= KScreenHeight
//            tempView.h += KScreenHeight
//            imgView.y = -KScreenHeight
//        } completion: { (_) in
//            UIView.animate(withDuration: 0.3, delay: 0, options: []) {
//                self.launchView.alpha = 0
//            } completion: { (_) in
//                self.launchView.removeFromSuperview()
//            }
//        }
    }
    
    func getItem(title: String?, image: UIImage?, selectedImage: UIImage?,color:UIColor?) -> CBTabBarItem {
        let item = CBTabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tintColor = color
        return item;
    }
    

}
