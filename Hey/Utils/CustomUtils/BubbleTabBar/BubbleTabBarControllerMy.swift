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
//        self.tabBar.backgroundColor = .clear
        self.tabBar.backgroundColor = .KBGGray
        self.tabBar.isTranslucent = true
        
        self.view.h = KScreenHeight

        let one = OneVC()
        one.tabBarItem = self.getItem(title: "One", image: #imageLiteral(resourceName: "tabbar-news"), selectedImage: nil, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        

        let three = ThreeVC()
        three.tabBarItem = self.getItem(title: "Blog", image: #imageLiteral(resourceName: "tabbar-smile"), selectedImage: nil, color: #colorLiteral(red: 0.236158222, green: 0.5290616751, blue: 0.6408655047, alpha: 1))

        let four = FourVC()
        four.tabBarItem = self.getItem(title: "FunnyApp", image: #imageLiteral(resourceName: "tabbar-Home"), selectedImage: nil, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        self.viewControllers = [
            BaseNavigationVC(rootViewController: one),
//            BaseNavigationVC(rootViewController: two),
            BaseNavigationVC(rootViewController: three),
            BaseNavigationVC(rootViewController: four)
        ]
    }
    
    func hideTabbar() {
        print(self.tabBar.frame)
        UIView.animate(withDuration: 0.3) {
            self.tabBar.y = KScreenHeight
        }
    }
    
    func showTabbar() {
        print(self.tabBar.frame)
        UIView.animate(withDuration: 0.3) {
            self.tabBar.y = KScreenHeight - self.tabBar.h
        }
    }
    
    func getItem(title: String?, image: UIImage?, selectedImage: UIImage?,color:UIColor?) -> CBTabBarItem {
        let item = CBTabBarItem(title: title, image: image, selectedImage: selectedImage)
        item.tintColor = color
        return item;
    }
    

}
