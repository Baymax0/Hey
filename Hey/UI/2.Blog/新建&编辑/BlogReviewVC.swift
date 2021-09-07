//
//  BlogReviewVC.swift
//  Hey
//
//  Created by 李志伟 on 2021/1/19.
//  Copyright © 2021 baymax. All rights reserved.
//

import UIKit

class BlogReviewVC: BaseVC {
    
    var model: GitHub_CachePost = GitHub_CachePost()

    @IBOutlet weak var naviView: UIView!
    @IBOutlet weak var naviContent: UIView!
    @IBOutlet weak var naviViewTop: NSLayoutConstraint!

    @IBOutlet weak var contentView: UIStackView!

    @IBOutlet weak var sc: UIScrollView!
    @IBOutlet weak var scBottom: NSLayoutConstraint!
    
//    @IBOutlet weak var editBtn: UIButton!
    var data:Array<SwiftyLine> = []

    var showTitleView:Bool = false
    

    // content
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var tagBG: UIView!
    @IBOutlet weak var titleImgView: UIImageView!
    var chooseTags:Array<String> = []
    var collection:CollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        sc.contentInsetAdjustmentBehavior = .never
        sc.delegate = self
                
        self.loadModel()
        self.reloadContent()
        
    }
    
    func findStr(_ content:String, pattern:String) -> String {
        if let rangeindex = content.range(of: pattern, options: .regularExpression, range: content.startIndex..<content.endIndex, locale: Locale.current){
            var result = String(content[rangeindex])
            result = result.trimmingCharacters(in: .whitespaces)
            return result
        }
        return ""
    }
    
    func loadModel() {
        self.titleLab.text = model.title
        self.subTitleLab.text = model.subtitle
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
        
        let arr = model.tags.components(separatedBy: ",")
        for t in arr{
            if t.count != 0{
                chooseTags.append(t)
            }
        }
        let dataSource = ArrayDataSource(data: chooseTags)
        // cell内容
        let viewSource = ClosureViewSource(viewUpdater: { (view: UIView, data: String, index: Int) in
            let nameLab:UILabel = (view.viewWithTag(113) as? UILabel) ?? UILabel()
            nameLab.tag = 113
            nameLab.textAlignment = .center
            nameLab.font = .systemFont(ofSize: 11)
            view.addSubview(nameLab)
            nameLab.bm.addConstraints([.fill])
            nameLab.text = "\(data)"
            
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 11
            view.layer.masksToBounds = true
            
            nameLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            view.layer.borderColor = UIColor.white.cgColor
        })
        // cell尺寸
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            let str = data.count == 0 ? "显示所有" : data
            return CGSize(width: str.stringWidth(14) + 20, height: 22)
        }
        let provider = BasicProvider(dataSource: dataSource, viewSource: viewSource, sizeSource: sizeSource)
        // 布局
        provider.layout = FlowLayout(spacing: 10, justifyContent: .start)
        collection.provider = provider
        collection.reloadData()
        collection.h = collection.contentSize.height
//        tagBGH.constant = collection.contentSize.height + 20
        
        // 正文
        let content = model.body ?? ""
        let lines : [SwiftyLine] = SwiftyMarkdown.getlines(content)
        var i = 0
        data = []
        for l in lines{
            print("\(i)  \"\(l.line)\"")
            i += 1
            data.append(l)
        }
        
    }

    func reloadContent(){
        for model in data{
            let cell = DetailContentCell.create(model)
            cell.contentTF.isEditable = false
            contentView.insertArrangedSubview(cell, at: contentView.arrangedSubviews.count-1)
        }
    }

    @IBAction func backAction(_ sender: Any) {
        self.back()
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
                    data.remove(at: i)
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
                    self.data.insert(model, at: i+1)
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
        }
    }
    
    
    /// 键盘工具栏
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
    
    @IBAction func editAvtion(_ sender: Any) {
        let vc = BlogEditVC()
        vc.model = self.model
        self.view.hero.id = "v"
        vc.view.hero.id = "v"
        self.pushViewControllerWithHero(vc)
    }
}


extension BlogReviewVC : UIScrollViewDelegate{
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
