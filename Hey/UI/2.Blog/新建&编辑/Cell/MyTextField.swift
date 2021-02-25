//
//  MyTextField.swift
//  Hey
//
//  Created by 李志伟 on 2020/4/29.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

class MyTextField: UITextView {

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
