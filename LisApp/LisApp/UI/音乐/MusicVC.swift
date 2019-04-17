//
//  MusicVC.swift
//  LisApp
//
//  Created by yimi on 2019/4/4.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class MusicVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //点击
    @IBAction func touchDown(_ sender: UIButton) {
        self.largeEffect(sender.superview, big: true)
    }
    
    //点击 抬起
    @IBAction func touchCancel(_ sender: UIButton) {
        self.largeEffect(sender.superview, big: false)

        
        let vc = UkuleleVC.fromStoryboard() as! UkuleleVC
        present(vc, animated: true, completion: nil)
    }
    
    
    func largeEffect(_ view:UIView?, big:Bool){
        
    }
    
}
