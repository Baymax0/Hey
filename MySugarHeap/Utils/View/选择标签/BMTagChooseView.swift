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
    
    var selArr : Array<BMTag>?

    lazy var bgView:UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        return view
    }()
    lazy var contenView:UIView = {
        let h = CGFloat(200)
        let view = UIView(frame: CGRect(x: 10,y:KScreenHeight-h,width: KScreenWidth-20, height:h))
        view.layer.cornerRadius = 13
        view.layer.masksToBounds = true
        view.backgroundColor = .white

//        view.alpha = 0.9

//        let line = UIView(frame: CGRect(x: 15, y: 44, width: view.w-30, height: 0.5))
//        line.backgroundColor = KBGGrayLine
//        view.addSubview(line)
        
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        visualEffectView.frame = view.bounds
//        view.addSubview(visualEffectView)
        
        let head = UIView(frame: CGRect(x: 0, y: 0, width: view.w, height: 44))
        head.backgroundColor = KRed//.withAlphaComponent(0.1)
        view.addSubview(head)
        let lab = UILabel(frame: CGRect(x: 15, y: 0, width: 250, height: 44))
        lab.text = "选择需要绑定的标签"
        lab.textColor = .white
        lab.font = UIFont.systemFont(ofSize: 15)
        head.addSubview(lab)
        
        let btn = UIButton(frame: CGRect(x: view.w-80, y: 0, width: 80, height: 44))
        btn.setTitle("完成", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(comfirm), for: .touchUpInside)
        view.addSubview(btn)
        return view
    }()
    
    var tagBgView:UIView = {
       let view = UIView(frame: CGRect(x: 0,y:44,width: 0, height:0))
        return view
    }()

    var selected : ((_:[BMTag]?)->())

    init(_ tag:BMTagType,selected:@escaping (_:[BMTag]?)->()){
        self.selected = selected
        tagsArr = Array<BMTag>()
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contenView.addSubview(tagBgView)
        loadData(tag)
    }

    required init?(coder aDecoder: NSCoder) {   fatalError("init(coder:) has not been implemented") }

    func show(){
        let w = UIApplication.shared.keyWindow
        bgView.alpha = 0
        contenView.frame.origin.y = KScreenHeight
        w?.addSubview(bgView)
        w?.addSubview(contenView)
        UIView.animate(withDuration: 0.25) {
            self.bgView.alpha = 1
            self.contenView.frame.origin.y = KScreenHeight - self.contenView.frame.height-34
        }
    }

    func loadData(_ tag:BMTagType){
        let _ = tagBgView.subviews.map { $0.removeFromSuperview()}
        tagsArr = BMCache.getImageTags()
        let blank:CGFloat   = 15
        let h   :CGFloat    = 32
        var row :CGFloat    = 0
        var x   :CGFloat    = 0
        let fontSize:CGFloat = 14
        var maxY:CGFloat = 0
        for i in 0..<tagsArr.count{
            let tag = tagsArr[i]
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
            let btn = UIButton.init(frame: CGRect(x: x, y: row*(h+blank) + 8, width: w, height: h))
            x = x + w
            btn.backgroundColor = KRGB(235, 235, 235)
            btn.setTitle(tag.tagName, for: .normal)
            btn.tag = i
            btn.setTitleColor(KBlack_87, for: .normal)
            btn.backgroundColor = .clear
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.addTarget(self, action: #selector(choose), for: .touchUpInside)

            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 6
            btn.layer.masksToBounds = true
            btn.setTitleColor(KBlack_153, for: .normal)
            btn.setTitleColor(KRed, for: .selected)

            maxY = btn.maxY
            
            changeBtnStyle(btn)
            tagBgView.addSubview(btn)
        }
        //修改视图大小
        maxY = maxY + h*2
        tagBgView.frame = CGRect(x: 0, y: 44, width: contenView.w, height: maxY)
        contenView.h = tagBgView.maxY
    }
    
    @objc func comfirm() -> Void{
        selArr = Array<BMTag>()
        let _ = tagBgView.subviews.map { [weak self] v -> Void in
            let btn = v as! UIButton
            if btn.isSelected{
                self?.selArr?.append(tagsArr[btn.tag])
            }
            return
        }
        close()
    }

    @objc func choose(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        changeBtnStyle(btn)
    }

    func changeBtnStyle(_ btn:UIButton) {
        if btn.isSelected {
            btn.layer.borderColor = KRed.cgColor
        }else{
            btn.layer.borderColor = KBlack_153.cgColor
        }
    }

    @objc func close() -> Void{
        selected(selArr)
        
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
