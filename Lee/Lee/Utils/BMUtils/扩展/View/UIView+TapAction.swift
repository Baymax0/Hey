                                                                                                                                                                                                                                                                                                                                                                  //
//  UIButton+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/9/6.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import Foundation
import UIKit

typealias BMViewAction = (UIView)->()

/// 扩展 回调闭包的存储属性
extension UIView{
    private struct BMViewAssociatedKeys{
        static var actionKey = "my_actionKey_2"
    }

    @objc dynamic var tempCacheClouse: BMViewAction? {
        set{
            objc_setAssociatedObject(self, &BMViewAssociatedKeys.actionKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            if let action = objc_getAssociatedObject(self, &BMViewAssociatedKeys.actionKey) as? BMViewAction{
                return action
            }
            return nil
        }
    }
    // 点击的回调方法
    @objc func customAction(btn: UIButton){
        // 执行闭包
        if let action = self.tempCacheClouse {
            action(self)
        }
    }
}

public class BMNameSpace_Action<Base> {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol BMCompatible_Action {
    associatedtype Compatible_Action
    var tap: Compatible_Action { get }
}

public extension BMCompatible_Action {
    var tap: BMNameSpace_Action<Self> {
        return BMNameSpace_Action(self)
    }
}

extension UIView : BMCompatible_Action{}

/// 命名空间内添加方法
extension BMNameSpace_Action  where Base: UIView {
    func addAction(action: @escaping  BMViewAction){
        self.base.tempCacheClouse = action
        let tap = UITapGestureRecognizer(target: self.base, action: #selector(UIButton.customAction(btn:)))
        self.base.addGestureRecognizer(tap)
    }
}

extension BMNameSpace_Action  where Base: UIButton {
    func addTouchUpAction(action: @escaping  BMViewAction){
        self.base.tempCacheClouse = action
        self.base.addTarget(self.base, action: #selector(UIButton.customAction(btn:)), for: .touchUpInside)
    }
}





