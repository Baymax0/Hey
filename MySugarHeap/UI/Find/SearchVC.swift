//
//  SearchVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class SearchVC: BaseVC {

    @IBOutlet weak var searchTF: UITextField!

    @IBOutlet weak var historySearchView: UIView!
    @IBOutlet weak var historyContentView: UIView!

    var historySearch:Array<String>!


    override func viewDidLoad() {
        super.viewDidLoad()
        hideNav = true
        historySearch = Array<String>()
        historySearch = BMCache.getStringList(.FindSearchHistory)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHistorySearchBtn()
        searchTF.text = ""
        searchTF.becomeFirstResponder()

    }

    @IBAction func back(_ sender: Any) {
        self.view.endEditing(YES)
        self.navigationController?.popViewController(animated: NO)
    }
}




extension SearchVC{
    func showHistorySearchBtn(){
        if historySearch.count == 0 {
            for v in historySearchView.subviews{
                v.isHidden = YES
            }
            return
        }
        for v in historyContentView.subviews{
            v.removeFromSuperview()
        }
        for v in historySearchView.subviews{
            v.isHidden = NO
        }
        let blank:CGFloat   = 15
        let h   :CGFloat    = 35
        var row :CGFloat    = 0
        var x   :CGFloat    = 0
        let fontSize:CGFloat = 14
        for str in historySearch {
            var w = str.stringWidth(fontSize)+30
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
            btn.setTitle(str, for: .normal)
            btn.setTitleColor(KBlack_87, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.lineBreakMode = .byTruncatingTail
            btn.addTarget(self, action: #selector(chooseHistoryBtn(_:)), for: .touchUpInside)
            historyContentView.addSubview(btn)
        }
    }

    @IBAction func deleteHistoryAction(_ sender: Any) {
        historySearch = Array<String>()
        BMCache.set(.FindSearchHistory, value: historySearch)
        showHistorySearchBtn()
    }

    @objc func chooseHistoryBtn(_ btn:UIButton){
        searchTF.text = btn.titleLabel?.text
        searchTF.resignFirstResponder()
        gotoSearch()
    }

    func gotoSearch() -> Void {
        if searchTF.text?.count == 0{
            return
        }
        let vc = SearchResultVC.fromStoryboard() as! SearchResultVC
        vc.searchString = searchTF.text!
        self.navigationController?.pushViewController(vc, animated: NO)
    }
}


extension SearchVC:UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.count == 0 {
            showHistorySearchBtn()
        }
        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        if text?.count == 0 { return YES }
        //记录缓存
        for (i,s) in historySearch.enumerated(){
            if s == text!{
                self.historySearch.remove(at: i)
                break
            }
        }
        historySearch.insert(text!, at: 0)
        //去重
        BMCache.set(.FindSearchHistory, value: historySearch)

        //收键盘
        textField.resignFirstResponder()
        //search
        gotoSearch()
        return YES
    }
}
