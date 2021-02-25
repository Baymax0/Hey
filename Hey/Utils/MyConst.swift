//
//  MyConst.swift
//  Lee
//
//  Created by yimi on 2019/11/11.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import UIKit

let stiffness:CGFloat = 230
let damping:CGFloat = 23
var oemInstitutionNo:String! = nil

let safeArea:UIEdgeInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero


extension UIColor {
    open class var githubTheme: UIColor    { return UIColor(named: "githubTheme")!}
}

extension NSNotification.Name {
    
    static let daily_Cell_Action = NSNotification.Name("daily_Cell_Action")
    static let daily_add = NSNotification.Name("daily_Cell_add")
}

