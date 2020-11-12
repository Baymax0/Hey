//
//  VIew+Custom.swift
//  Lee
//
//  Created by 李志伟 on 2020/9/27.
//  Copyright © 2020 baymax. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIView{
    
    @discardableResult
    func addInnerShadow(w:CGFloat) -> InnerShadowLayer{
        let innerShadowLayer = InnerShadowLayer(with: self, radius: 5, color: .black, opacity: 1)
        innerShadowLayer.frame = self.bounds
        self.layer.addSublayer(innerShadowLayer)
        return innerShadowLayer
    }
    
    
    func addGradientTop(){
        
    }
    
}










