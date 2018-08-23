//
//  ImageFlowCollectionCell.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class ImageFlowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    static func getHeight(_ mod:DTImgListModel) -> CGFloat {
        let w = (KScreenWidth-MyCollectionViewLayout().columnMargin*3)/2
        let imgW = mod.photo.width ?? 1
        let imgH = mod.photo.height ?? 1
        let h = (w / CGFloat(imgW) * CGFloat(imgH))
        return h + 50
    }

}
