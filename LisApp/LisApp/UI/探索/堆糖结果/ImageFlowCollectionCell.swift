//
//  ImageFlowCollectionCell.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher

protocol CustomeCellProtocol:NSObjectProtocol{
    func didSelectedItems(_ index:IndexPath) -> Void
}

class ImageFlowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLab: UILabel!


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
        self.bgView.layer.borderColor = KBGGrayLine.cgColor
        self.bgView.layer.borderWidth = 1
    }
    
    func setData(_ mod:BMImage) -> Void {
        if mod.imgUrl == nil{
            return
        }
        self.imgView.backgroundColor = KBGGrayLine
        let imgStr = mod.imgUrl.replacingOccurrences(of: "_webp", with: "")
        
        self.imgView.kf.setImage(
            with: imgStr.resource,
            placeholder: KDefaultImg.image,
            options: [.transition(ImageTransition.fade(0.3)),
                      .cacheMemoryOnly]
        )
        
        if mod.showed == nil {
            self.alpha = 0
            UIView.animate(withDuration: 0.7) {
                self.alpha = 1
            }
            mod.showed = ""
        }else{
            self.alpha = 1
        }
        self.titleLab.text = mod.title
    }

    static func getHeight(_ mod:BMImage) -> CGFloat {
        var num:CGFloat = 2;
        if KScreenWidth > 500{
            num = 5;
        }
        let w = (KScreenWidth-MyCollectionViewLayout().columnMargin*(num+1))/num
        let imgW = mod.width ?? 1
        let imgH = mod.height ?? 1
        let h = (w / CGFloat(imgW) * CGFloat(imgH))
        return h + 30
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
