//
//  MyTabbarVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class MyTabbarVC: BaseVC {

    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var tabbarH: NSLayoutConstraint!

    let selectedColor = KRed
    let unSelectedColor = KUnselectedGray


    var tabBarNums = 0
    var VCArray = Array<BaseVC>()
    weak var lastBtn:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideNav = true

        tabbarH.constant = KTabBarH

        tabBarNums = 2
        addTabbarItem("发现", "tabbar-find", FindVC.fromStoryboard())
        addTabbarItem("我的", "tabbar-me", MeVC.fromStoryboard())

        pushVC(lastBtn!)
    }

    // 添加items
    func addTabbarItem(_ titile:String,_ imgName:String, _ vc:BaseVC) -> Void {
        let x = VCArray.count * Int(KScreenWidth)/tabBarNums

        //背景按钮
        let bgBtn = UIButton(frame: CGRect(x: x, y: 0, width: Int(KScreenWidth)/tabBarNums, height: 49))
        bgBtn.tag = VCArray.count
        bgBtn.addTarget(self, action: #selector(self.pushVC), for: .touchUpInside)
        tabBar.addSubview(bgBtn)

        //动画按钮
        let btnw = 50
        let btnH = 50
        let btnX = (Int(KScreenWidth)/tabBarNums - btnw )/2
        let btn = DOFavoriteButton(frame: CGRect(x: btnX, y: -5, width: btnw, height: btnH), image: UIImage(named: imgName))
        btn.imageColorOff = unSelectedColor
        btn.imageColorOn = selectedColor
        btn.circleColor = selectedColor
        btn.lineColor = KOrange

        btn.tag = 1001
        btn.isUserInteractionEnabled = NO
        bgBtn.addSubview(btn)

        // 标题
        let lab = UILabel(frame: CGRect(x: 0, y: 33, width: Int(bgBtn.frame.size.width), height: 15))
        lab.tag = 1002
        lab.text = titile
        lab.textColor = unSelectedColor
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textAlignment = .center
        bgBtn.addSubview(lab)



        vc.view.frame =  CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - KTabBarH)
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
        VCArray.append(vc)

        //默认选择第一个
        if VCArray.count == 1{
            lastBtn = bgBtn
        }
    }

    // 按钮点击事件
    @objc func pushVC(_ btn:UIButton) -> Void {
        let vc = VCArray[btn.tag]
        self.view.bringSubview(toFront: vc.view)
        setBtnON(lastBtn,false)
        setBtnON(btn,true)
        lastBtn = btn
    }

    // 设置按钮状态
    func setBtnON(_ btn:UIButton? ,_ on:Bool) -> Void {
        guard btn != nil else {
            return
        }

        let animBtn = btn?.viewWithTag(1001) as! DOFavoriteButton
        let lab = btn?.viewWithTag(1002) as! UILabel
        if on {
            animBtn.select()
            lab.textColor = selectedColor
        }else{
            animBtn.deselect()
            lab.textColor = unSelectedColor
        }
    }

}
