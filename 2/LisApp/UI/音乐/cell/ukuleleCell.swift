//
//  ukuleleCell.swift
//  LisApp
//
//  Created by yimi on 2019/4/11.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

class ukuleleCell: UITableViewCell {
    
    static var cellH:CGFloat = 85

    @IBOutlet weak var imgVIew: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var orgiLab: UILabel!
    
    var tempModel:TKArticle?

    func setData(_ model:TKArticle, _ animation:Bool = true){
        if self.tempModel?.title == model.title{
            return
        }
        self.tempModel = model
        
        if animation == true{
            if model.isShowed == false {
                model.isShowed = true
                self.alpha = 0
                UIView.animate(withDuration: 0.35) {
                    self.alpha = 1
                }
            }
        }
        titleLab.text = model.title
        orgiLab.text = model.magazineName
        if let _ = model.cover{
            self.imgVIew.kf.setImage(with: model.cover.resource, placeholder: nil, options: [.transition(.fade(0.45))])
        }else{
            let name = "instrume-"+Utils.random(10).toString()
            self.imgVIew.image = UIImage(named: name)
        }
        self.selectionStyle = .none
    }


    
}
