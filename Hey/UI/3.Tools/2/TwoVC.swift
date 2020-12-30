//
//  TwoVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class TwoVC: BaseVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    var clockThemeColor = #colorLiteral(red: 0.2932332158, green: 0.1560938358, blue: 0.2979138494, alpha: 1)

    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var dayLab: UILabel!
    
    var codeTimer: DispatchSourceTimer!
    
    @IBOutlet weak var clockBg1: UIView!//最前
    @IBOutlet weak var clockBg2: UIView!
    @IBOutlet weak var clockBg3: UIView!//最后

    @IBOutlet weak var hourPointBG: UIView!
    @IBOutlet weak var minutePointBG: UIView!
    @IBOutlet weak var secendPointBG: UIView!
    
    // 页面是否在显示
    var isFront = false
    // 显示的时钟还是闹钟列表
    var showAlarm = false

    /// 转场用的maskview
    var transFormMaskView = UIView()
    
    
    @IBOutlet var clockSC: UIScrollView!
    
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var detailBGView: UIView!
    @IBOutlet weak var detilBGViewH: NSLayoutConstraint!
    @IBOutlet weak var detilBGViewW: NSLayoutConstraint!
    
    @IBOutlet weak var readTimeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.hideNav = true
        
        readTimeSwitch.setOn(false, animated: NO)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clockTapAction))
        self.clockBg2.addGestureRecognizer(tap)
        
        
        let swip = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        clockBg2.addGestureRecognizer(swip)
    }
    
    @objc func handleSwipes(_ ges:UIPanGestureRecognizer) {
        let s = ges.translation(in: self.view)
        var rate:CGFloat = s.x / 200.0
        print(rate)
        if rate > 0{
            rate = 0
        }
        
        UIView.animate(withDuration: 0.2) {
            if rate < -0.5{
                self.clockBg2.alpha = 0.1
            }
            
            rate = rate * CGFloat.pi
            self.clockBg2.layer.transform = CATransform3DMakeRotation(rate, 0, 1, 0)
            self.clockBg3.layer.transform = CATransform3DMakeRotation(rate, 0, 1, 0)
        }
        
    }
    
    @objc func clockTapAction() {
        UIView.animate(withDuration: 1) {
            self.clockBg2.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 5.3
        UIView.animate(withDuration: 0.6) {
            self.reloadClock()
        } completion: { (_) in
            self.isFront = true
        }
        dayLab.text = Date().toString("yyyy-MM-dd  EEE")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isFront = false
    }
    
    
    @IBAction func changeShowTypeAction(_ sender: Any) {
        if showAlarm == false{
            self.showAllColckACtion(nil)
        }else{
            self.hideAlarmClock()
        }
    }
    
    @IBAction func showDetailAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let bg = self.detailBGView.viewWithTag(1)
        
        
//        if sender.isSelected {
//            self.maskView.alpha = 0
//            self.view.insertSubview(self.maskView, belowSubview: self.detailBGView)
//        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if sender.isSelected {
                self.detilBGViewW.constant = 200
                self.detilBGViewH.constant = 300
                bg?.alpha = 1
//                self.maskView.alpha = 1
            }else{
                self.detilBGViewH.constant = 45
                self.detilBGViewW.constant = 45
                bg?.alpha = 0
//                self.maskView.alpha = 0
            }
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if sender.isSelected {}
            else{
//                self.maskView.removeFromSuperview()
            }
        }
    }

    
    
    @IBAction func showAllColckACtion(_ sender: Any!) {
        transFormMaskView.alpha = 0;
        view.addSubview(transFormMaskView)
        
        clockSC.frame = CGRect(x: 0, y: 80+44, width: KScreenWidth, height: KScreenHeight - 88 - 44 - KTabBarH)
        clockSC.alpha = 0
        clockSC.y = clockSC.y + 60
        clockSC.backgroundColor = self.view.backgroundColor
        reloadAllClock()
        view.addSubview(clockSC)
        
        UIView.animate(withDuration: 0.3) {
            self.transFormMaskView.alpha = 1
        } completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                self.clockSC.alpha = 1
                self.clockSC.y = self.clockSC.y - 60
            } completion: { (_) in
                
            }
        }
        showAlarm = true;
    }
    
    func hideAlarmClock() {
        UIView.animate(withDuration: 0.2) {
            self.clockSC.alpha = 0
            self.clockSC.y = self.clockSC.y + 60
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.transFormMaskView.alpha = 0
            } completion: { (_) in
            }
        }
        showAlarm = false;
    }
    
    
    
    
    func reloadAllClock(){
        var h:CGFloat = 0
        for _ in 0...2{
            let clock = ClockView.create(false)
            clock.y = h
            clockSC.addSubview(clock)
            
            h = h + 200 + 50
        }
        clockSC.contentSize = CGSize(width: KScreenWidth, height: h)
    }
    
    
    
}


/// UI
extension TwoVC{
    
    // MARK: -  ---------------------- UI ------------------------
    func initUI() {
        detailBtn.layer.cornerRadius = 12
//        detailBtn.backgroundColor = .white

        detailBGView.layer.cornerRadius = 12
        detailBGView.layer.masksToBounds = true
        detailBGView.layer.borderWidth = 1
        detailBGView.layer.borderColor = UIColor.KBGGrayLine.cgColor
        
        detilBGViewH.constant = 45
        detilBGViewW.constant = 45
        
        clockBg1.layer.masksToBounds = false
        clockBg1.layer.shadowColor = #colorLiteral(red: 0.8587785363, green: 0.8870739341, blue: 0.9477807879, alpha: 1).cgColor
        clockBg1.layer.shadowRadius = 5
        clockBg1.layer.shadowOffset = CGSize(width: 4, height: 0)
        clockBg1.layer.shadowOpacity = 0.5
        clockBg1.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).alpha(0.6).cgColor
        clockBg1.layer.borderWidth = 3
        
        clockBg2.layer.masksToBounds = false
        clockBg2.layer.shadowColor = UIColor.white.cgColor
        clockBg2.layer.shadowRadius = 10
        clockBg2.layer.shadowOffset = CGSize(width: -15, height:-15)
        clockBg2.layer.shadowOpacity = 1
        clockBg2.layer.borderWidth = 3
        clockBg2.layer.borderColor = #colorLiteral(red: 0.9572115541, green: 0.9770256877, blue: 0.9895673394, alpha: 1).alpha(0.8).cgColor
        
        clockBg3.layer.masksToBounds = false
        clockBg3.layer.shadowColor = #colorLiteral(red: 0.7530856729, green: 0.7385120988, blue: 0.8191424012, alpha: 1).cgColor
        clockBg3.layer.shadowRadius = 10
        clockBg3.layer.shadowOffset = CGSize(width: 4, height: 4)
        clockBg3.layer.shadowOpacity = 0.2

        // 刻度12，1，2，3，4，5
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 0), at: 0)
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 1), at: 0)
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 2), at: 0)
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 3), at: 0)
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 4), at: 0)
        clockBg2.insertSubview(self.getNumView(#colorLiteral(red: 0.7618617415, green: 0.7454872727, blue: 0.8350893855, alpha: 1), 5), at: 0)

        let arr = [1,2,3,4,6,7,8,9,11,12,13,14,16,17,18,19,21,22,23,24,26,27,28,29]
        for i in arr{
            clockBg2.insertSubview(self.getNumView2(num: i), at: 0)
        }
        
        self.addGradient(view: clockBg2, colorOne: #colorLiteral(red: 0.8903284669, green: 0.9233594537, blue: 0.9614257216, alpha: 1), colorTwo: #colorLiteral(red: 0.9259269834, green: 0.9509976506, blue: 0.9911171794, alpha: 1), endPoint: CGPoint.init(x: 1, y: 1))
        
        codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        codeTimer.setEventHandler(handler: {
            DispatchQueue.main.async {
                self.timeDown()
            }
        })
        codeTimer.resume()
        
        transFormMaskView.backgroundColor = self.view.backgroundColor
        transFormMaskView.frame = CGRect(x: 0, y: 80 + 44, width: KScreenWidth, height: 1000)
        
        
//        self.maskView.addTarget(self, action: #selector(hideMask), for: .touchUpInside)
    }
    
    @objc func hideMask() {
        self.showDetailAction(detailBtn)
    }
    
    /// 每秒调用的计时器
    func timeDown() {
        if isFront == false { return }
        // 刷新指针
        self.reloadClock()
        // 播报
        if readTimeSwitch.isOn {
            self.readTime()
        }
    }
    
    func readTime() {
        let time = Date()
        let secend = time.secendString.toInt()
        if secend % 15 == 0{
            var hour = time.hourString.toInt()
            hour = hour > 12 ? hour - 12 : hour
            hour = hour == 0 ? 12 : hour
            let minute = time.minute
            let secend = time.second

            var str = ""
            if secend == 0{
                str = String(format: "\(hour)点%02d", minute)
            }
            else{
                str = String(format: "%02d分%d", minute,secend)
            }

            SpeechManage.shake()//震动
            SpeechManage.speak(str)//报时
        }
    }
    
    /// 刷新指针
    func reloadClock() {
        let time = Date()
        timeLab.text = time.toString("hh:mm:ss aa")
        let hour = time.hourString.toInt()
        let minute = time.minuteString.toInt()
        let secend = time.secendString.toInt()

        let secendAng:CGFloat = CGFloat(secend % 60) / 60.0 * CGFloat.pi * 2
        let minuteAng:CGFloat = CGFloat(minute % 60) / 60.0 * CGFloat.pi * 2
        let hourAng:CGFloat = CGFloat(hour % 12) / 12.0 * CGFloat.pi * 2 + CGFloat(minute % 60) / 60.0 * CGFloat.pi * 2 / 12

        hourPointBG.transform = CGAffineTransform.init(rotationAngle: hourAng)
        minutePointBG.transform = CGAffineTransform.init(rotationAngle: minuteAng)
        
        UIView.animate(withDuration: 0.2) {
            self.secendPointBG.transform = CGAffineTransform.init(rotationAngle: secendAng)
        }
    }
    
    //小时刻度
    func getNumView(_ color:UIColor, _ num:CGFloat) ->UIView{
        let bgW = 280
        let bg = UIView(frame: CGRect.init(x: 0, y: 0, width: bgW, height: bgW))
        bg.backgroundColor = .clear
        let numW = 6
        let numH = 9
        let numx = (bgW - numW) / 2
        let numY = 11

        let num1 = UIView(frame: CGRect.init(x: numx, y: numY, width: numW, height: numH))
        num1.backgroundColor = color
        num1.cornerRadius    = 3
        bg.addSubview(num1)
        
        let num2 = UIView(frame: CGRect.init(x: numx, y: bgW - numY - numH, width: numW, height: numH))
        num2.backgroundColor = color
        num2.cornerRadius    = num1.cornerRadius
        bg.addSubview(num2)
        
        let ang:CGFloat = num / 6.0 * CGFloat.pi
        bg.transform = CGAffineTransform.init(rotationAngle: ang)
        return bg
    }
    
    //分钟刻度
    func getNumView2(num:Int) -> UIView {
        let bgW = 280
        let bg = UIView(frame: CGRect.init(x: 0, y: 0, width: bgW, height: bgW))
        bg.backgroundColor = .clear
        let numW = 5
        let numH = 5
        let numx = (bgW - numW) / 2
        let numY = 11

        let num1 = UIView(frame: CGRect.init(x: numx, y: numY, width: numW, height: numH))
        num1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        num1.cornerRadius    = 3
        bg.addSubview(num1)
        
        let num2 = UIView(frame: CGRect.init(x: numx, y: bgW - numY - numH, width: numW, height: numH))
        num2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        num2.cornerRadius    = num1.cornerRadius
        bg.addSubview(num2)
        
        let ang:CGFloat = CGFloat(num) / 30.0 * CGFloat.pi
        bg.transform = CGAffineTransform.init(rotationAngle: ang)
        return bg
    }
    
    // 添加渐变
    func addGradient(view:UIView, colorOne:UIColor,colorTwo:UIColor,endPoint:CGPoint) {
        //渐变设置
        let gradient:CAGradientLayer = CAGradientLayer.init()
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = endPoint
        gradient.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradient.frame = view.bounds
        gradient.masksToBounds = true
        gradient.cornerRadius = view.w / 2
//        view.layer.addSublayer(gradient)
        view.layer.insertSublayer(gradient, at: 0)
    }
}

