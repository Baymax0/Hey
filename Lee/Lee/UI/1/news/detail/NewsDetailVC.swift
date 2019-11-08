//
//  NewsDetailVC.swift
//  Lee
//
//  Created by yimi on 2019/11/6.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Hero
import Kingfisher

class NewsDetailVC: BaseVC {

    // 背景 过度中虚化用
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    // 缩小的背景视图
    @IBOutlet weak var contentCard: UIView!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var locationLab: UILabel!

    @IBOutlet weak var locationLabW: NSLayoutConstraint!
    
    @IBOutlet weak var contentTF: UITextView!

    
    @IBOutlet weak var imageView: UIImageView!
    
    //    let imageView = UIImageView()
//    let subtitleLabel = UILabel()
//    let titleLabel = UILabel()
    
    var model :IdailyNewsModel!
    
    var endHeroAnim:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.initUI();
        self.loadData(model)
        
//        titleLabel.frame = CGRect(x: 8, y: visualEffectView.y + 5, width: bounds.width - 16, height: 25)
//        subtitleLabel.frame = CGRect(x: 8, y: visualEffectView.y + 30, width: bounds.width - 16, height: 16)
        
        
        // add a pan gesture recognizer for the interactive dismiss transition
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleBackGes(gr:))))
        
        // 添加边缘手势
        let ges = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGes(gr:)))
        ges.edges = .left
        view.addGestureRecognizer(ges)
    }
    
    func initUI(){
        visualEffectView.frame  = UIScreen.main.bounds
        view.insertSubview(visualEffectView, at: 0)
//        view.addSubview(visualEffectView)
        
        // 缩小的背景视图
        contentCard.frame  = UIScreen.main.bounds
        contentCard.backgroundColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        contentCard.clipsToBounds = true
        contentCard.layer.cornerRadius = 10
//        view.addSubview(contentCard)
        
        contentTF.backgroundColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        contentTF.isEditable = false
        contentTF.isSelectable = false
        contentCard.addSubview(contentTF)
        
    }
    
    func loadData(_ model : IdailyNewsModel!){
        self.model = model;
        let cardHeroId = "card\(model!.guid ?? 1)"
        
        let time = model.title
        let address = model.location
        let tag = model.ui_sets["caption_subtitle"] ?? ""

        timeLab.text = time
        timeLab.hero.modifiers = [.fade, .scale(0.7)];
        
        locationLab.text = tag
        locationLab.hero.modifiers = [.fade, .scale(0.7)];
        locationLab.textColor = #colorLiteral(red: 0.7151494227, green: 0.7151494227, blue: 0.7151494227, alpha: 1)
        locationLab.layer.borderColor = locationLab.textColor.cgColor
        locationLab.layer.borderWidth = 1
        locationLabW.constant = locationLab.text!.stringWidth(15) + 10
        
//locationLabW
        
        imageView.hero.id = cardHeroId
        
        contentCard.hero.modifiers = [.source(heroID: cardHeroId), .spring(stiffness: 150, damping: 25)]
        visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
        
        
//        cardView.titleLabel.text = model?.ui_sets["caption_subtitle"] ?? ""
//        cardView.subtitleLabel.text = model?.location ?? ""
//        cardView.imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
//        let imgH = cardView.imageView.image?.size.height ?? 1
//        let imgW = cardView.imageView.image?.size.width ?? 1
//        let newH = imgH / imgW * KScreenWidth
//        cardView.imageView.h = newH
        
        imageView.kf.setImage(with: model?.bigImg.resource, placeholder: UIImage(named: "temp"), options: [.transition(.fade(0.5))])
        
        let imgH = imageView.image?.size.height ?? 1
        let imgW = imageView.image?.size.width ?? 1
        let newH = imgH / imgW * KScreenWidth
        imageView.frame = CGRect(x: 0, y: 80, width: KScreenWidth, height: newH)
        
        

        
        
    
        
        let content = model.content ?? ""
        let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: content)
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, (content.count)))
        attributedString.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.9685223699, green: 0.9686879516, blue: 0.9685119987, alpha: 1), range: NSMakeRange(0, (content.count)))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSMakeRange(0, (content.count)))
//        attributedString.addAttribute(.kern, value: 2, range: NSMakeRange(0, (content.count)))
        contentTF.attributedText = attributedString
        
        let y:CGFloat = KScreenWidth + 20
        contentTF.frame = CGRect(x: 12, y: imageView.maxY + 20, width: KScreenWidth - 24, height: KScreenHeight - y)
        
    }
    
    
    
    @objc func handleBackGes(gr: UIScreenEdgePanGestureRecognizer) {
        if endHeroAnim {return}
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            var progress = gr.translation(in: nil).x / view.bounds.width
            progress = progress < 0 ? 0: progress;
//            print(progress)
//            if progress > 0.2{
            if progress > 0.16{
                Hero.shared.finish()
                endHeroAnim = true;
            }else{
                Hero.shared.update(progress/3)
            }
        default:
            if (gr.translation(in: nil).x + gr.velocity(in: nil).x) / view.bounds.width > 0.5 {
                Hero.shared.finish()
                endHeroAnim = true;
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
    

}


