//
//  TwoVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class TwoVC: BaseVC {

    var isBlocked:Bool! //当前是否能往前走
    var isOnGem:Bool!   //是否有钻石
    var isOnCloseSwitch:Bool! //脚下开关是否关闭
    
    // 右转
    func turnRight(){}
    // 左转
    func turnLeft(){}
    // 收集
    func collectGem(){}
    // 向前
    func moveForward(){}
    // 切换开关
    func toggleSwitch(){}
    
    
    func main(){
        while !isBlocked{
            //进入下一排
            moveForward()
            turnRight()
            //开关
            if isOnCloseSwitch{
                toggleSwitch()
            }
            //宝石
            moveForward()
            if isOnGem{
                collectGem()
            }
            //开关
            moveForward()
            if isOnCloseSwitch{
                toggleSwitch()
            }
            //返回 开头位置
            turnRight()
            turnRight()
            moveForward()
            moveForward()
            turnRight()
        }
    }
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 

}
