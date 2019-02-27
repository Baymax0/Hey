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

    var hideNav = false

    var appearTimes:Int = 0
    
    static var currentVC:String?

    lazy var maskView : UIButton = {
        let mask = UIButton.init(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        mask.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        mask.addTarget(self, action: #selector(hideMaskView), for: .touchUpInside)
        return mask
    }()
    @objc func hideMaskView() -> Void {
        UIView.animate(withDuration: 0.15, animations: {
            self.maskView.alpha = 0
        }) { (_) in
            self.maskView.removeFromSuperview()
        }
    }
    
    lazy var window:UIWindow? = {
        return UIApplication.shared.keyWindow
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{
//            return .lightContent
            return .default
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KBGGray
        self.hero.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearTimes = appearTimes + 1
        BaseVC.currentVC = String(describing: self.classForCoder)
        navigationController?.setNavigationBarHidden(hideNav, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = popGestureEnable
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
            self.closekeyboard()
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
    
    func addTapCloseKeyBoard(_ addedview:UIView) -> Void {
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(closekeyboard))
        addedview.addGestureRecognizer(tapBackground)
    }
    
    @objc func closekeyboard(){
        self.view.endEditing(true)
    }
    
    
    deinit {
        print(String(describing: self.classForCoder) + " is deinit")
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
