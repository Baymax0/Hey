//
//  MyTabbarVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Hero
import Masonry

class MyTabbarVC: BaseVC {

    @IBOutlet weak var tabBar: UIStackView!
    @IBOutlet weak var tabbarH: NSLayoutConstraint!

    let selectedColor = KRed
    let unSelectedColor = KBlack_178
    
    @IBOutlet weak var btn1: DOFavoriteButton!
    @IBOutlet weak var btn2: DOFavoriteButton!
    @IBOutlet weak var btn3: DOFavoriteButton!


    var tabBarNums = 0
    var VCArray = Array<BaseVC>()
    weak var lastBtn:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabbarH.constant = KTabBarH + 15;

        tabBarNums = 3
        addTabbarItem(" ", "tabbar-find", MeVC.fromStoryboard())
        addTabbarItem(" ", "tabbar-music", MusicVC.fromStoryboard())
        addTabbarItem(" ", "tabbar-tools", ToolsVC.fromStoryboard())
        pushVC(lastBtn!)

        tabBar.hero.modifiers = [.translate(y:KTabBarH)]
        
        btn1.imageColorOff = unSelectedColor
        btn1.imageColorOn = selectedColor
        btn1.circleColor = selectedColor
        btn1.lineColor = KOrange
        
        btn2.imageColorOff = unSelectedColor
        btn2.imageColorOn = selectedColor
        btn2.circleColor = selectedColor
        btn2.lineColor = KOrange
        
        btn3.imageColorOff = unSelectedColor
        btn3.imageColorOn = selectedColor
        btn3.circleColor = selectedColor
        btn3.lineColor = KOrange
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    
    

    // 添加items
    func addTabbarItem(_ titile:String,_ imgName:String, _ vc:BaseVC) -> Void {
        vc.view.frame =  CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - tabbarH.constant)
        self.view.addSubview(vc.view)
        self.addChild(vc)
        VCArray.append(vc)

        //默认选择第一个
        if VCArray.count == 1{
            lastBtn = btn1
        }
    }
    
    
    // 按钮点击事件
    @IBAction  func pushVC(_ btn:UIButton) -> Void {
        let vc = VCArray[btn.tag]
        self.view.bringSubviewToFront(vc.view)
        setBtnON(lastBtn,false)
        setBtnON(btn,true)
        lastBtn = btn
    }

    // 设置按钮状态
    func setBtnON(_ btn:UIButton? ,_ on:Bool) -> Void {
        guard btn != nil else {
            return
        }

        var animBtn : DOFavoriteButton!
        
        if btn!.tag == 0{
            animBtn = btn1}
        if btn!.tag == 1{
            animBtn = btn2}
        if btn!.tag == 2{
            animBtn = btn3}
        
        if on {
            animBtn.select()
        }else{
            animBtn.deselect()
        }
    }

}
