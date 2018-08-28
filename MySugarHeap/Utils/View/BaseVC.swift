//
//  BaseVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Hero

class BaseVC: UIViewController {

    var hideNav = true
    var popGestureEnable = true

    static var currentVC:String?

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
            return .default
        }
    }

    lazy var window:UIWindow? = {
        return UIApplication.shared.keyWindow
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseVC.currentVC = String(describing: self.classForCoder)
        navigationController?.setNavigationBarHidden(hideNav, animated: true)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureEnable
    }


}



extension BaseVC{
    class func fromStoryboard(_ identify: String? = nil) -> BaseVC {
        let id = identify ?? String(describing: type(of:self.init()))
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: id) as! BaseVC
        return vc
    }
}
