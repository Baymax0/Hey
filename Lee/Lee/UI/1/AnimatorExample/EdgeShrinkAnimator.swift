//
//  EdgeShrinkAnimator.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-08-15.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit
import CollectionKit

open class EdgeShrinkAnimator: Animator {
    
    open override func insert(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
        super.insert(collectionView: collectionView, view: view, at: at, frame: frame)
        view.alpha = 0;
        view.isHidden = false
    }
    
    open override func delete(collectionView: CollectionView, view: UIView) {
        super.delete(collectionView: collectionView, view: view)
        view.isHidden = true
        view.alpha = 0;
    }
    
    open override func update(collectionView: CollectionView, view: UIView, at: Int, frame: CGRect) {
        super.update(collectionView: collectionView, view: view, at: at, frame: frame)
        let effectiveRange: ClosedRange<CGFloat> = (-frame.width*3)...0
        let absolutePosition = frame.origin - collectionView.contentOffset
        if absolutePosition.x < effectiveRange.lowerBound {
          view.transform = .identity
          return
        }

        var scale = (absolutePosition.x.clamp(effectiveRange.lowerBound, effectiveRange.upperBound) - effectiveRange.lowerBound) / (effectiveRange.upperBound - effectiveRange.lowerBound)

        // 放大透明度变化范围

        // 转成平方 线性函数
        if scale < 1{
            let final:CGFloat = 0.8
            let finalComp:CGFloat = 1 - final

            let temp:CGFloat = CGFloat((scale-final)/finalComp).clamp(0, 1)
            scale = final + finalComp * temp * temp * temp
        }

        let alpha = (scale - 0.6) / 0.4
//        if at == 2 {
//            print(String(format: "ind: %d  x: %0.1f scale:%0.2f",at , absolutePosition.x , scale))
//        }
        if absolutePosition.x > 340 {
            let t = absolutePosition.x - 340
            view.alpha = (1 - t / 20)
        }else{
            view.alpha = alpha
        }
        let translation = absolutePosition.x < effectiveRange.upperBound ? effectiveRange.upperBound - absolutePosition.x - (1 - scale) / 2 * frame.width : 0
        view.transform = CGAffineTransform.identity.translatedBy(x: translation, y: 0).scaledBy(x: scale, y: scale)
    }
}
