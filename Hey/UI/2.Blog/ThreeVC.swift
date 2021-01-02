//
//  ThreeVC.swift
//  Lee
//
//  Created by yimi on 2019/11/5.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit


class ThreeVC: BaseVC {
    
    @IBOutlet weak var inptBG: UIView!
    @IBOutlet weak var accountInputTF: UITextField!

    @IBOutlet weak var tagBG: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    var complete:Int = 0
    var orignalData:Array<GithubPostModel>?
    var handleData:Array<GitHub_CachePost>!
    var tempHandleData:Array<GitHub_CachePost>!

    
    @IBOutlet var sc: UIScrollView!
    @IBOutlet weak var cellBGView: UIStackView!
    var cellArray:Array<UIView> = []
    var allTags:Set<String> = []
    
    @IBOutlet weak var progress: UIView!
    @IBOutlet weak var progressW: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true

        handleData = RealmManager.github.getPostList() ?? []
        if cache[.myGithubName] != nil && handleData.count != 0{
            self.reloadView()
        }
        self.progressW.constant = 0
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
            
            if pro == 1{
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
    
    @IBAction func menuAction(_ sender: Any) {
        requestAllPost()
    }
    
    @IBAction func loadAction(_ sender:UIButton){
        cache[.myGithubName] = accountInputTF.text
        Hud.showWait()
        self.requestAllPost()
    }
    
    func reloadView() {
        inptBG.isHidden = true
        
        handleData = RealmManager.github.getPostList()
        for v in cellArray{
            cellBGView.removeArrangedSubview(v)
        }
        cellArray = []
        allTags = []
        
        var lastYear = ""
        weak var lastCell:BlogCell? // 用于保存当前年份的tag
        for data in handleData{
            if data.time.yearString != lastYear {
                let m = GitHub_CachePost()
                m.time = data.time
                let cell = getCell(with: m)
                cellBGView.addArrangedSubview(cell)
                cellArray.append(cell)
                cell.bm.addConstraints([.h(cell.h)])
                
                lastCell = cell
                lastYear = data.time.yearString
            }
            
            let cell = getCell(with: data)
            cellBGView.addArrangedSubview(cell)
            cellArray.append(cell)
            cell.bm.addConstraints([.h(cell.h)])

            let arr = data.tags.components(separatedBy: ",")
            cell.tags = Set(arr)
            
            for tag in arr {
                lastCell!.tags.insert(tag)
                allTags.insert(tag)
            }
        }
        
        if sc.superview == nil{
            self.view.addSubview(sc)
            sc.bm.addConstraints([.margin(64, 0, 0, 0)])
        }
    }
    
    func getCell(with model:GitHub_CachePost) -> BlogCell {
        let cell = BlogCell(frame: .init(x: 0, y: 0, width: KScreenWidth, height: 80))
        cell.model = model
        if model.title == nil{
            cell.bg2.isHidden = true
            cell.h = 44
            cell.yearLab.text = model.time.yearString
        }else{
            cell.bg2.isHidden = false
            cell.titleLab.text = model.title
            cell.subtitleLab.text = model.desc
            cell.h = 80
        }
        return cell
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
                        if model.sha != orignal.sha{
                            self.requestDetail(orignal)
                        }else{
                            // 文章内容没变 从数据库中读出来
                            self.tempHandleData.append(model)
                            self.complete += 1
                            self.setProgress(self.complete)
                        }
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
        network.request(orignal.git_url) { (jsonStr) in
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
        
        var arr = content.components(separatedBy: "---\n")
        arr.remove(at: 0)
        let head = arr.remove(at: 0)
        let body = arr.joined()
        let titleStr = self.findStr(head, pattern: "(?<=(title:)).*")
        let subtitleStr = self.findStr(head, pattern: "(?<=(subtitle:)).*")
        let dateStr = self.findStr(head, pattern: "(?<=(date:)).*")

        var tags = ""
        if let temp = head.components(separatedBy: "tags:\n").last{
            let temps = temp.components(separatedBy: "- ")
            for t in temps {
                tags = tags + "," + t.replacingOccurrences(of: "\n", with: "")
            }
        }
        m.title = self.removeQuotation(titleStr)
        m.desc = self.removeQuotation(subtitleStr)
        
        m.time = dateStr.toDate()
    
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
            result = result[...(-1)]
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
