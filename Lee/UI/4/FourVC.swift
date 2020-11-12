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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true

    }
    
    @IBAction func cacheSettingAction(_ sender: Any) {
        let vc = CachSettingVC()
        vc.modalPresentationStyle = .fullScreen
        self.pushViewController(vc)
    }
    
    @IBAction func fileManagAction(_ sender: UIButton) {
        if sender.tag == 0{
            let vc = FileManageVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
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
        
    }
    
    
    

}
