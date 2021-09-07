//
//  YSLMajiangVC.swift
//  Hey
//
//  Created by 李志伟 on 2021/3/8.
//  Copyright © 2021 baymax. All rights reserved.
//

import UIKit

class YSLMajiangVC: BaseVC {

    @IBOutlet weak var chooseCharctorBg: UIView!
    
    @IBOutlet weak var p1: UIButton!
    @IBOutlet weak var p2: UIButton!
    @IBOutlet weak var p3: UIButton!
    @IBOutlet weak var p4: UIButton!

    var pArr:Array<UIButton>!
    var chooseArr:Array<UIButton>!
    
    var current = 0
    
    var timer:Timer!
    
    @IBOutlet weak var timeLab: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    // tag 1=倒计时，0=暂停
    @IBOutlet weak var stateChangeBtn: UIButton!
    var timeNum = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        pArr = [p1,p2,p3,p4]
        var i = 0
        for p in pArr{
            p.tag = i
            p.alpha = 0.2
            i += 1
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timeLab.setTitle("", for: .normal)
        stateChangeBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer = nil
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.pop()
    }
    
    
    @IBAction func choosePersonAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.alpha = 0.2
        }else{
            sender.alpha = 1
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func finishAction(_ sender: UIButton) {
        sender.isHidden = true
        chooseArr = []
        for b in pArr{
            if b.isSelected == true{
                chooseArr.append(b)
            }
            b.alpha = 0
        }
        chooseArr[0].alpha = 1
        stateChangeBtn.isHidden = false
    }
    
    @IBAction func start(_ sender: UIButton) {
        if sender.tag == 0{
            sender.setTitle("暂停", for: .normal)
        }else{
            sender.setTitle("开始", for: .normal)
        }
        sender.tag = 1 - sender.tag
    }
    
    @objc func timerAction() {
        if stateChangeBtn.tag == 1{
            timeNum = timeNum - 1
            timeLab.setTitle("\(timeNum)", for: .normal)
        }
    }
    
    @IBAction func nextOneAction(_ sender: Any) {
        timeNum = 60
        timeLab.setTitle("\(timeNum)", for: .normal)

        current = (current + 1)%(chooseArr.count)
        
        for p in pArr{
            p.alpha = 0
        }
        let currentBtn = chooseArr[current]
        currentBtn.alpha = 1
    }
    
    
}


