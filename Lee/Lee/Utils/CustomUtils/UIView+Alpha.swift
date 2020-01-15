//
//  UIView+Alpha.swift
//  Lee
//
//  Created by yimi on 2019/11/14.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import UIKit

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
