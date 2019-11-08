//
//  TableViewCell+Utils.swift
//  wangfuAgent
//
//  Created by yimi on 2019/3/18.
//  Copyright © 2019 zhuanbangTec. All rights reserved.
//

import Foundation
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

extension UITableViewCell:CustomCellProtocol{
    static var nib:UINib{
        let name = String(describing: self.classForCoder())
        return UINib.init(nibName: name, bundle: Bundle.main)
    }
    
    static var identityString:String{
        let i = String(describing: self.classForCoder())
        return i;
    }
}



extension UICollectionViewCell{
    static var nib:UINib{
        let name = String(describing: self.classForCoder())
        return UINib.init(nibName: name, bundle: Bundle.main)
    }
    
    static var identityString:String{
        let i = String(describing: self.classForCoder())
        return i;
    }
}

