//
//  ScanCodeVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/27.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import AVFoundation

class ScanCodeVC: BaseVC {

    var holeH = KScreenWidth * 0.7
    var scanHoleY: CGFloat {
        return (KScreenHeight - holeH)*0.4
    }
    var holeRect:CGRect{
        return CGRect(x: KScreenWidth * 0.15, y: scanHoleY, width: holeH, height: holeH)
    }
    
    var naviView:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KNaviBarH))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6044234155)
        
        let btn = UIButton(frame: CGRect(x: 0, y: KNaviBarH-44, width: 60, height: 44))
        let img = #imageLiteral(resourceName: "access-left").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        v.addSubview(btn)
        return v
    }()
    
    var scanView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        view.backgroundColor = .black
        return view
    }()
    
    var lightBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: KScreenWidth-60, y: KNaviBarH-44, width: 60, height: 44))
        let img = #imageLiteral(resourceName: "scan-light").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(openLight), for: .touchUpInside)
        return btn
    }()
    
    //扫码核心
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var timer:Timer?
    var getResult:Bool = false
    
    //扫码遮挡试图
    var blackView:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    }()
    var slideBGView :UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.image = #imageLiteral(resourceName: "scan-bg")
        v.clipsToBounds = true
        return v
    }()
    var sliderView :UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.image = #imageLiteral(resourceName: "scan-slider")
        return v
    }()
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var contentTV: UITextView!
    var currentResult:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        self.view.backgroundColor = .black
        addSlideBack(view)
        self.initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        //在viewDidLoad 初始化会造成卡顿
        startScaning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.endScaning()
    }
    
    func initUI() {
        self.view.addSubview(scanView)
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight), cornerRadius: 0)
        bezierPath.append(UIBezierPath(roundedRect: holeRect, cornerRadius: 0).reversing())
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        blackView.layer.mask = shapeLayer
        self.view.addSubview(blackView)
        
        slideBGView.frame = holeRect
        self.view.addSubview(slideBGView)
        
        sliderView.frame = CGRect(x: 0, y: -30, width: holeH, height: 30)
        slideBGView.addSubview(sliderView)

        naviView.addSubview(lightBtn)
        self.view.addSubview(naviView)
        
        self.view.bringSubviewToFront(bottomView)
    }
    
    @objc func timeRepateAction(){
        sliderView.frame = CGRect(x: 0, y: -30, width: holeH, height: 30)
        UIView.animate(withDuration: 2-0.1) {
            self.sliderView.frame = CGRect(x: 0, y: self.holeH, width: self.holeH, height: 30)
        }
    }
    
    //返回
    @objc func back(){
        dismiss(animated: true, completion: nil)
    }
    
    // 打开或关闭闪光灯
    @objc func openLight(){
        if lightBtn.isSelected{
            //关闭 闪光灯
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                }catch{ return }
            }
            lightBtn.isSelected = false
        }else{
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .on
                    device.unlockForConfiguration()
                }catch{
                    print(error)
                    HUD.showText("闪光灯无法打开")
                    return
                }
            }else{
                HUD.showText("当前设备识别不到闪光灯")
                return
            }
            lightBtn.isSelected = true
        }
    }
    
    //开启摄像头
    func startScaning(){
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
            }catch{
                WFPermissionType.capture.showAlert()
                return
            }
            let output = AVCaptureMetadataOutput()
            captureSession?.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = view.layer.bounds
            scanView.layer.addSublayer(previewLayer!)
            captureSession?.startRunning()
            
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timeRepateAction), userInfo: nil, repeats: true)
            timeRepateAction()
            
            getResult = false
        }
    }
    
    //关闭摄像头
    func endScaning(){
        captureSession?.stopRunning()
        captureSession = nil
        timer?.invalidate()
        timer = nil
    }
    
    // 拿到扫描内容 重写
    func receiveScanCode(_ code:String?){
        if code != nil{
            let content = String(format: "%@结果：\n%@\n",contentTV.text ?? "", code!)
            contentTV.text = content
            currentResult = code!
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if self.getResult == true{
            self.startScaning()
            self.getResult = false
        }
    }
    
    @IBAction func openAction(_ sender: Any) {
        if let url = URL(string: currentResult){
            UIApplication.shared.openURL(url)
        }
    }
    
}


extension ScanCodeVC:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if getResult == true{
            return
        }
        getResult = true
        self.endScaning()
        
        // 取出第一个metadata
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if metadataObj.stringValue != nil {
                self.receiveScanCode(metadataObj.stringValue)
            }
        }else{
            HUD.showText("二维码识别异常，请从新扫描")
            HUD.runAfterHud {
                self.getResult = false
            }
        }
    }
}

