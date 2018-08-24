//
//  MyNavigationVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class MyNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self

    }
}

extension MyNavigationVC:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
