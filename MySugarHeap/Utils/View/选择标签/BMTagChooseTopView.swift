//
//  BMTagChooseTopView.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/27.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class BMTagChooseTopView: UIView {

    var tagsArr : Array<BMTag>

    var isShow = false

    var type:BMTagType!
    
    var bgView:UIButton = {
        let view = UIButton(frame: CGRect.zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        return view
    }()

    var contenView:UIView = {
        let view = UIView(frame: CGRect(x: 0,y:0,width: KScreenWidth, height:100))
        view.backgroundColor = KBGGray_250

        let lab1 = UILabel(frame: CGRect(x: 12, y: 5, width: 80, height: 35))
        lab1.text = "默认分组"
        lab1.font = UIFont.systemFont(ofSize: 13)
        lab1.textColor = KBlack_153
        view.addSubview(lab1)

        let btn = BMTagChooseTopView.createTagBtn(AllItemTag)
        btn.frame = CGRect(x: 12, y: 40, width: AllItemTag.tagName.stringWidth(14) + 30, height: 35)
        btn.tag = -1001
        view.addSubview(btn)

        let lab2 = UILabel(frame: CGRect(x: 12, y: 80, width: 80, height: 35))
        lab2.text = "我的分组"
        lab2.font = UIFont.systemFont(ofSize: 13)
        lab2.textColor = KBlack_153
        view.addSubview(lab2)
        return view
    }()

    var tagBtnBGView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 120, width: KScreenWidth, height: 0))
        return view
    }()

    var finish : ((_:BMTag)->())

    var selectedTag:BMTag?

    init(rect:CGRect, _ tag:BMTagType,finish:@escaping (_:BMTag)->()){
        self.finish = finish
        type = tag
        tagsArr = Array<BMTag>()
        super.init(frame: rect)
        let btn = contenView.viewWithTag(-1001) as! UIButton
        btn.addTarget(self, action: #selector(choose), for: .touchUpInside)


        bgView.frame = self.bounds
        self.addSubview(bgView)
        self.addSubview(contenView)
        self.clipsToBounds = true

        contenView.addSubview(tagBtnBGView)
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    func loadData(_ tag:BMTagType){
        tagsArr = BMCache.getImageTags()
        let blank:CGFloat   = 15
        let h   :CGFloat    = 35
        var row :CGFloat    = 0
        var x   :CGFloat    = 0
        var maxY:CGFloat = 0
        for i in 0..<tagsArr.count{
            let tag = tagsArr[i]
            var w = tag.tagName.stringWidth(14)+30
            w = w < (KScreenWidth-blank*2) ? w : KScreenWidth-blank*2-1
            if x + blank + w + blank > KScreenWidth{
                x = 0
                row = row + 1
            }
            x += blank
            let btn = BMTagChooseTopView.createTagBtn(tag)
            btn.frame = CGRect(x: x, y: row*(h+blank), width: w, height: h)
            btn.addTarget(self, action: #selector(choose), for: .touchUpInside)
            btn.tag = i
            if self.selectedTag! == tag{
                btn.isSelected = true
            }
            tagBtnBGView.addSubview(btn)
            x += w
            maxY = btn.frame.maxY
        }
        maxY += 20
        tagBtnBGView.frame.size.height = maxY
        contenView.frame.size.height = 120 + maxY

    }

    class func createTagBtn(_ tag:BMTag) -> UIButton {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        btn.backgroundColor = KRGB(235, 235, 235)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true

        btn.setTitle(tag.tagName, for: .normal)
        btn.setTitleColor(KBlack_87, for: .normal)
        btn.setTitleColor(KOrange, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail

        return btn
    }

    func show(_ selectedTag:BMTag){
        if isShow {
            return
        }
        let btn = contenView.viewWithTag(-1001) as! UIButton

        self.selectedTag = selectedTag
        if selectedTag == AllItemTag {
            btn.isSelected = true
        }else{
            btn.isSelected = false
        }
        //刷新界面
        loadData(type)

        let w = UIApplication.shared.keyWindow
        bgView.alpha = 0
        self.contenView.frame.origin.y = -contenView.frame.size.height
        w?.addSubview(self)
        isShow = true
        UIView.animate(withDuration: 0.25) {
            self.bgView.alpha = 1
            self.contenView.frame.origin.y = 0
        }
    }

    @objc func close(){
        if !isShow {
            return
        }
        isShow = false
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0
            self.contenView.frame.origin.y = -self.contenView.frame.size.height
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    @objc func choose(_ btn :UIButton){
        if btn.tag == -1001{
            finish(AllItemTag)
        }else{
            finish(tagsArr[btn.tag])
        }
        close()
    }

}
