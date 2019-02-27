//
//  ImageDetailVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/23.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
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

    weak var model:BMImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KBGGray

        imageView.hero.id = "imgHeroId \(heroId)"
        bottomView.hero.id =  "bottom \(heroId)"
        imgTitleLab.hero.id =  "title \(heroId)"
        favoriteBtn.imageColorOff = KBlack_178
        favoriteBtn.imageColorOn = KRed_shanhu
        favoriteBtn.circleColor = KRed_shanhu
        favoriteBtn.lineColor = KOrange_light
        bgSC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        bgSC.delegate = self
        view.insertSubview(visualEffectView, at: 0)
        loadData()

        //侧滑返回
        addSlideBack(view)
    }

    func loadData(){
        if model.imgUrl == nil{
            return
        }
        imgTitleLab.text = model.title
        let imgW = KScreenWidth - 10*2
        let imgStr = model.imgUrl.replacingOccurrences(of: "_webp", with: "")
        imageViewH.constant = CGFloat(model.height)*(imgW/CGFloat(model.width))
        imageView.loadImage(imgStr, placeHolder: KDefaultImg)
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

    @IBAction func downloadAction(_ sender: Any) {
        let img = imageView.image
        UIImageWriteToSavedPhotosAlbum(img!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        if error != nil{
            print("error!")
            return
        }else{
            HUD.text("已保存到相册")
        }
    }
}

extension ImageDetailVC:UIScrollViewDelegate{

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y < -70{
            dismiss(animated: YES, completion: nil)
        }
    }


}





