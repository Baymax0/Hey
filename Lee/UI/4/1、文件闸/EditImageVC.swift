//
//  EditImageVC.swift
//  LisApp
//
//  Created by yimi on 2019/2/26.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import CoreGraphics

class EditImageVC: BaseVC {
    
    var path:String!
    
    @IBOutlet weak var contentImage: UIImageView!
    
    var orignImg:UIImage!
    var myNewImg:UIImage!{
        didSet{
            contentImage.image = myNewImg
        }
    }
    
    @IBOutlet weak var slideBGView: UIView!
    @IBOutlet weak var sliderView: UISlider!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orignImg = UIImage(contentsOfFile: path)
        myNewImg = UIImage(contentsOfFile: path)
        slideBGView.isHidden = true
    }
    

    @IBAction func closeEditAction(_ sender: Any) {
        if slideBGView.isHidden{
            dismiss(animated: false, completion: nil)
        }else{
            self.contentImage.transform = CGAffineTransform.identity
            slideBGView.isHidden = true
        }
    }
    
    @IBAction func saveEditAction(_ sender: Any) {
        if slideBGView.isHidden{
            dismiss(animated: false, completion: nil)
        }else{
            slideBGView.isHidden = true
            //save transform
            var cor = Double(self.sliderView.value / 180.0)
            cor = Double.pi * cor
            self.myNewImg = self.imageRotatedByRadians(CGFloat(cor))
        }
    }
    
    @IBAction func editAction(_ btn: UIButton) {
        if btn.tag == 0{
            self.myNewImg = self.rotate(.left)
        }
        if btn.tag == 1{
            
        }
        if btn.tag == 2{
            self.myNewImg = self.rotate(.upMirrored)
        }
        if btn.tag == 3{
            self.myNewImg = UIImage(contentsOfFile: path)
        }
        if btn.tag == 4{
            self.sliderView.value = 0
            slideBGView.isHidden = false
        }
    }
    
    func rotate(_ orient:UIImage.Orientation) -> UIImage {
        let cgImage = self.myNewImg.cgImage!
        var rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        var result:UIImage!
        
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext! = UIGraphicsGetCurrentContext()
        context.clip(to: rect)
        
        switch orient {
            case .upMirrored:
                UIGraphicsBeginImageContext(rect.size)
                let context:CGContext! = UIGraphicsGetCurrentContext()
                context.clip(to: rect)
                context.rotate(by: CGFloat(Double.pi))
                context.translateBy(x: -rect.size.width, y: -rect.size.height)
                context.draw(cgImage, in: rect)
                let drawImage = UIGraphicsGetImageFromCurrentImageContext()
                result = UIImage(cgImage: drawImage!.cgImage!, scale: self.myNewImg.scale, orientation: self.myNewImg.imageOrientation)
                UIGraphicsEndImageContext()
            case .left:
                rect = CGRect(x: 0, y: 0, width: cgImage.height, height: cgImage.width)
                UIGraphicsBeginImageContext(rect.size)
                let context:CGContext! = UIGraphicsGetCurrentContext()
                context.clip(to: rect)
                context.rotate(by: CGFloat(Double.pi) * -0.25)
//                context.translateBy(x: 0, y: -200)
                context.draw(cgImage, in: rect)
                let drawImage = UIGraphicsGetImageFromCurrentImageContext()
                result = UIImage(cgImage: drawImage!.cgImage!, scale: self.myNewImg.scale, orientation: self.myNewImg.imageOrientation)
                UIGraphicsEndImageContext()
            default:
                return self.myNewImg
        }
        
        return result
    }
    
    func imageRotatedByRadians(_ radians:CGFloat) -> UIImage {
        let box = UIView(frame: CGRect(x: 0, y: 0, width: self.myNewImg.size.width, height: self.myNewImg.size.height))
        let t = CGAffineTransform(rotationAngle: radians)
        box.transform = t
        let size = box.frame.size
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: size.width/2, y: size.height/2)
        context.rotate(by: radians)
        context.scaleBy(x: 1, y: -1)
        context.draw(myNewImg.cgImage!, in: CGRect(x: -self.myNewImg.size.width / 2, y: -self.myNewImg.size.height / 2, width: self.myNewImg.size.width, height: self.myNewImg.size.height))
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return new!
    }
    
    @IBAction func slideChangeSmall(_ sender: UIButton) {
        if (sender.tag == 0) {
            self.sliderView.value = self.sliderView.value - 0.6;
        }else{
            self.sliderView.value = self.sliderView.value + 0.6;
        }
        self.sliderValueChangeAction(sliderView)
    }
    
    @IBAction func sliderValueChangeAction(_ sender: UISlider) {
        var cor = Double(self.sliderView.value / 180.0)
        cor = Double.pi * cor
        let transform = CGAffineTransform(rotationAngle: CGFloat(cor))
        self.contentImage.transform = transform
    }

}
