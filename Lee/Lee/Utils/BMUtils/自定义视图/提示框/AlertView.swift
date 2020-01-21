//
//  AlertView.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/23.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

extension UIViewController{
    // baseView
    private func showAlertView(_ title:String, _ msg:String, complish: (() -> ())? = nil, cancel: (() -> ())? = nil){
        UIView.animate(withDuration: 0.1) {
            let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
                complish?()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler:{ (action) in
                cancel?()
            })
            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: YES, completion: nil)
        }
    }
    
    func showComfirm(_ title:String, _ msg:String, cancel:(()->())? = nil, complish:(()->())? = nil){
        self.showAlertView(title, msg, complish: complish, cancel: cancel)
        
    }
    
    func showInputView(_ title:String, _ msg:String, cancel:(()->())? = nil, complish:((String?)->())? = nil){
        var inputText = UITextField()
        
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
            complish?(inputText.text)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel , handler:{ (action) in
            cancel?()
        })
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        alertVC.addTextField { (textField) in
            inputText = textField
        }
        self.present(alertVC, animated: YES, completion: nil)
        
    }
    
}




