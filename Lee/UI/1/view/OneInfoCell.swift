//
//  OneInfoCell.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/10.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

class OneInfoCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewButton: UIButton!
    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var imgAuth: UILabel!

    @IBOutlet weak var contentLab: UILabel!
    
    @IBOutlet weak var authLab: UILabel!

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var moreView1: UIView!
    @IBOutlet weak var moreView_Detail1: UIView!
    @IBOutlet weak var moreView2: UIView!
    @IBOutlet weak var moreView_Detail2: UIView!
    @IBOutlet weak var moreView3: UIView!
    @IBOutlet weak var moreView_Detail3: UIView!
    @IBOutlet weak var moreView4: UIView!
    @IBOutlet weak var moreView_Detail4: UIView!
    @IBOutlet weak var moreView5: UIView!
    @IBOutlet weak var moreView_Detail5: UIView!

    var labArr: Array<UIView>!
    var lab2Arr: Array<UIView>!
    
    @IBOutlet weak var wordMaxH: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSC: UIScrollView!
    
    @IBOutlet weak var bottomCellH: NSLayoutConstraint!
    
    var model:One_Today_Info_Model!
    weak var vc: BaseVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labArr = [moreView1,moreView2,moreView3,moreView4,moreView5]
        lab2Arr = [moreView_Detail1,moreView_Detail2,moreView_Detail3,moreView_Detail4,moreView_Detail5]
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.1
        bgView.layer.shadowRadius = 3
        bgView.layer.masksToBounds = false
        bgView.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        
        bottomSC.delegate = self

        bottomSC.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
    }
    
    func setData(_ model:One_Today_Info_Model!) {
        self.setNull()
        
        if model == nil || model.id == nil{ return }
        self.model = model
        let arr = model.content_list
        if let obj = arr?.bm_object(0){
            imgView.kf.setImage(with: obj.img_url.resource, placeholder: UIImage(named: "placeholder"), options:  [.transition(.fade(0.45))])
            
            if obj.orientation == "1"{
                imgH.constant = 2080 / 1860 * (KScreenWidth - 18 - 18)
            }else{
                imgH.constant = 2333.0 / 3499.0 * (KScreenWidth - 18 - 18)
            }
            imgView.layoutIfNeeded()
            
            imgAuth.text = "摄影｜" + (obj.pic_author ?? "")
            authLab.text = obj.words_author

            let str = obj.forward ?? ""
//            let str = "本书于网络选购，收到书后，看到书中满满作者旅游照片时，觉得自己上当了，有些不悦。心情平复后听了随书赠送的CD，这才懂得这本书中眭澔平的文字只是CD的附属品，遥远的孤独的灵魂越拉越近，宛如最后一封信般凄冷。后看到网络上多有对本书的谴责，特为本书说些公道话。"

            let attributeStr = NSMutableAttributedString(string: str)
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            let length = str.count
            attributeStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: length))
            contentLab.attributedText = attributeStr
            
            var realIndex = 0
            let labArr:Array<UIView> = [moreView1,moreView2,moreView3,moreView4,moreView5]
            
            for i in 1..<arr!.count{
                let content = arr![i]
                let imgName = ["1":"newspaper","2":"books.vertical","3":"questionmark.circle","4":"music.quarternote.3","5":"video"]//,"8":"radio"

                if let name = content.categoryName{
                    // 主内容
                    let v = labArr.bm_object(realIndex)
                    v?.isHidden = false
                    let line = v?.viewWithTag(9)
                    let lab1 = v?.viewWithTag(10) as? UILabel
                    let lab2 = v?.viewWithTag(110) as? UILabel
                    let img = v?.viewWithTag(3) as? UIImageView
                    
                    let btn = v?.viewWithTag(77) as? UIButton
                    btn?.tag = i

                    line?.alpha = 1
                    lab1?.text = "#" + name
                    lab2?.text = content.title
                    img?.image = UIImage.init(systemName: imgName[content.category] ?? "")
                    
                    // 附内容
                    let v2 = lab2Arr.bm_object(realIndex)
                    v2?.isHidden = false
                    let img_detail = v2?.viewWithTag(1) as? UIImageView
                    let lab_detail = v2?.viewWithTag(2) as? UILabel
                    let btn_detail = v2?.viewWithTag(77) as? UIButton
                    btn_detail?.tag = i
                    
                    img_detail?.kf.setImage(with: content.img_url.resource, placeholder: UIImage(named: "placeholder"), options:  [.transition(.fade(0.45))])
                    var contentDetail = content.forward
                    //影视附上 电影名称
                    if content.category == "5"{
                        if content.video_author != nil{
                            contentDetail = (contentDetail ?? "") + "\n《" + content.video_author + "》"
                        }
                    }
                    //音乐附上 名称和作者
                    if content.category == "4"{
                        if content.music_name != nil{
                            let name = content.music_name!
                            let author = content.audio_author ?? ""
//                            let album = content.audio_album ?? ""
                            let detail = "《\(name)》--\(author)"
                            contentDetail = (contentDetail ?? "") + "\n" + detail
                        }
                    }
                    
                    lab_detail?.text = contentDetail
                    
                    realIndex += 1
                }
            }
        }else{
            imgH.constant = 2333.0 / 3499.0 * (KScreenWidth - 18 - 18)
        }
    }
    
    func setNull() {
        imgAuth.text = ""
        authLab.text = ""
        contentLab.text = ""
        contentLab.alpha = 1
        authLab.alpha = 1
        
        self.wordMaxH.constant = 500
        for v in labArr{
            let line = v.viewWithTag(9)
            let lab1 = v.viewWithTag(10) as? UILabel
            let lab2 = v.viewWithTag(110) as? UILabel
            let img = v.viewWithTag(3) as? UIImageView
            line?.alpha = 0
            lab1?.text = ""
            lab2!.text = ""
            img?.image = nil
            v.isHidden = true
        }
        
        self.bottomCellH.constant = 0
        for v in lab2Arr{
            v.alpha = 0.01
            v.isHidden = true
        }
    }
    
    @IBAction func touchDown(_ sender: UIButton) {
//        print(sender.tag)
//        sender.backgroundColor = UIColor.white.alpha(0.5)
//        // 延迟调用
//        let deadline = DispatchTime.now() + 0.5
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
//            sender.backgroundColor = .clear
//        }
    }
    
    @IBAction func click(_ sender: UIButton) {
        let index = sender.tag
        if let model = self.model.content_list.bm_object(index){
            let detail = OneDetailVC()
            detail.model = model
            self.vc.pushViewController(detail)
        }
    }
    
    @IBAction func topImagAction(_ sender: Any) {
        
    }
    
    
  
}

extension OneInfoCell:UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //当前在收缩的位置
        if self.wordMaxH.constant >= 100{
            // 松手的位置是往上的
            if scrollView.contentOffset.y > 10{
                // 展开动画
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
                    self.contentLab.alpha = 0
                    self.authLab.alpha = 0
                    
                } completion: { (_) in }
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                    self.wordMaxH.constant = 10
                    self.bottomCellH.constant = 40
                    for v in self.lab2Arr{
                        v.alpha = 1
                    }
                    self.layoutIfNeeded()
                } completion: { (_) in }
                
            }    
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.wordMaxH.constant < 100{
            // 松手的位置是往下的
            if scrollView.contentOffset.y < -80{
                print(scrollView.contentOffset.y)
                //收缩动画
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear) {
                    self.contentLab.alpha = 1
                    self.authLab.alpha = 1
                } completion: { (_) in }

                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                    self.wordMaxH.constant = 500
                    self.bottomCellH.constant = 0
                    for v in self.lab2Arr{
                        v.alpha = 0.01
                    }
                    self.layoutIfNeeded()
                } completion: { (_) in }
                
                scrollView.isScrollEnabled = false
                scrollView.setContentOffset(.zero, animated: true)
                scrollView.isScrollEnabled = true

            }
        }
    }
    
    
    
    
    
}


