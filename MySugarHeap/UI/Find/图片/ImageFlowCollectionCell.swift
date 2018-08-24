//
//  ImageFlowCollectionCell.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

protocol CustomeCellProtocol:NSObjectProtocol{
    func didSelectedItems(_ index:IndexPath) -> Void
}

class ImageFlowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLab: UILabel!


    weak var delegate : CustomeCellProtocol?

    var indexPath:IndexPath!

    var select:Bool{
        get{return true}
        set{
            if newValue{
                UIView.animate(withDuration: 0.2, animations: {
                    self.bgView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                }) { (_) in}
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.bgView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) { (_) in}
            }
        }
    }
    
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        select = true
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        select = false
        if delegate != nil {
            delegate?.didSelectedItems(indexPath)
        }
    }

}
