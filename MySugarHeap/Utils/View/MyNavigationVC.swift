//
//  MyNavigationVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Hero

class MyNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isHidden = true
        self.hero.navigationAnimationType = .fade

    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hero.isEnabled = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension MyNavigationVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
