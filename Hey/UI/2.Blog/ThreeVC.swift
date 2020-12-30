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

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .default }
    }
    
    var complete:Int = 0
    var orignalData:Array<GithubPostModel>?
    var handleData:Array<GitHub_CachePost>!
    var cellArray:Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .KBGGray
        self.hideNav = true

        handleData = RealmManager.github.getPostList() ?? []
        if cache[.myGithubName] != nil && handleData.count != 0{
            inptBG.isHidden = true
            self.reloadView()
        }
    }
    
    @IBAction func loadAction(_ sender:UIButton){
        cache[.myGithubName] = accountInputTF.text
        Hud.showWait()
        self.requestAllPost()
    }
    
    func reloadView() {
        handleData = RealmManager.github.getPostList()
    }
    
}


// MARK: -  ---------------------- 数据请求处理 ------------------------
extension ThreeVC{
    //将新请求的数据存进数据库
    func requestAllPost(){
        network[.github_Post].request { (resp) in
            if resp?.code == 1{
                Hud.hide()
                self.orignalData = resp?.data
                self.complete = 0
                
                for orignal in self.orignalData!{
                    if let model = RealmManager.github.getPost(orignal.name){
                        if model.sha != orignal.sha{
                            self.requestDetail(orignal)
                        }else{
                            self.complete += 1
                        }
                    }else{
                        self.requestDetail(orignal)
                    }
                }
            }else{
                Hud.showText("读取失败")
            }
        }
    }
    
    func requestDetail(_ orignal:GithubPostModel) {
        network.request(orignal.download_url) { (content) in
            if content != nil{
                let m = self.hundlePOST(content!)
                m.sha = orignal.sha
                RealmManager.github.save(m)
            }
            self.complete += 1
            if self.complete == self.orignalData!.count {
                self.reloadView()
            }
        }
    }
    
    func hundlePOST(_ content:String) -> GitHub_CachePost{
        let m = GitHub_CachePost()
        
        var arr = content.components(separatedBy: "---\n")
        arr.remove(at: 0)
        let head = arr.remove(at: 0)
        let body = arr.joined()
        let titleStr = self.findStr(head, pattern: "(?<=(title:).*")
        let subtitleStr = self.findStr(head, pattern: "(?<=(subtitle:).*")
        let dateStr = self.findStr(head, pattern: "(?<=(date:).*")

        var tags = ""
        if let temp = head.components(separatedBy: "tags:\n").last{
            let temps = temp.components(separatedBy: "- ")
            for t in temps {
                tags = tags + t.replacingOccurrences(of: "\n", with: "")
            }
        }
        m.title = titleStr
        m.desc = subtitleStr
        m.time = dateStr.toDate()
        m.body = body
        m.tags = tags
        return m
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
