//
//  UIView+Alpha.swift
//  Lee
//
//  Created by yimi on 2019/11/14.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import UIKit
import Hero

extension UIView {
    
    func addAlphaGradientHori(_ one:CGFloat,_ zero:CGFloat, _ frame:CGRect? = nil){
        let rect = frame ?? self.bounds
        let bla = Double(one/rect.width)
        let whi = Double(zero/rect.width)
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        if bla < whi{
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.alpha(0).cgColor]
            gradientLayer.locations = [NSNumber(floatLiteral: bla),NSNumber(floatLiteral: whi)]
        }else{
            gradientLayer.colors = [UIColor.black.alpha(0).cgColor, UIColor.black.cgColor]
            gradientLayer.locations = [NSNumber(floatLiteral: whi),NSNumber(floatLiteral: bla)]
        }
        gradientLayer.frame = rect
        layer.mask = gradientLayer
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension BaseVC {
    //传需要接受侧滑手势的视图
    func addSlideBack(_ toView:UIView) -> Void {
        let screenEdgePanGR = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        screenEdgePanGR.edges = .left
        toView.addGestureRecognizer(screenEdgePanGR)
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
            self.closeKeyboard()
        case .changed:
            let progress = gr.translation(in: nil).x / view.bounds.width
            Hero.shared.update(progress)
        default:
            if (gr.translation(in: nil).x + gr.velocity(in: nil).x) / view.bounds.width > 0.38 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}


extension Utils{
    
    static func isDirectory(_ path:String) -> Bool {
        var isDirectory:ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        if isDirectory.boolValue == false{
            return false
        }else{
            return true
        }
    }
    
    static func isDirectory2(_ name:String) -> Bool {
        if Utils.isVideoFile(name){
            return false
        }
        if Utils.isImageFile(name){
            return false
        }
        
        return true
    }
    
    static func isVideoFile(_ path:String) -> Bool {
        if path.contains(".mp4") {
            return true
        }
        if path.contains(".mov") {
            return true
        }
        if path.contains(".MOV") {
            return true
        }
        if path.contains(".avi") {
            return true
        }
        if path.contains(".flv") {
            return true
        }
        if path.contains(".mkv") {
            return true
        }
        if path.contains(".rmvb") {
            return true
        }
        if path.contains(".3gp") {
            return true
        }
        return false
    }
    
    static func isImageFile(_ path:String) -> Bool {
        if path.contains(".jpg") {
            return true
        }
        if path.contains(".JPG") {
            return true
        }
        if path.contains(".jpeg") {
            return true
        }
        if path.contains(".JPEG") {
            return true
        }
        if path.contains(".png") {
            return true
        }
        if path.contains(".PNG") {
            return true
        }
        if path.contains(".bmp") {
            return true
        }
        if path.contains(".BMP") {
            return true
        }
        if path.contains(".gif") {
            return true
        }
        if path.contains(".GIF") {
            return true
        }
        return false
    }
    
    static func random(_ max:UInt32 = 10) -> Int {
        return Int(arc4random() % max) + 1
    }
}



