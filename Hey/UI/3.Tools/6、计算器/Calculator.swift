//
//  Calculator.swift
//  Hey
//
//  Created by 李志伟 on 2021/2/6.
//  Copyright © 2021 baymax. All rights reserved.
//

import UIKit
import AVFoundation

class Calculator: BaseVC {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outButLable: UILabel!

    var btnSound: AVAudioPlayer!
    
    var currentOperation = Operation.Empty//运算符
    var runningNumber = ""  //输入的值
    var leftValueStr = ""   //运算符左侧数字
    var rightValueStr = ""  //运算符右侧数字
    var result = ""         //计算结果
    
    @IBOutlet var numBtnArr: [UIButton]!
    
    var isMusicMode:Bool = false
    @IBOutlet weak var calculateImg: UIImageView!
    @IBOutlet weak var musicImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        
        outButLable.text = ""
        
        musicImg.alpha = 0
    }

    // 输入运算符
    func processOperatation(operation: Operation) {
        //连续运算 则再按操作符的时候 先算出结果
        if currentOperation != Operation.Empty {
            //输入运算符的时候 会置空输入框 并把输入框的数字放在运算符左侧 如果多次点击运算符 则不处理输入框 只修改运算符
            if runningNumber != "" {
                rightValueStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValueStr)! * Double(rightValueStr)!)"
                }else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValueStr)! / Double(rightValueStr)!)"
                }else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValueStr)! - Double(rightValueStr)!)"
                }else if currentOperation == Operation.Add {
                    result = "\(Double(leftValueStr)! + Double(rightValueStr)!)"
                }
                leftValueStr = result
                outButLable.text = result
            }
            
            currentOperation = operation
        }
        // 存储操作符
        else {
            leftValueStr = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func playSound(_ name:Int! = nil) {
        if btnSound != nil && btnSound.isPlaying {
            btnSound.stop()
        }
        let soundName = name == nil ? "btn" : name.toString()!
        
        btnSound = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "wav")!))
        btnSound.prepareToPlay()
        
        btnSound.play()
    }
    
    // MARK: -  ---------------------- click ------------------------
    // 0-9
    @IBAction func numberPressed(sender: UIButton){
        playSound(sender.tag)
        runningNumber += "\(sender.tag)"
        outButLable.text = runningNumber
    }
    
    // 除号
    @IBAction func onDividePressed(sender: AnyObject) {
        playSound()
        processOperatation(operation: .Divide)
        outButLable.text = ""
    }
    
    // 乘号
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        playSound()
        processOperatation(operation: .Multiply)
        outButLable.text = ""
    }
    
    // 减号
    @IBAction func onSubtractPressed(sender: AnyObject) {
        playSound()
        processOperatation(operation: .Subtract)
        outButLable.text = ""
    }
    
    // 加号
    @IBAction func onAddPressed(sender: AnyObject) {
        playSound()
        processOperatation(operation: .Add)
        outButLable.text = ""
    }
    
    // 等号 保留上次的运算符
    @IBAction func onEqualPressed(sender: AnyObject){
        playSound()
        processOperatation(operation: currentOperation)
    }
    
    // clear
    @IBAction func emptyPressed(sender: AnyObject){
        playSound()
        leftValueStr = ""
        rightValueStr = ""
        runningNumber = ""
        outButLable.text = ""
        currentOperation = Operation.Empty
    }
    
    @IBAction func changeMode(_ sender: Any) {
        var nowImg:UIImageView!
        var showImg:UIImageView!
        var numArr:Array<Int>!
        if isMusicMode == false{
            nowImg = calculateImg
            showImg = musicImg
            numArr = [7,1,2,3,4,5,6,7,1,2]
        }else{
            nowImg = musicImg
            showImg = calculateImg
            numArr = [0,1,2,3,4,5,6,7,8,9]
        }
        
        
        UIView.animate(withDuration: 0.3) {
            nowImg.alpha = 0
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                showImg.alpha = 1
            } completion: { (_) in}
        }
        
        for btn in numBtnArr{
            if btn.tag > 0 && btn.tag < 8{
                continue
            }
            UIView.animate(withDuration: 0.3) {
                btn.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
                btn.alpha = 0
            } completion: { (_) in
                let str = numArr[btn.tag].toString() ?? "0"
                btn.setImage(UIImage.name(str), for: .normal)
                UIView.animate(withDuration: 0.3) {
                    btn.transform = .identity
                    if self.isMusicMode{
                        btn.alpha = 0.7
                    }else{
                        btn.alpha = 1
                    }
                } completion: { (_) in}
            }
        }
        isMusicMode = !isMusicMode
    }
    
    

}
