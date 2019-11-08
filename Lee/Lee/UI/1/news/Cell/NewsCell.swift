//
//  NewsCell.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ model:IdailyNewsModel) {
        imgView.kf.setImage(with: model.cover_landscape.resource)
    }

}
