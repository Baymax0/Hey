//
//  ThreeVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import AudioToolbox

class ThreeVC: BaseVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    

    @IBOutlet weak var inptBG: UIView!
    @IBOutlet weak var accountInputTF: UITextField!
    @IBOutlet weak var tokenInputTF: UITextField!

    // ---
    @IBOutlet var sc: UIScrollView!

    @IBOutlet var headView: UIView!
    var headViewH: NSLayoutConstraint!
    
    @IBOutlet var githubBg: UIImageView!

    @IBOutlet weak var tagBG: UIView!
    @IBOutlet weak var tagBGH: NSLayoutConstraint!
    var allTags:Set<String> = []
    var allTagsSorted:Array<String> = []
    var allTagsDic:Dictionary<String,Int> = [:]

    var collection:CollectionView!
     
    var complete:Int = 0
    var orignalData:Array<GithubPostModel>?
    var handleData:Array<GitHub_CachePost>!
    var tempHandleData:Array<GitHub_CachePost>!

    @IBOutlet weak var cellBGView: UIStackView!
    var cellArray:Array<BlogCell> = []
    
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var progressW: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true
        self.progressW.constant = 0
        
        sc.delegate = self
        self.view.addSubview(sc)
        sc.bm.addConstraints([.margin(64, 0, 0, 0)])
        sc.isHidden = true
        
        headView.frame = CGRect(x: 0, y: 64, width: KScreenWidth, height: 0)
        headView.alpha = 0
        self.view.addSubview(headView)
        
        let anvi = self.view.viewWithTag(-1)
        self.view.bringSubviewToFront(anvi!)

        handleData = RealmManager.github.getPostList() ?? []
        if cache[.myGithubName] != nil && cache[.myGithubToken] != nil && handleData.count != 0{
            self.reloadView()
        }else{
            self.view.bringSubviewToFront(tagBG)
        }
    }
    
    func setProgress(_ p:Int){
        if p < 0{
            UIView.animate(withDuration: 0.4) {
                self.progress.alpha = 0
                self.progress.superview?.layoutIfNeeded()
                self.progressW.constant = 0
            }
        }else if p == 0{
            UIView.animate(withDuration: 0.4) {
                self.progress.superview?.layoutIfNeeded()
                self.progress.alpha = 1
                self.progressW.constant = 0.1 * KScreenWidth
            }
        }else if p >= 1{
            let pro = 0.1 + 0.9 * CGFloat(self.complete) / CGFloat(self.orignalData!.count)
            
            UIView.animate(withDuration: 0.4) {
                self.progressW.constant = pro * KScreenWidth
                self.progress.superview?.layoutIfNeeded()
            }
            
            if self.complete == self.orignalData!.count{
                UIView.animate(withDuration: 0.4) {
                    self.progress.alpha = 0
                }
                RealmManager.github.saveAll(tempHandleData)
                if self.complete == self.orignalData!.count {
                    self.reloadView()
                }
            }
        }
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        if sender.tag == 0{
            requestAllPost()
        }
        if sender.tag == 1{
            let vc = BlogEditVC()
            self.pushViewController(vc)
        }
    }
    
    @IBAction func loadAction(_ sender:UIButton){
        if tokenInputTF.text.bm_count != 0{
            cache[.myGithubName] = accountInputTF.text
            cache[.myGithubToken] = tokenInputTF.text
            Hud.showWait()
            self.requestAllPost()
        }
    }
    
    func reloadView() {
        sc.isHidden = false

        inptBG.isHidden = true
        
        handleData = RealmManager.github.getPostList()
        for v in cellArray{
            cellBGView.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        cellArray = []
        allTags = []
        allTagsDic = [:]
        
        var lastYear = ""
        weak var lastCell:BlogCell? // 用于保存当前年份的tag
        for data in handleData{
            if data.date.yearString != lastYear {
                let m = GitHub_CachePost()
                m.date = data.date
                let cell = getCell(with: m)
                cellBGView.addArrangedSubview(cell)
                cellArray.append(cell)
                cell.bm.addConstraints([.h(cell.h)])

                lastCell = cell
                lastYear = data.date.yearString
            }

            let cell = getCell(with: data)
            cellBGView.addArrangedSubview(cell)
            cellArray.append(cell)
            cell.btn.tag = cellArray.count-1
            cell.btn.addTarget(self, action: #selector(cellAction(_:)), for: .touchUpInside)
            cell.bm.addConstraints([.h(cell.h)])

            let arr = data.tags.components(separatedBy: ",")
            cell.tags = Set(arr)

            for tag in arr {
                lastCell!.tags.insert(tag)
                allTags.insert(tag)
                let num = allTagsDic[tag] ?? 0
                allTagsDic[tag] = num + 1
            }
        }
        
        // tags 单选框
        if collection == nil{
            collection = CollectionView(frame: .init(x: 12, y: 12, width: KScreenWidth-24, height: 200))
            tagBG.addSubview(collection)
            tagBG.backgroundColor = .white
        }
        
        // 数据数组
        allTagsSorted = Array(allTags)
        allTagsSorted.sort { (s1, s2) -> Bool in
            let num1 = allTagsDic[s1] ?? 0
            let num2 = allTagsDic[s2] ?? 0
            return num1 > num2
        }
        
        var allTags = allTagsSorted
        for i in 0..<allTags.count{
            if allTags[i].count == 0{
                allTags.remove(at: i)
                break
            }
        }
        cache[.allPostTags] = allTags
        
        let dataSource = ArrayDataSource(data: allTagsSorted)
        // cell内容
        let viewSource = ClosureViewSource(viewUpdater: { (view: UIView, data: String, index: Int) in
            let nameLab:UILabel = (view.viewWithTag(113) as? UILabel) ?? UILabel()
            nameLab.tag = 113
            nameLab.textAlignment = .center
            nameLab.font = .boldSystemFont(ofSize: 14)
            nameLab.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            view.addSubview(nameLab)
            nameLab.bm.addConstraints([.fill])

            let num = self.allTagsDic[data] ?? 0

            let numLab = (view.viewWithTag(114) as? UILabel) ?? UILabel()
            numLab.tag = 114
            numLab.backgroundColor = .clear
            numLab.font = .systemFont(ofSize: 9)
            numLab.textColor = .white
            numLab.textAlignment = .left
            view.addSubview(numLab)
            numLab.bm.addConstraints([.right(0), .top(0), .w(17), .h(17)])
            
            if data.count == 0{
                nameLab.text = "显示所有"
                numLab.text = self.handleData.count.toString()
            }else{
                nameLab.text = "\(data)"
                numLab.text = num.toString()
            }
            let color = view.viewWithTag(115) ?? UIView()
            color.tag = 115
            color.backgroundColor = #colorLiteral(red: 0.1610877216, green: 0.4596017003, blue: 0.6591704488, alpha: 1)
            let alpha = CGFloat(num) / CGFloat(self.handleData.count) * 0.7 + 0.3
            
            color.alpha = alpha
            view.addSubview(color)
            view.sendSubviewToBack(color)
            color.bm.addConstraints([.fill])
            
            view.backgroundColor = #colorLiteral(red: 0.894312501, green: 0.6155394316, blue: 0.7133728862, alpha: 1)
            view.layer.cornerRadius = 14
            view.layer.masksToBounds = true
        })
        // cell尺寸
        let sizeSource = { (index: Int, data: String, collectionSize: CGSize) -> CGSize in
            let str = data.count == 0 ? "显示所有" : data
            return CGSize(width: str.stringWidth(14) + 34, height: 28)
        }
        let provider = BasicProvider(dataSource: dataSource, viewSource: viewSource, sizeSource: sizeSource, tapHandler: { [weak self] context in
            if let tagName = self!.allTagsSorted.bm_object(context.index){
                for cell in self!.cellArray {
                    if cell.tags.contains(tagName){
                        cell.isHidden = false
                    }else{
                        cell.isHidden = true
                    }
                }
            }
        })
        // 布局
        provider.layout = FlowLayout(spacing: 10, justifyContent: .center)
        collection.provider = provider
        collection.reloadData()
        collection.h = collection.contentSize.height
        tagBGH.constant = collection.contentSize.height + 20
        
//        let tap = UITapGestureRecognizer(target: self, action:#selector(self.tagCellClickAction(_:)))
//        collection.tap(gesture: tap)
    }
    
    @objc func tagCellClickAction(_ ges:UITapGestureRecognizer) {
        let tag = ges.view?.tag
        if let tagName = allTagsSorted.bm_object(tag!){
            for cell in cellArray {
                if cell.tags.contains(tagName){
                    cell.isHidden = false
                }else{
                    cell.isHidden = true
                }
            }
        }
    }
    
    func getCell(with model:GitHub_CachePost) -> BlogCell {
        let cell = BlogCell(frame: .init(x: 0, y: 0, width: KScreenWidth, height: 80))
        cell.model = model
        if model.title == nil{
            cell.bg2.isHidden = true
            cell.h = 44
            cell.yearLab.text = model.date.yearString
        }else{
            cell.bg2.isHidden = false
            cell.titleLab.text = model.title
            cell.subtitleLab.text = model.subtitle
            cell.h = 80
        }
        return cell
    }
    
    @objc func cellAction(_ btn:UIButton) {
        let cell = cellArray[btn.tag]
        let vc = BlogReviewVC()
        vc.model = cell.model
        self.pushViewController(vc)
    }
    
}


// MARK: -  ---------------------- 数据请求处理 ------------------------
extension ThreeVC{
    //将新请求的数据存进数据库
    func requestAllPost(){
        self.setProgress(0)
        network[.github_Post].request { (resp) in
            if resp?.code == 1{
                Hud.hide()
                self.orignalData = resp?.data
                self.complete = 0
                self.tempHandleData = []
                
                for orignal in self.orignalData!{
                    if let model = RealmManager.github.getPost(orignal.name){
//                        if model.sha != orignal.sha || model.title.count == 0{
                            self.requestDetail(orignal)
//                        }else{
//                            // 文章内容没变 从数据库中读出来
//                            self.tempHandleData.append(model)
//                            self.complete += 1
//                            self.setProgress(self.complete)
//                        }
                    }else{
                        self.requestDetail(orignal)
                    }
                }
            }else{
                Hud.showText("读取失败")
                self.setProgress(-1)
            }
        }
    }
    
    func requestDetail(_ orignal:GithubPostModel) {
        Github.request(orignal.url) { (jsonStr) in
            if let data = JSONDeserializer<GithubPostDetailModel>.deserializeFrom(json: jsonStr){
                let decodedData = Data(base64Encoded: data.content, options: .ignoreUnknownCharacters)!
                let content = String(data: decodedData, encoding: .utf8)!
                let m = self.hundlePOST(content)
                m.name = orignal.name
                m.sha = orignal.sha
                self.tempHandleData.append(m)
            }
            self.complete += 1
            self.setProgress(self.complete)
        }
    }
    
    func hundlePOST(_ content:String) -> GitHub_CachePost{
        let m = GitHub_CachePost()
        
        var arr = content.components(separatedBy: "---")
        arr.remove(at: 0)
        let head = arr.remove(at: 0)
        let body = arr.joined(separator: "---")
        let titleStr = self.findStr(head, pattern: "(?<=(title:)).*")
        let subtitleStr = self.findStr(head, pattern: "(?<=(subtitle:)).*")
        let dateStr = self.findStr(head, pattern: "(?<=(date:)).*")
        let authorStr = self.findStr(head, pattern: "(?<=(author:)).*")
        let imgStr = self.findStr(head, pattern: "(?<=(header-img:)).*")

        var tags = ""
        if let temp = head.components(separatedBy: "tags:\n").last{
            let temps = temp.components(separatedBy: "- ")
            for t in temps {
                tags = tags + "," + t.replacingOccurrences(of: "\n", with: "")
            }
        }
        m.title = self.removeQuotation(titleStr)
        m.subtitle = self.removeQuotation(subtitleStr)
        m.date = dateStr.toDate()
        m.author = self.removeQuotation(authorStr)
        m.header_img = self.removeQuotation(imgStr)

        m.body = body
        m.tags = tags
        return m
    }
    
    func removeQuotation(_ str:String) -> String {
        var result = str
        if str.hasPrefix("\""){
            result = str[1...]
        }
        if result.hasSuffix("\""){
            result = result[..<(-1)]
        }
        return result
    }
    
    func findStr(_ content:String, pattern:String) -> String {
        if let rangeindex = content.range(of: pattern, options: .regularExpression, range: content.startIndex..<content.endIndex, locale: Locale.current){
            var result = String(content[rangeindex])
            result = result.trimmingCharacters(in: .whitespaces)
            return result
        }
        return ""
    }
}

extension ThreeVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            if headView.tag == 0{
                headView.h = -scrollView.contentOffset.y
                headView.alpha = -scrollView.contentOffset.y / 70
                if scrollView.contentOffset.y <= -70{
                    headView.tag = 1
                    AudioServicesPlaySystemSound(1519)
                    UIView.animate(withDuration: 0.2) {
                        self.headView.alpha = 1
                        self.headView.h = 70
                    }
                }
            }
        }
        
        if scrollView.contentOffset.y > 10{
            if headView.tag == 1{
                self.hideHead()
            }
        }
    }
    
    func hideHead() {
        headView.tag = 0
        AudioServicesPlaySystemSound(1519)
        UIView.animate(withDuration: 0.2) {
            self.headView.alpha = 0
            self.headView.y = 0
        } completion: { (_) in
            self.headView.y = 64
        }
    }
}







