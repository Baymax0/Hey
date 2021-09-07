//
//  CaseColorVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/22.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import AVFoundation

class CaseColorVC: BaseVC {

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var colorView: UIView!

    //
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var photoOutput:AVCapturePhotoOutput?
    var videoConnection: AVCaptureConnection?//捕获链接
    
    @IBOutlet weak var centerBtn: UIButton!
    // 进度条
    @IBOutlet weak var lineBgVIew: UIView!
    @IBOutlet weak var progress: UIView!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        
        lineBgVIew.backgroundColor = .white
        lineBgVIew.layer.borderColor = UIColor.black.alpha(0.3).cgColor
        lineBgVIew.layer.borderWidth = 4
        
        self.progress.frame = CGRect(x: 0, y: 0, width: 15, height: 8)
        
        progress.backgroundColor =  UIColor.black.alpha(0.3)
        lineBgVIew.alpha = 0

    }

    @IBAction func backAction(_ sender: Any) {
        super.back()
    }
    
    @IBAction func touchDownACtion(btn: UIButton) {
        btn.isSelected = true;
        // 延迟调用
        let deadline = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if btn.isSelected == true{
                self.lineBgVIew.showWithAnimation(0.2)
                self.progress.w = 15
                UIView.animate(withDuration: 1) {
                    self.progress.w = 148
                    self.lineBgVIew.layoutIfNeeded()
                } completion: { (_) in
                    if btn.isSelected == true{
                        //拍照
                        self.screenSnapshot()
                    }
                }
                self.startScaning()
            }
        }
    }
    
    @IBAction func touchUpACtion(btn: UIButton!){
        if btn != nil{
            btn.isSelected = false
        }
        lineBgVIew.alpha = 0
        self.endScaning()
    }
    
    //开启摄像头
    func startScaning(){
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
            }catch{
//                WFPermissionType.capture.showAlert()
                return
            }
            captureSession?.startRunning()
            
            //照片输出
            photoOutput = AVCapturePhotoOutput()
            
            //添加照片输出流到会话中
            if(captureSession!.canAddOutput(photoOutput!)){
                captureSession!.addOutput(photoOutput!)
            }
        }
    }
    
    //关闭摄像头
    func endScaning(){
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    
    
    
    
}

extension CaseColorVC : AVCapturePhotoCaptureDelegate{
    
    // 截图
    func screenSnapshot(){
        videoConnection = photoOutput!.connection(with: AVMediaType.video)
        if videoConnection == nil {
            print("take photo failed!")
        }else{
            let setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
            photoOutput!.capturePhoto(with: setting, delegate: self)
        }
    }
    
    //得到截图
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(){
            let image = UIImage.init(data: data)
            self.handleImage(img: image!)
            
        }
    }
    
    //处理截图
    func handleImage(img:UIImage) {
        let ratio:CGFloat = 1
        let size = img.size
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        img.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = scaledImage
        
        scaledImage?.getColors({ (colors) in
//            let color = colors?.background
            self.changeColorAnimation(colors?.background)
            self.touchUpACtion(btn: nil)
            
        })
    }
    
    // 执行动画
    func changeColorAnimation(_ color:UIColor!) {
        //圆圈1--小圆
        let centerRect = centerBtn.frame;
        let smallCircleBP = UIBezierPath(ovalIn: centerRect)
        
        //圆圈2--大圆
        let r = KScreenHeight / 2 + 100
        let x = centerRect.center.x - r
        let y = centerRect.center.y - r
        let bigRect = CGRect(x: x, y: y, width: KScreenHeight+200, height: KScreenHeight+200)
        let bigCircleBP = UIBezierPath(ovalIn: bigRect)

        let tempV = UIView()
        tempV.frame = colorView.bounds
        tempV.backgroundColor = color
        tempV.tag = 10
        self.colorView.addSubview(tempV)
        
        
        let maskLayer = CAShapeLayer()
        tempV.layer.mask = maskLayer
        maskLayer.path = smallCircleBP.cgPath
        
        let anime = CABasicAnimation()
        anime.fromValue = smallCircleBP.cgPath
        anime.toValue = bigCircleBP.cgPath
        anime.duration = 0.2
        anime.delegate = self
        anime.fillMode = .forwards;
        anime.isRemovedOnCompletion = NO;
        maskLayer.add(anime, forKey: "path")
    }
}

extension CaseColorVC : CAAnimationDelegate{

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let v = self.colorView.viewWithTag(10)
        self.colorView.backgroundColor = v?.backgroundColor
        v?.removeFromSuperview()

    }
}
