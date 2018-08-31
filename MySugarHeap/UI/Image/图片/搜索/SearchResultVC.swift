//
//  SearchResultVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class SearchResultVC: BaseVC {

    var searchString = ""

    @IBOutlet weak var searchTF: UITextField!

    @IBOutlet weak var titleView: DNSPageTitleView!

    @IBOutlet weak var contentView: DNSPageContentView!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTF.text = searchString

        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.titleViewBackgroundColor = UIColor.white
        style.isShowCoverView = false
        style.isShowBottomLine = true
        style.bottomLineColor = KRed

        titleView.titles = ["堆糖图片", "堆糖文章", "即刻"]
        titleView.style = style
        titleView.currentIndex = 0
        titleView.setupUI()

        // 对contentView进行设置
        let v1 = ImageTableVC()
        v1.keyWords = self.searchString

        contentView.childViewControllers = [v1,ArticleTableVC(),ImageTableVC()]
        contentView.startIndex = 0
        contentView.style = style
        contentView.setupUI()
        contentView.collectionView.delaysContentTouches = NO
        contentView.collectionView.isScrollEnabled = false

        for vc in contentView.childViewControllers{
            self.addChildViewController(vc)
        }

        // 让titleView和contentView进行联系起来
        titleView.delegate = contentView
        contentView.delegate = titleView

    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: NO, completion: nil)
    }

    @IBAction func backToSearchAction(_ sender: Any) {
        dismiss(animated: NO, completion: nil)
    }

}
