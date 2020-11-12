//
//  PopViewManager.swift
//  ciao
//
//  Created by 蔡林海 on 2020/9/7.
//  Copyright © 2020 蔡林海. All rights reserved.
//

import UIKit

enum PopViewType:Int {
    ///渐变
    case FadeInOut      = 0
    ///缩放
    case ZoomInOut      = 1
    ///往上
    case Upward         = 2
    ///往下
    case Downward       = 3
    ///往左
    case Leftward       = 4
    ///往右
    case Rightward      = 5
}
class PopViewManager: NSObject {
    
    /// 弹出框
    /// - Parameters:
    ///   - contentView: 弹出框的内容
    ///   - containerView: 弹出框的背景
    ///   - animatorType: 弹出框的类型
    ///   - layout: 弹出框的位置
    static func show(contentView:UIView,containerView:UIView = UIApplication.shared.keyWindow!,animatorType:PopViewType = .FadeInOut,layout:BaseAnimator.Layout = .center(.init()))  {
        var animator: PopupViewAnimator?
        switch animatorType.rawValue {
        case 1:
            animator = ZoomInOutAnimator(layout: layout)
        case 2:
            animator = UpwardAnimator(layout: layout)
        case 3:
            animator = DownwardAnimator(layout: layout)
        case 4:
            animator = LeftwardAnimator(layout: layout)
        case 5:
            animator = RightwardAnimator(layout: layout)
        default:
            animator = FadeInOutAnimator(layout: layout)
        }
        let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator!)
        //配置交互
        popupView.isDismissible = true
        popupView.isInteractive = true
        //可以设置为false，再点击弹框中的button试试？
        //        popupView.isInteractive = false
        popupView.isPenetrable = false
        popupView.display(animated: true, completion: nil)
    }
}
/**
     func displayPopupView() {
         contentView = Bundle.main.loadNibNamed("TestAlertView", owner: nil, options: nil)?.first as? TestAlertView
         //- 确定动画效果及其布局
         var layout: BaseAnimator.Layout?
         switch layoutIndex {
         case 0:
             layout = .center(.init())
         case 1:
             layout = .top(.init(topMargin: 100))
         case 2:
             layout = .bottom(.init(bottomMargin: 34))
         case 3:
             layout = .leading(.init(leadingMargin: 20))
         case 4:
             layout = .trailing(.init(trailingMargin: 20))
         case 5:
             layout = .frame(CGRect(x: 100, y: 300, width: 200, height: 200))
         default: break
         }
         var animator: PopupViewAnimator?
         switch animationIndex {
         case 0:
             animator = FadeInOutAnimator(layout: layout!)
         case 1:
             animator = ZoomInOutAnimator(layout: layout!)
         case 2:
             animator = UpwardAnimator(layout: layout!)
         case 3:
             animator = DownwardAnimator(layout: layout!)
         case 4:
             animator = LeftwardAnimator(layout: layout!)
         case 5:
             animator = RightwardAnimator(layout: layout!)
         case 6:
             let spring = DownwardAnimator(layout: layout!)
             spring.displayDuration = 0.5
             spring.displaySpringDampingRatio = 0.7
             spring.displaySpringVelocity = 0.5
             animator = spring
         case 7:
             animator = CustomAnimator(layout: layout!)
         default:
             break
         }
         let popupView = PopupView(containerView: containerView, contentView: contentView, animator: animator!)
         //配置交互
         popupView.isDismissible = true
         popupView.isInteractive = true
         //可以设置为false，再点击弹框中的button试试？
 //        popupView.isInteractive = false
         popupView.isPenetrable = false
         //- 配置背景
         popupView.backgroundView.style = self.backgroundStyle
         popupView.backgroundView.blurEffectStyle = self.backgroundEffectStyle
         popupView.backgroundView.color = self.backgroundColor
         popupView.display(animated: true, completion: nil)
     }
 
 */
