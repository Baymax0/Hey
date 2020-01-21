//
//  CustomCell.swift
//  LisApp
//
//  Created by yimi on 2019/2/21.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var fileImg: UIImageView!
    @IBOutlet weak var fileNameLab: UILabel!
    @IBOutlet weak var gifLab: UILabel!
    @IBOutlet weak var titleLabH: NSLayoutConstraint!
    
    func setType(_ type:Int){
        if self.tag == type{
            return
        }
        self.tag = type
        
        titleLabH.constant = 34
        if (type == 1){// 文字列表
            fileNameLab.textAlignment = .left
            fileNameLab.textColor = .KTextBlack
            fileNameLab.font = UIFont.systemFont(ofSize: 20)
            fileImg.isHidden = true
            gifLab.isHidden = true
        }else if (type == 2){// 文件夹
            fileImg.isHidden = false
            gifLab.isHidden = true
            fileImg.image = UIImage(named: "文件夹")
            fileNameLab.textColor = .KTextBlack
            fileNameLab.textAlignment = .center
            fileNameLab.font = UIFont.systemFont(ofSize: 15)
            fileImg.contentMode = .scaleAspectFit
        }else if (type == 3){// 视频
            fileImg.isHidden = false
            gifLab.isHidden = true
            fileNameLab.textColor = .KTextBlack
            fileNameLab.textAlignment = .center
            fileNameLab.font = UIFont.systemFont(ofSize: 15)
            fileImg.contentMode = .scaleAspectFit
        }else if (type == 4){
            titleLabH.constant = 34
            fileNameLab.textColor = .KTextBlack
            fileNameLab.textAlignment = .center
            fileNameLab.font = UIFont.systemFont(ofSize: 15)

        }
    }
    
}
