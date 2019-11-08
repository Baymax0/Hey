//
//  MusicVC.swift
//  LisApp
//
//  Created by yimi on 2019/4/4.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class MusicVC: BaseVC {

    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var bgView2: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView1.layer.shadowColor = #colorLiteral(red: 0.2684550085, green: 0.302216689, blue: 0.3954433693, alpha: 1)
        bgView1.layer.shadowOffset = CGSize(width: 2, height: 2)
        bgView1.layer.shadowOpacity = 0.5
        bgView1.layer.shadowPath = UIBezierPath(rect: bgView1.bounds).cgPath
        bgView1.layer.shadowRadius = 10
        bgView1.layer.masksToBounds = NO

        bgView2.layer.shadowColor = #colorLiteral(red: 0.2684550085, green: 0.302216689, blue: 0.3954433693, alpha: 1)
        bgView2.layer.shadowOffset = CGSize(width: 2, height: 2)
        bgView2.layer.shadowOpacity = 0.5
        bgView2.layer.shadowPath = UIBezierPath(rect: bgView1.bounds).cgPath
        bgView2.layer.shadowRadius = 10
        bgView2.layer.masksToBounds = NO

    }
    
    //点击
    @IBAction func touchDown(_ sender: UIButton) {
        self.largeEffect(sender.superview, true)
    }
    
    //点击 抬起
    @IBAction func touchCancel(_ sender: UIButton) {
        self.largeEffect(sender.superview, false)

        let vc = UkuleleVC.fromStoryboard() as! UkuleleVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func touchCancel2(_ sender: UIButton) {
        self.largeEffect(sender.superview, false)
    }
    
    
    func largeEffect(_ view:UIView?, _ shake:Bool){
        if shake {
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                view?.transform = CGAffineTransform(rotationAngle: -0.02)
            }) { (_) in
                UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
                    view?.transform = CGAffineTransform(rotationAngle: 0.02)
                }, completion: nil)
            }
        }else{
            UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                view?.transform=CGAffineTransform.identity;
            }, completion: nil)
        }
    }
    
}
