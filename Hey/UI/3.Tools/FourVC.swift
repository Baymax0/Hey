//
//  FourVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class FourVC: BaseVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    let perple = #colorLiteral(red: 0.3909234405, green: 0.3515967131, blue: 0.7621985078, alpha: 1)
    let pink = #colorLiteral(red: 1, green: 0.8983818889, blue: 0.900123477, alpha: 1)
    
    @IBOutlet var sc: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true
        self.navigationController?.view.backgroundColor = self.view.backgroundColor
        
        sc.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        self.view.addSubview(sc)
        self.ignoreAutoAdjustScrollViewInsets(sc)
        sc.backgroundColor = .KBGGray
        sc.bm.addConstraints([.top(0), .left(0), .right(0), .h(KScreenHeight)])

    }
    
    @IBAction func cacheSettingAction(_ sender: UIButton) {
        let vc = CachSettingVC()
        vc.modalPresentationStyle = .fullScreen
//        view.hero.id = "view"
        sc.hero.id = "view"
        vc.view.hero.id = "view"
        sender.superview?.hero.id = "title"
        sender.hero.id = "back"
        self.pushViewControllerWithHero(vc)
        
        let tab = self.tabBarController as? BubbleTabBarControllerMy
        tab?.hideTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tab = self.tabBarController as? BubbleTabBarControllerMy
        tab?.showTabbar()
    }
    
    @IBAction func touchUpOutSide(_ sender: UIButton) {
        if sender.tag == 0{
            let vc = FileManageVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func fileManagAction(_ sender: UIButton) {
        if sender.tag == 0{
            
        }
        
        if sender.tag == 1{
            let vc = SolarTorchVC()
            self.pushViewController(vc)
        }
        
        if sender.tag == 2{
            let vc = LittleDradgonVC()
            self.pushViewController(vc)
        }
        
        if sender.tag == 3{
            let vc = UltuManSIgnVC()
            self.pushViewController(vc)
        }
        
        if sender.tag == 4{
            let vc = CaseColorVC()
            self.pushViewController(vc)
        }
        if sender.tag == 5{
            let vc = Calculator()
            self.pushViewController(vc)
        }
        if sender.tag == 6{
            let vc = ARVC()
            self.pushViewController(vc)
        }
        
        if sender.tag == 7{
            let vc = YSLMajiangVC()
            self.pushViewController(vc)
        }
        
        
        
    }
    

}



