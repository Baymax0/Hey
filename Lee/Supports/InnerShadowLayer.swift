//
//  InnerShadowLayer.swift
//  Lee
//
//  Created by 李志伟 on 2020/9/28.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit


class InnerShadowLayer :CALayer {
    
    var innerShadowColor: UIColor = UIColor.black
    
    var innerShadowWidth: CGFloat = 5
    
    var innerShadowPath: UIBezierPath! = nil
    
    var innerShadowOffset: CGSize = CGSize.init(width: 3, height: 3)
    
    var innerShadowOpacity: CGFloat = 0
    
    var innerShadowblur: CGFloat = 50


    init(with view:UIView, radius:CGFloat = 5, color:UIColor = .black, offset:CGSize = .zero, opacity:CGFloat = 0) {
        super.init()
        self.frame = view.bounds
        let cornerRadius = view.layer.cornerRadius
        let rect = view.bounds.insetBy(dx: innerShadowWidth, dy: innerShadowWidth)
        self.innerShadowPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        self.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 利用blur+Stroke绘制path边框 达到内阴影的效果
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        let path = UIBezierPath.init(rect: self.bounds)
        ctx.addPath(path.cgPath)
        ctx.clip()
        
        let outer = CGMutablePath()
        var rect = self.bounds
        rect = rect.insetBy(dx: -1 * rect.width, dy: -1 * rect.height)
        outer.addRect(rect)
        outer.addPath(self.innerShadowPath.cgPath)
        outer.closeSubpath()
        ctx.addPath(outer)
        
        // 阴影颜色 主要利用 blur
        let color = self.innerShadowColor.alpha(self.innerShadowOpacity)
        ctx.setShadow(offset: self.shadowOffset, blur: innerShadowblur, color: color.cgColor)
        
        // 填充
        ctx.drawPath(using: .eoFillStroke)
        ctx.restoreGState()
    }
    
}
