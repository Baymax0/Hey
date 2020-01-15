//
//  CardView.swift
//  Lee
//
//  Created by yimi on 2019/11/19.
//  Copyright © 2019 baymax. All rights reserved.
//

import Foundation
import Hero
import CollectionKit
import Kingfisher
import LTMorphingLabel

class CardView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView()
    let locImg = UIImageView()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    let topView = UIView()
    let timeLab = LTMorphingLabel()
    let tagLab = LTMorphingLabel()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        self.cornerRadius = 6
        self.backgroundColor = .clear
        
        visualEffectView.alpha = 0.35
        
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 6
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = .KBlueDark
        
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        subtitleLabel.textAlignment = .right
        subtitleLabel.textColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)
        
        locImg.contentMode = .scaleAspectFit
        locImg.image = #imageLiteral(resourceName: "location").withRenderingMode(.alwaysTemplate)
        locImg.tintColor = #colorLiteral(red: 0.685315609, green: 0.7131230235, blue: 0.754701674, alpha: 1)
        
        topView.backgroundColor = .clear
        
        
        timeLab.font = UIFont(name: "Futura-Medium", size: 13)
        timeLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topView.addSubview(timeLab)
        
        tagLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tagLab.textAlignment = .center
        tagLab.font = UIFont.boldSystemFont(ofSize: 12)
        tagLab.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tagLab.layer.borderWidth = 1
        tagLab.layer.cornerRadius = 4
        
        topView.addSubview(tagLab)
        
        addSubview(visualEffectView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(locImg)
        addSubview(topView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    func updateFrame(){
        let h:CGFloat = w / 2
        visualEffectView.frame = bounds
        topView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 50)
        timeLab.frame = CGRect(x: 8, y: 0, width: 140, height:  22)
        let tagLabW = CGFloat(tagLab.text!.stringWidth(UIFont.boldSystemFont(ofSize: 12)) + 10)
        tagLab.frame = CGRect(x: bounds.width-8-tagLabW, y: 3, width: tagLabW, height:  16)
        
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: h)
        titleLabel.frame = CGRect(x: 0, y: h+6, width: bounds.width, height: 24)
        
        let subtitleLabelW = subtitleLabel.text!.stringWidth(UIFont.boldSystemFont(ofSize: 13))+5
        subtitleLabel.frame = CGRect(x: bounds.width-subtitleLabelW, y: titleLabel.y , width: subtitleLabelW, height: 24)
        locImg.frame = CGRect(x: subtitleLabel.x-20, y: subtitleLabel.y, width: 16, height: 24)
    }
    
    static var viewW:CGFloat = KScreenWidth - 50
    
    static var viewBlank:CGFloat = 15
    
    static var viewH:CGFloat = {
        // 图片比例2:1
        var h:CGFloat = (CardView.viewW - CardView.viewBlank) / 2
        h = h + 6 + 24
        h = h + 15
        return h
    }()
    
}

class RoundedCardWrapperView: UIView {
    let cardView = CardView()
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if cardView.superview == self {
            cardView.frame = CGRect(x: 0, y: 0, width: bounds.width-CardView.viewBlank, height: bounds.height)
        }
    }
}


