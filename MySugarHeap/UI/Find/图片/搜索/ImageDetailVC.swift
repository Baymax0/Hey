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

    @IBOutlet weak var favoriteBtn: DOFavoriteButton!
    
    var heroId:Int = 0
    
    var chooseTagView:BMTagChooseView?

    var model:BMImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KBGGray

        imageView.hero.id = "imgHeroId \(heroId)"
        bottomView.hero.id =  "bottom \(heroId)"
        imgTitleLab.hero.id =  "title \(heroId)"
        favoriteBtn.imageColorOff = KBlack_178
        favoriteBtn.imageColorOn = KRed
        favoriteBtn.circleColor = KRed
        favoriteBtn.lineColor = KOrange
        bgSC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        view.insertSubview(visualEffectView, at: 0)
        loadData()
    }

    func loadData(){
        imgTitleLab.text = model.title
        let imgW = KScreenWidth - 10*2
        let imgStr = model.imgUrl.replacingOccurrences(of: "_webp", with: "")
        imageViewH.constant = CGFloat(model.height)*(imgW/CGFloat(model.width))
        imageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imgStr)!), placeholder: KDefaultImg.image, options: [.transition(ImageTransition.fade(1))])
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func likeAction(_ sender: DOFavoriteButton) {
        if !sender.isSelected{
//            sender.deselect()
//        }else{
            sender.select()
            chooseTagView = BMTagChooseView(.ImgTag) { (arr) in
                let mod = BMFavorite<BMImage>()
                mod.model = self.model
                var dic = Dictionary<String,String>()
                for tag in arr{
                    dic[String(tag.tagId)] = "1"
                }
                mod.tags = dic
                BMCache.addFavorite(mod)
            }
            chooseTagView!.show()
        }
    }

}
