//
//  BMTagChooseView.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/24.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

enum BMTagType:String {
    case ImgTag
    case ArticleTag
}

class BMTagChooseView: UIView {

    var tagsArr : Array<BMTag>

    var bgView:UIButton{
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        return view
    }
    var contenView:UIView{
        let h = CGFloat(200)
        let view = UIView(frame: CGRect(x: 0,y:KScreenHeight-h,width: KScreenWidth, height:h))
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0.8
        view.addSubview(visualEffectView)
        view.tag = 1001
        view.backgroundColor = .clear
        return view
    }

    var selected : ((_:[BMTag]?)->())

    init(_ tag:BMTagType,selected:@escaping (_:[BMTag]?)->()){
        self.selected = selected
        tagsArr = Array<BMTag>()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        loadData(tag)
    }

    required init?(coder aDecoder: NSCoder) {   fatalError("init(coder:) has not been implemented") }

    func show(){
        let w = UIApplication.shared.keyWindow
        bgView.alpha = 0
        contenView.frame.origin.y = KScreenHeight
        w?.addSubview(self)
        w?.addSubview(bgView)
        w?.addSubview(contenView)
        UIView.animate(withDuration: 0.25) {
            self.bgView.alpha = 1
            self.contenView.frame.origin.y = KScreenHeight - self.contenView.frame.height
        }
    }

    func loadData(_ tag:BMTagType){
        let v = contenView.viewWithTag(1001)
        let _ = contenView.subviews.map { $0.removeFromSuperview()}
        contenView.addSubview(v!)

        tagsArr = BMCache.getImageTags()
        let blank:CGFloat   = 15
        let h   :CGFloat    = 35
        var row :CGFloat    = 0
        var x   :CGFloat    = 0
        let fontSize:CGFloat = 14
        for tag in tagsArr{
            var w = tag.tagName.stringWidth(fontSize)+30
            w = w < (KScreenWidth-blank*2) ? w : KScreenWidth-blank*2-1

            if x + blank + w + blank > KScreenWidth{
                x = 0
                row = row + 1
                if row > 5{
                    return
                }
            }
            x = x + blank
            let btn = UIButton.init(frame: CGRect(x: x, y: row*(h+blank), width: w, height: h))
            x = x + w
            btn.backgroundColor = KRGB(235, 235, 235)
            btn.layer.cornerRadius = 3
            btn.layer.masksToBounds = YES
            btn.setTitle(tag.tagName, for: .normal)
            btn.setTitleColor(KTextBlack, for: .normal)
            btn.backgroundColor = .white
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.addTarget(self, action: #selector(choose(_:)), for: .touchUpInside)

            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 3
            btn.layer.masksToBounds = true
            btn.setTitleColor(KRed, for: .normal)
            btn.setTitleColor(KTextGray, for: .selected)

            changeBtnStyle(btn)
            contenView.addSubview(btn)
        }
    }

    @objc func choose(_ btn:UIButton){
        btn.isSelected = btn.isSelected
        changeBtnStyle(btn)
    }

    func changeBtnStyle(_ btn:UIButton) {
        if btn.isSelected {
            btn.layer.borderColor = KTextGray.cgColor
        }else{
            btn.layer.borderColor = KTextGray.cgColor
        }
    }

    @objc func close(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0
            self.contenView.frame.origin.y = KScreenHeight
        }) { (_) in
            self.bgView.removeFromSuperview()
            self.contenView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

}
