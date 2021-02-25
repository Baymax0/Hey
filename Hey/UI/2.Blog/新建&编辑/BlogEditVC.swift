//
//  BlogEditVC.swift
//  Hey
//
//  Created by 李志伟 on 2021/1/19.
//  Copyright © 2021 baymax. All rights reserved.
//

import UIKit

class BlogEditVC: BaseVC {
    
    var model: GitHub_CachePost!
    
    var picker:BMDatePicker!

    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var naviContent: UIView!
    @IBOutlet weak var naviViewTop: NSLayoutConstraint!

    @IBOutlet weak var contentView: UIStackView!

    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var scBottom: NSLayoutConstraint!
    
    @IBOutlet var keyboardToolView: UIScrollView!
    
//    @IBOutlet weak var editBtn: UIButton!
    
    var showTitleView:Bool = false
    
    // content
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var titleLabTF: UITextView!
    
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var subTitleLabTF: UITextView!
    
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var tagBG: UIView!
    @IBOutlet weak var tagBGH: NSLayoutConstraint!
    
    @IBOutlet weak var titleImgView: UIImageView!
    var collection:CollectionView!
    var dataSource:ArrayDataSource<String>!
    var allPostTags:Array<String> = []
    var chooseDic:Dictionary<String,Bool> = [:]

    
    //H1选择
    @IBOutlet var h1ChooseBG: UIView!
    @IBOutlet weak var h1ChooseContentY: NSLayoutConstraint!
    @IBOutlet weak var h1Btn: UIButton!
    @IBOutlet weak var h2Btn: UIButton!
    @IBOutlet weak var h3Btn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        sc.contentInsetAdjustmentBehavior = .never
        sc.delegate = self
        
        self.initUI()
        
        if self.model.sha != nil{
            self.loadModel()
        }
        self.reloadContent()
        
        self.autoHideKeyboard = false
        
        noti.addObserver(self, selector: #selector(keyboardWillChangeFrame(noti:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
        noti.addObserver(self, selector: #selector(handelCellNoti(noti:)), name: .daily_Cell_Action, object: nil)
    }
    
    func initUI() {
        keyboardToolView.frame = CGRect(x: 0, y: KScreenHeight, width: KScreenWidth, height: 40)
        self.view.addSubview(keyboardToolView)
        
        h1Btn.titleLabel?.font = MarkdownLineStyle.h1.font
        h1Btn.tintColor = MarkdownLineStyle.h1.textTineColor
        
        h2Btn.titleLabel?.font = MarkdownLineStyle.h2.font
        h2Btn.tintColor = MarkdownLineStyle.h2.textTineColor
        
        h3Btn.titleLabel?.font = MarkdownLineStyle.h5.font
        h3Btn.tintColor = MarkdownLineStyle.h5.textTineColor
        
        h1ChooseBG.alpha = 0
        h1ChooseBG.frame = self.view.bounds
        
        titleLabTF.delegate = self
        titleLabTF.textContainerInset = .zero
        titleLabTF.font = titleLab.font
        
        subTitleLabTF.delegate = self
        subTitleLabTF.textContainerInset = .zero
        subTitleLabTF.font = subTitleLab.font
        
    }
    
    func loadModel() {
        self.titleLab.text = model.title
        self.titleLabTF.text = model.title
        self.subTitleLab.text = model.subtitle
        self.subTitleLabTF.text = model.subtitle
        self.dateLab.text = model.date.toString("yyyy-MM-dd")
        var url = model.header_img ?? ""
        if !url.contains("http"){
            url = "https://\(cache[.myGithubToken]!).github.io/"+url
        }
        titleImgView.kf.setImage(with: url.resource, placeholder: UIImage.name("post-default-img"), options: [.transition(.fade(0.5))])
        
        // tags 单选框
        if collection == nil{
            collection = CollectionView(frame: .init(x: 0, y: 0, width: KScreenWidth-24, height: 24))
            tagBG.addSubview(collection)
        }
        
        // 拿到所有tag
        let temp = cache[.allPostTags] ?? []
        for tag in temp{
            if tag.count != 0{
                allPostTags.append(tag)
                if model.tags.contains(tag){
                    chooseDic[tag] = true
                }else{
                    chooseDic[tag] = false
                }
            }
        }
        
        dataSource = ArrayDataSource(data: allPostTags)
        dataSource.data.append("")
        // cell内容
        let viewSource = ClosureViewSource(viewUpdater: { (view: UIView, data: String, index: Int) in
            let nameLab:UILabel = (view.viewWithTag(113) as? UILabel) ?? UILabel()
            nameLab.tag = 113
            nameLab.textAlignment = .center
            nameLab.font = .boldSystemFont(ofSize: 11)
            view.addSubview(nameLab)
            nameLab.bm.addConstraints([.fill])
            nameLab.text = "\(data)"
            nameLab.textColor = .white
            if data.count == 0{
                nameLab.text = "添加+"
                nameLab.font = .boldSystemFont(ofSize: 12)
            }else{
                view.layer.cornerRadius = 11
                view.layer.masksToBounds = true

                if self.chooseDic[data] == true{
                    self.selectView(view, true)
                }else{
                    self.selectView(view, false)
                }
            }
        })
        // cell尺寸
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            let str = data.count == 0 ? "添加+" : data
            return CGSize(width: str.stringWidth(14) + 20, height: 22)
        }
        let provider = BasicProvider(dataSource: dataSource, viewSource: viewSource, sizeSource: sizeSource, tapHandler: { [weak self] context in
            if context.data.count == 0{//新建
                
            }else{
                if self?.chooseDic[context.data] == true{//取消选中
                    self?.selectView(context.view, false)
                    self?.chooseDic[context.data] = false
                }else{//选中
                    self?.selectView(context.view, true)
                    self?.chooseDic[context.data] = true
                }
            }
        })
        // 布局
        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        collection.provider = provider
        collection.reloadData()
        collection.h = collection.contentSize.height
        tagBGH.constant = collection.contentSize.height + 5
    }
    
    func selectView(_ v:UIView, _ select:Bool){
        if select == true {//选中
            let color = #colorLiteral(red: 0.1610877216, green: 0.4596017003, blue: 0.6591704488, alpha: 1)
            v.layer.borderWidth = 0
            v.backgroundColor = color
        }else{//quxiao选中
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.white.alpha(0.7).cgColor
            v.backgroundColor = UIColor.gray.alpha(0.5)
        }
    }

    func reloadContent(){
        // 内容转成数组
        var data:Array<SwiftyLine> = []
        if self.model.sha != nil{
            let lines : [SwiftyLine] = SwiftyMarkdown.getlines(model.body ?? "")
            for l in lines{
                data.append(l)
            }
            data.append(SwiftyLine(.body, ""))//末尾增加一个空白的输入框
        }else{
            model = GitHub_CachePost()
            let m1 = SwiftyLine(.h1,"Hello")
            let m2 = SwiftyLine(.body, "")
            data = [m1,m2];
        }
        // 数组 转成 cell
        for model in data{
            let cell = DetailContentCell.create(model)
            contentView.insertArrangedSubview(cell, at: contentView.arrangedSubviews.count-1)
        }
    }

    @objc fileprivate func keyboardWillChangeFrame(noti : Notification){
        let duringNumber = noti.userInfo![UIView.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let d = duringNumber?.floatValue ?? 0
        
        let frameValue = noti.userInfo![UIView.keyboardFrameEndUserInfoKey] as? NSValue
        let f = frameValue?.cgRectValue
        
        let y = f?.origin.y ?? KScreenHeight
        var rect = self.keyboardToolView.frame
        if y < KScreenHeight{//打开键盘
            rect.origin.y = y - rect.height
        }else{//收起键盘
            rect.origin.y = KScreenHeight
            closeH1ChooseViewAction(nil)
        }
        
        let bottom = max(KScreenHeight - rect.origin.y - safeArea.bottom - 44 , 0)
        UIView.animate(withDuration: TimeInterval(d)) {
            self.keyboardToolView.frame = rect
            self.scBottom.constant = bottom;
//            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    @IBAction func changeTimeAction(_ sender: Any) {
        picker = BMPicker.datePicker { (date) in
            self.dateLab.text = date!.toString("yyyy-MM-dd")
        }
        picker.show()
    }
    
    // 处理键盘事件
    @objc func handelCellNoti(noti : Notification){
        let nowCell = DetailContentCell.chooseCell!;
        // 定位
        let i = self.getCurrentIndex()
                    
        if let action = noti.object as? DailyCellAction{
            switch action {
                case .delete:
                    //把当前tv的字追加到上一个tv末尾
                    guard i != 0 else { return }
                    print("第\(i) 个 cell：删除到第\(i-1)个")
                    
                    let str = nowCell.contentTF.text ?? "";
                    
                    print(str)
                    
                    if let frontCell = self.contentView.arrangedSubviews[i-1] as? DetailContentCell{
                        // 如果上一行是line，则删除上一行
                        if frontCell.model.lineStyle == .line{
                            self.contentView.removeArrangedSubview(frontCell)
                            return
                        }else{
                            let loc = frontCell.model.line.count
                            frontCell.model.line = "\(frontCell.model.line)\(str)" //把当前cell的内容拼在前一个末尾
                            frontCell.reloadModel()
                            frontCell.contentTF.becomeFirstResponder()
                            frontCell.contentTF.selectedRange = NSRange(location: loc, length: 0)//光标移动道之前位置
                        }
                    }
                    self.contentView.removeArrangedSubview(nowCell)
                    nowCell.removeFromSuperview()
                
                case .new(let str):
                    print("第\(i) 个cell：回车操作")
                    print("\(i):\(str.first)")
                    print("\(i+1):\(str.second)")
                    
                    nowCell.model.line = str.first
                    nowCell.reloadModel()
                
                    let model = SwiftyLine(.body, str.second)

                    let newCell = DetailContentCell.create(model)
                    self.contentView.insertArrangedSubview(newCell, at: i+1)
                    newCell.contentTF.becomeFirstResponder()
                    newCell.contentTF.selectedRange = NSRange(location: 0, length: 0)
            }
        }
    }
    
    @IBAction func headSizeChooseAction(_ sender: UIButton) {
        if let cell = DetailContentCell.chooseCell {
            if sender.tag == 0{
                cell.model.lineStyle = .h1
                cell.reloadModel()
            }else if sender.tag == 1{
                cell.model.lineStyle = .h2
                cell.reloadModel()
            }else if sender.tag == 2{
                cell.model.lineStyle = .h5
                cell.reloadModel()
            }
            self.closeH1ChooseViewAction(nil)
        }
    }
    
    @IBAction func closeH1ChooseViewAction(_ sender: UIButton!){
        UIView.animate(withDuration: 0.1) {
            self.h1ChooseBG.alpha = 0
        } completion: { (_) in
            self.h1ChooseBG.removeFromSuperview()
        }
    }
    
    /// 键盘工具栏
    @IBAction func keyboardAction(_ sender: UIButton) {
        if let cell = DetailContentCell.chooseCell {
            let range = cell.contentTF.selectedRange
            if sender.tag == 0{
                h1ChooseContentY.constant = keyboardToolView.y
                view.addSubview(h1ChooseBG)
                h1ChooseBG.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.h1ChooseBG.alpha = 1
                }
            }
            
            //body
            if sender.tag == 1{
                cell.model.lineStyle = .body
                cell.model.line = removeBlank(cell.model.line)
                cell.reloadModel()
//                cell.contentTF.selectedRange = range
            }
            //换行+加横线
            if sender.tag == 2{
                let s1 = cell.contentTF.attributedText.string[..<range.location] ?? ""
                let s2 = cell.contentTF.attributedText.string[range.location...] ?? ""
                
                let nowCell = DetailContentCell.chooseCell!;
                let i = self.getCurrentIndex()// 定位
                
                if range.location == 0{
                    //  插入横线
                    let model = SwiftyLine(.line, "")
                    let newCell = DetailContentCell.create(model)
                    self.contentView.insertArrangedSubview(newCell, at: i)
                }else{
                    nowCell.model.line = s1
                    nowCell.reloadModel()
                    //  插入横线
                    let model = SwiftyLine(.line, "")
                    let newCell = DetailContentCell.create(model)
                    self.contentView.insertArrangedSubview(newCell, at: i+1)

                    let model2 = SwiftyLine(.body, s2)
                    let newCell2 = DetailContentCell.create(model2)
                    self.contentView.insertArrangedSubview(newCell2, at: i+2)
                    newCell2.contentTF.becomeFirstResponder()
                    newCell2.contentTF.selectedRange = NSRange(location: 0, length: 0)
                }
            }
            
            if sender.tag == 3{
                cell.model.lineStyle = .point
                cell.model.line = removeBlank(cell.model.line)
                cell.reloadModel()
            }
            
            if sender.tag == 4{
                
            }
            
            if sender.tag == 5{
                
            }
            
            if sender.tag == 6{
                let s1 = cell.contentTF.attributedText.string[..<range.location] ?? ""
                let s2 = cell.contentTF.attributedText.string[range.location...] ?? ""
                
                let nowCell = DetailContentCell.chooseCell!;
                let i = self.getCurrentIndex()// 定位
                
                nowCell.model.line = s1
                nowCell.reloadModel()
                
                //  插入回车
                let model = SwiftyLine(.body, s2)
                let newCell = DetailContentCell.create(model)
                self.contentView.insertArrangedSubview(newCell, at: i+1)
                newCell.contentTF.selectedRange = NSRange(location: 0, length: 0)
            }
        }
    }
    
    func removeBlank(_ s:String ) -> String {
        let newS = s.trimmingCharacters(in: CharacterSet.whitespaces)
        return newS
    }
    
    /// 根据 index 获得 cell
    func getCell(index:Int) -> DetailContentCell?{
        if index < 0 || index >= self.contentView.arrangedSubviews.count  {
            return nil
        }
        if let cell = self.contentView.arrangedSubviews[index] as? DetailContentCell{
            return cell
        }
        return nil
    }
    
    /// 根据cell 获得index
    func getCurrentIndex() -> Int{
        // 定位
        var i = 0
        for (index,item) in self.contentView.arrangedSubviews.enumerated(){
            let v = item as? DetailContentCell
            if v?.model.id == DetailContentCell.chooseCell?.model.id{
                i = index
                break
            }
        }
        return i
    }
    
    @IBAction func blankClickAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveAvtion(_ sender: Any) {
        Hud.showWait()
        
        var m = GitHub_CachePost()
        m.title = titleLabTF.text
        m.subtitle = subTitleLabTF.text
        if model.name != nil{
            m.name = model.name
            m.sha = model.sha
            let dateStr = String(format: "%@ 12:00:00", dateLab.text!)
            m.date = dateStr.toDate()
            m.author = cache[.myGithubName] ?? ""
            m.header_img = "img/post-bg-13.jpg"
            m.tags = ""
            for (key,value) in chooseDic{
                if value == true{
                    m.tags.append((m.tags.count != 0) ? "," : "")
                    m.tags.append(key)
                }
            }
            m.body = ""
            for cell in contentView.arrangedSubviews{
                if let detailCell = cell as? DetailContentCell{
                    m.body.append(detailCell.getString())
                }
            }
            print(m.body)
        }else{
            
        }
//        let p = GitHub_CachePost()
//        p.name = "333.markdown"
//        Github.savePost(p) { (resp) in
//            Hud.hide()
//            if resp?.code == 1{
//                Hud.showText("提交成功")
//            }else{
//                Hud.showText(resp?.msg)
//            }
//        }
        
    }
    
}


extension BlogEditVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y > KScreenWidth * 0.85-70{
            if showTitleView == false{
                showTitleView = true// 显示头部编辑信息
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
                    self.naviView.viewWithTag(-1)?.alpha = 1
                } completion: { (_) in}
            }
        }else{
            if showTitleView == true{
                showTitleView = false// 隐藏头部编辑信息
                UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseInOut) {
                    self.naviView.viewWithTag(-1)?.alpha = 0
                } completion: { (_) in}
            }
        }
    }
}


extension BlogEditVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1{
            titleLab.text = titleLabTF.text
        }
        if textView.tag == 2{
            subTitleLab.text = titleLabTF.text
        }
    }
}
