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
        case .changed:
            let progress = gr.translation(in: nil).x / view.bounds.width
            Hero.shared.update(progress)
        default:
            if (gr.translation(in: nil).x + gr.velocity(in: nil).x) / view.bounds.width > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
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
