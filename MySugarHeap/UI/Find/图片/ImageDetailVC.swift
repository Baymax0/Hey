//
//  ImageDetailVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class ImageDetailVC: BaseVC {
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    @IBOutlet weak var bgSC: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var imageViewH: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var imgTitleLab: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLab: UILabel!
    @IBOutlet weak var detailLab: UILabel!

    @IBOutlet weak var favoriteBtn: DOFavoriteButton!
    
    var heroId:Int = 0
    
    var chooseTagView:BMTagChooseView?

    var model:DTImgListModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KBGGray

        imageView.hero.id = "imgHeroId \(heroId)"
        bottomView.hero.id =  "bottom \(heroId)"
        imgTitleLab.hero.id =  "title \(heroId)"
        userNameLab.hero.id =  "userName \(heroId)"
        userImgView.hero.id =  "avatar \(heroId)"

        favoriteBtn.imageColorOff = KBlack_178
        favoriteBtn.imageColorOn = KRed
        favoriteBtn.circleColor = KRed
        favoriteBtn.lineColor = KOrange

        bgSC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        view.insertSubview(visualEffectView, at: 0)

        loadData()
    }

    func loadData(){

        imgTitleLab.text = model.msg
        userNameLab.text = model.sender.username
        detailLab.text = String(format: "id:%d", model.sender.id ?? -1)

        let imgW = KScreenWidth - 10*2
        let imgStr = model.photo.path.replacingOccurrences(of: "_webp", with: "")
        imageViewH.constant = CGFloat(model.photo.height)*(imgW/CGFloat(model.photo.width))
        imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imgStr)!), placeholder: KDefaultImg.image, options: [.transition(ImageTransition.fade(1))])

        let userImgStr = model.sender.avatar.replacingOccurrences(of: "_webp", with: "")
        userImgView.kf.setImage(with: userImgStr.resource, placeholder: KDefaultAvatar.image, options: [.transition(ImageTransition.fade(1))])
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func likeAction(_ sender: DOFavoriteButton) {
        if sender.isSelected{
            sender.deselect()
        }else{
            sender.select()
            chooseTagView = BMTagChooseView(.ImgTag) { (arr) in
                print(arr?.count ?? 0)
            }
            chooseTagView!.show()
        }
    }

}
