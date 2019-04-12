//
//  UkuleleVC.swift
//  LisApp
//
//  Created by yimi on 2019/4/9.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit
import Kingfisher

class UkuleleVC: BaseTableVC {
    var nextUrl:String?
    
    var magaView:UIView!
    var magaBtnArr = Array<UIButton>()

    var magaArr = Array<TKMagazine>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView(rect: CGRect(x: 0, y: 64, width: KScreenWidth, height: KScreenHeight))
        self.view.addSubview(self.tableview!)
        self.view.sendSubviewToBack(self.tableview!)
        magaView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 100))
        magaView.backgroundColor = KBlack_153
        self.tableview?.addSubview(magaView)
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.tableview?.register(ukuleleCell.nib, forCellReuseIdentifier: "cell")
        self.initMJHeadView()
        self.initMJFootView()

        self.addSlideBack(self.view)
        self.loadNewDataWithIndicator()
    }
    
    
    override func loadData(_ index: Int) {
        var url = nextUrl
        if index == 1{
            url = TKApiManager.manage.api
        }else{
            if url == nil{
                return
            }
        }
        Network.requestTK(url!) { (resp) in
            if resp.code > 0 {
                if let url = resp.nextUrl{
                    self.nextUrl = url
                }else{
                    self.nextUrl = nil
                }
                self.pageNo = index
                self.finishLoadDate()
                self.addData(resp.events)
            }
        }
    }
    
    func finishLoadDate() {
        self.tableview?.mj_header?.endRefreshing()
        if nextUrl != nil{
            self.tableview?.mj_footer?.endRefreshing()
        }else{
            self.tableview?.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    func addData(_ data:Array<TKEventModel>){
        var temp = Array<TKArticle>()
        for d in data{
            if d.type == "article"{
                let art = d.article
                temp.append(art!)
            }else if d.type == "section"{
                var temp2 = Array<TKMagazine>()
                for event in d.section.events{
                    let maga = event.magazine
                    temp2.append(maga!)
                }
                magaArr = temp2
                self.reloadMaga()
            }
        }
        if pageNo == 1{
            self.dataArr = temp
        }else{
            self.dataArr.append(contentsOf: temp)
        }
        self.reloadData()
    }
    
    func reloadMaga(){
        var index:Int = -1
        for mod in magaArr{
            index += 1
            
            var btn = magaBtnArr.bm_object(index)
            if btn == nil{
                btn = UIButton(frame: CGRect(x: 0, y: 0, width: KScreenWidth/3, height: KScreenWidth/5))
                btn?.backgroundColor = KWhite
                magaView.addSubview(btn!)
                magaBtnArr.append(btn!)
            }
            btn?.x = CGFloat(index % 3) * (KScreenWidth/3)
            btn?.y = CGFloat(index / 3) * (KScreenWidth/4)
            btn?.imageView?.contentMode = .scaleAspectFit
            btn!.kf.setImage(with: mod.cover.resource, for: .normal, placeholder: nil, options: [.transition(.fade(0.45))])

//            btn?.setTitle(mod.name, for: .normal)
            btn?.addTarget(self, action: #selector(clickMaga(_:)), for: .touchUpInside)
            btn!.tag = index
        }
        
        let h = CGFloat(index / 3 + 1) * (KScreenWidth/4)
        magaView.frame = CGRect(x: 0, y: -h, width: KScreenWidth, height: h)
        tableview?.contentInset = UIEdgeInsets(top: h, left: 0, bottom: 0, right: 0)
    }
    
    @objc func clickMaga(_ btn:UIButton){
        
    }
    
    @IBAction func showMenuAction(_ btn: UIButton) {
        let vc = UkuleleVC.fromStoryboard() as! UkuleleVC
        present(vc, animated: true, completion: nil)
    }
    
}

extension UkuleleVC :UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ukuleleCell.cellH
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ukuleleCell
        var model = self.dataArr[indexPath.row] as! TKArticle
        cell.setData(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebVC()
        let model = self.dataArr[indexPath.row] as! TKArticle
        vc.urlString = model.webUrl
        present(vc, animated: true, completion: nil)
    }
    
}
