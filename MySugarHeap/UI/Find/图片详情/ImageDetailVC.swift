//
//  ImageDetailVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher

class ImageDetailVC: BaseVC {

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var imageViewH: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!

    var model:DTImgListModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
        let imgW = KScreenWidth - 10*2
        let imgStr = model.photo.path.replacingOccurrences(of: "_webp", with: "")
        imageViewH.constant = CGFloat(model.photo.height)*(imgW/CGFloat(model.photo.width))
        imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imgStr)!), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: YES)
    }
}
