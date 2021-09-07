//
//  DetailContentCell.swift
//  Hey
//
//  Created by 李志伟 on 2020/4/27.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

enum DailyCellAction{
    /// 删除
    case delete
    /// 回车后新建
    case new((first:String,second:String))
}


class DetailContentCell: UIView {
    
    //当前输入法选中的cell
    static weak var chooseCell:DetailContentCell?
    
    var model:SwiftyLine!
    
    @IBOutlet weak var leftView: UIView!
    var leading:CGFloat = 40
    
    var contentTFEdge = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
    @IBOutlet weak var contentTF: MyTextField!
    
    static func create(_ model:SwiftyLine? = nil) -> DetailContentCell{
        let nib = Bundle.main.loadNibNamed("DetailContentCell", owner: nil, options: nil)
        if let view = nib?.first as? DetailContentCell{
            view.model = model ?? SwiftyLine(.body,"")
            view.intiUI()
            view.reloadModel()
            return view
        }
        return DetailContentCell()
    }

    /// 初始化基础配置
    fileprivate func intiUI() {
        self.contentTF.textContainer.lineFragmentPadding = .zero
        self.contentTF.delegate = self
        self.backgroundColor = .clear
        self.initCustomItemMenu()
    }
    
    /// 刷新cell
    func reloadModel(){
        contentTFEdge = self.contentTF.textContainerInset
        if model.lineStyle == .line{//横线
            contentTFEdge.top = 5
            contentTFEdge.bottom = 5
            contentTF.text = ""
            contentTF.alpha = 0;
            let line = UIView()
            line.backgroundColor = model.lineStyle.textTineColor
            self.addSubview(line)
            line.bm.addConstraints([.center, .h(2), .w(KScreenWidth-40-40)])
        }else if model.lineStyle == .image{//图片

        }else{//文本内容
            if  model.lineStyle == .h1 {
                contentTFEdge.top = 15
                contentTFEdge.bottom = 5
            }else if  model.lineStyle == .h2 || model.lineStyle == .h3 || model.lineStyle == .h4{
                contentTFEdge.top = 15
                contentTFEdge.bottom = 5
            }else if  model.lineStyle == .h5{
                contentTFEdge.top = 15
                contentTFEdge.bottom = 5
            }
            else if model.lineStyle == .point{
                contentTFEdge.top = 10
                contentTFEdge.bottom = 7
            }
            else if model.lineStyle == .body {
                contentTFEdge.top = 7
                contentTFEdge.bottom = 12
            }
            else if model.lineStyle == .blockquote {
                contentTFEdge.top = 15
                contentTFEdge.bottom = 15
            }
            resetTextStyle()//文字样式
            resetLeftUI()//左侧图标
        }
        self.contentTF.textContainerInset = contentTFEdge
        caculateNewHeight()
    }
    
    // 左侧图案
    func resetLeftUI(){
        let style = model.lineStyle
        // 隐藏其他view
        for v in leftView.subviews{
            if v.tag == model.lineStyle.tag{
                v.alpha = 1
            }else{
                v.alpha = 0
            }
        }
        if style == .body || style == .line  || style == .image {
            return
        }
        
        //引言
        if model.lineStyle == .blockquote{
            var v = leftView.viewWithTag(model.lineStyle.tag)
            if v == nil{
                v = UIView()
                v!.tag = model.lineStyle.tag
                v?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                leftView.addSubview(v!)
                v?.bm.addConstraints([.right(10), .top(8), .bottom(8), .w(3)])
            }
            v?.alpha = 1
        }
        
        // 大标题
        if style == .h1 || style == .h2 || style == .h3 || style == .h4 || style == .h5 || style == .point {
            var v = leftView.viewWithTag(model.lineStyle.tag) as? UIImageView
            if v == nil{
                v = UIImageView()
                v!.tag = model.lineStyle.tag
                v?.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                leftView.addSubview(v!)
                v?.contentMode = .scaleAspectFit
            }
            v?.frame = CGRect.init(x: 11, y: 14, width: 18, height: 18)
            if style == .h1{
                v?.y = 21
                v?.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                v?.image = UIImage.name("h1") }
            if style == .h2 || style == .h3 || style == .h4{
                v?.y = 19
                v?.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                v?.image = UIImage.name("h2") }
            if style == .h5{
                v?.y = 18
                v?.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                v?.image = UIImage.name("h3") }
            if style == .point{
                v?.y = 10
                v?.tintColor = #colorLiteral(red: 0.8761270642, green: 0.2939250767, blue: 0.348059535, alpha: 1)
                v?.image = UIImage.name("point") }
        }
        
    }
    
    func getString() -> String {
        var result = ""
        self.contentTF.resignFirstResponder()
        result.append("\n")
        result.append(self.model.lineStyle.prefix)
        
        var text = self.contentTF.text ?? ""
        if self.model.lineStyle.breakNextLine == false{
            text = text.replacingOccurrences(of: "\n", with: "    \n")
        }
        
        switch self.model.lineStyle{
            case .h1, .h2, .h3, .h4, .h5:
                result.append(text)
            case .blockquote:
                result.append("\n")
                result.append(text)
                result.append("\n")
            case .point:
                result.append(text)
            case .line:
                result.append("")
            case .body:
                result.append(text)
                result.append("\n")
            case .image:
                result.append("")
                result.append("\n")
            case .blank:
                result.append("")
        }
        return result
    }
    
    // 获得textview样式
    func resetTextStyle(){
        var attributes: [NSAttributedString.Key : Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        attributes[.foregroundColor] = self.model.lineStyle.textTineColor
        attributes[.font] = self.model.lineStyle.font

        attributes[.paragraphStyle] = paragraphStyle
        let att = NSAttributedString(string: model!.line, attributes: attributes)
        contentTF.attributedText = att
    }
    
    func caculateNewHeight(){
        var height:CGFloat = 0
        if self.model.lineStyle == .line{
            height = 1
        }else{
            let size = contentTF.sizeThatFits(.init(width: KScreenWidth-leading*2, height: 5000))
            height = size.height
        }
        self.frame.size.height = height + contentTFEdge.top + contentTFEdge.bottom;
    }
    
    
    func initCustomItemMenu(){
        let menu = UIMenuController.shared
        let item1 = UIMenuItem(title: "拷", action: #selector(menuItemAction1(_:)))
        let item2 = UIMenuItem(title: "贴", action: #selector(menuItemAction2(_:)))
        let item3 = UIMenuItem(title: "All", action: #selector(menuItemAction3(_:)))
        let item4 = UIMenuItem(title: "🕰️", action: #selector(menuItemAction4(_:)))
        menu.menuItems = [item1,item2,item3,item4]
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action ==  #selector(menuItemAction1(_:)) { return true; }
        if action ==  #selector(menuItemAction2(_:)) { return true; }
        if action ==  #selector(menuItemAction3(_:)) { return true; }
        if action ==  #selector(menuItemAction4(_:)) { return true; }
        return false;
    }
    
    @objc func menuItemAction1(_ mc:UIMenuController) {
        self.contentTF.copy(nil)
    }
    
    @objc func menuItemAction2(_ mc:UIMenuController) {
        if self.contentTF.isEditable{
            self.contentTF.paste(nil)
        }
    }
    
    @objc func menuItemAction3(_ mc:UIMenuController) {
        self.contentTF.selectAll(nil)
    }
    
    @objc func menuItemAction4(_ mc:UIMenuController) {
        let t = Date().toString("HH:mm")
        UIPasteboard.general.string = t
        self.contentTF.paste(nil)
    }
    
}

extension DetailContentCell: UITextViewDelegate{
    
    // 此方法发送通知时 还未返回 所以如果外部切换了 cell 会影响外部使用 DetailContentCell.chooseCell
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.attributedText.string
        newText.replaceSubrange(newText.range(from: range)!, with: text)
        
        //行首输入 删除 触发 删除cell
        if (range.location + range.length) == 0 && text.count == 0{
            print("delete cell")
            noti.post(name: .daily_Cell_Action, object: DailyCellAction.delete, userInfo: nil)
            return false
        }
        // 输入回车 创建新的cell
        if text == "\n"{
            if self.model.lineStyle == .body || self.model.lineStyle == .point || self.model.lineStyle == .blockquote{
                return true
            }else{
                let s1 = textView.attributedText.string[..<range.location] ?? ""
                let s2 = textView.attributedText.string[range.location...] ?? ""
                noti.post(name: .daily_Cell_Action, object: DailyCellAction.new((first: s1, second: s2)), userInfo: nil)
                return false                
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        caculateNewHeight()
        // 刚创建的cell 样式没设置上 手动再设置一次
        if self.model.line.count == 0{
            self.model.line = textView.attributedText.string
            self.resetTextStyle()
        }else{
            self.model.line = textView.attributedText.string
        }
    }
    //获得当前正在输入编辑的Cell
    func textViewDidBeginEditing(_ textView: UITextView) {
        DetailContentCell.chooseCell = self;
    }
    
    
}
