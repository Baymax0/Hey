//
//  UITableView+Utils.swift
//  wangfuAgent
//
//  Created by lzw on 2018/8/9.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

protocol CustomCellProtocol {
    static func cellFromNib(with table:UITableView) -> Self

    static func cell(with table:UITableView) -> Self
}

extension CustomCellProtocol{
    static func cellFromNib(with table:UITableView) -> Self{
        let c = self as! UITableViewCell.Type
        let Identity = String(describing: c.classForCoder())
        var cell = table.dequeueReusableCell(withIdentifier: Identity) as? Self
        if cell == nil {
            let nib  = UINib(nibName: Identity, bundle: nil)
            print(nib)
            table.register(nib, forCellReuseIdentifier: Identity)
            cell = (table.dequeueReusableCell(withIdentifier: Identity)) as? Self
        }
        return cell!
    }
    static func cell(with table:UITableView) -> Self{
        let c = self as! UITableViewCell.Type
        let Identity = String(describing: c.classForCoder())
        var cell = table.dequeueReusableCell(withIdentifier: Identity) as? Self
        if cell == nil {
            table.register(c, forCellReuseIdentifier: Identity)
            cell = table.dequeueReusableCell(withIdentifier: Identity) as? Self
        }
        return cell!
    }
}

extension UITableViewCell:CustomCellProtocol{}







