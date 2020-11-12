//
//  SolarTorchVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/21.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import ImageIO
import AVFoundation

class SolarTorchVC: BaseVC ,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .lightContent }
    }
    
    var session:AVCaptureSession!

    @IBOutlet weak var lightImgView: UIImageView!
    
    var flashIsOn:Bool = false
    
    var device:AVCaptureDevice!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        //获得默认摄像头
        device = AVCaptureDevice.default(for: .video)
//        self.changeSide(nil)//切换位前置
        self.updateDevice()//开始获取参数
        
        lightImgView.image = UIImage.init(systemName: "lightbulb.slash")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
        openLight(false)
    }
    
    func updateDevice() {
        if device == nil {return}
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        session = AVCaptureSession()
        session.canSetSessionPreset(.high)
        if session.canAddInput(input){
            session.addInput(input)
        }
        if session.canAddOutput(output){
            session.addOutput(output)
        }
        session.startRunning()
    }

    @IBAction func backAction(_ sender: Any) {
        super.back()
    }
    
    @IBAction func changeSide(_ sender: Any!) {
        let devices = AVCaptureDevice.devices(for: .video)
        let needPosition:AVCaptureDevice.Position = self.device.position == .front ? .back : .front
        for d in devices{
            if d.position == needPosition{
                self.device = d
                break
            }
        }
        self.updateDevice()
    }
    
    
    func openLight(_ open:Bool){
        if flashIsOn == open { return }
        
        if open == false{
            //关闭 闪光灯
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .off
                    device.unlockForConfiguration()
                }catch{ return }
                lightImgView.image = UIImage.init(systemName: "lightbulb.slash")
                flashIsOn = false
            }
        }else{
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch{
                do{
                    try device.lockForConfiguration()
                    device.torchMode = .on
                    device.unlockForConfiguration()
                }catch{
                    print(error)
                    Hud.showText("闪光灯无法打开")
                    return
                }
                flashIsOn = true
                lightImgView.image = UIImage.init(systemName: "lightbulb.fill")
            }else{
                Hud.showText("当前设备识别不到闪光灯")
                return
            }
        }
    }
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let metadataDict = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let dic = NSDictionary(dictionary: metadataDict!)
        
        let exifDicStr = kCGImagePropertyExifDictionary as NSString
        let exifMetadata = dic[exifDicStr] as? NSDictionary
        let brightnessStr = kCGImagePropertyExifBrightnessValue as NSString
        let brightnessValue = exifMetadata?[brightnessStr] as? NSNumber

        let floatValue = brightnessValue?.floatValue ?? 0
        print(floatValue)
        if floatValue > 6{
            self.openLight(true)
        }else{
            if floatValue < 5.8{
                self.openLight(false)
            }
        }
    }
    
    
}
