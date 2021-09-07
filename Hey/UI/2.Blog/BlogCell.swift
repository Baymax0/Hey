//
//  BlogCell.swift
//  Hey
//
//  Created by 李志伟 on 2020/12/30.
//  Copyright © 2020 baymax. All rights reserved.
//

import Foundation


class BlogCell: UIView {
    
    var bg1:UIView!
    var yearLab:UILabel!
    
    var bg2:UIView!
    var titleLab:UILabel!
    var subtitleLab:UILabel!

    var model:GitHub_CachePost!
    
    var tags:Set<String> = []
    
    var btn:UIButton!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func initUI() {
        self.backgroundColor = .white
        //----
        bg1 = UIView()
        self.addSubview(bg1)
        bg1.bm.addConstraints([.margin(0, 15, 0, 15)])
        
        yearLab = UILabel()
        yearLab.font = .systemFont(ofSize: 20)
        yearLab.textColor = .githubTheme
        bg1.addSubview(yearLab)
        yearLab.bm.addConstraints([.margin(0, 0, 0, 0)])

        //----
        bg2 = UIView() // 86
        self.addSubview(bg2)
        bg2.bm.addConstraints([.margin(0, 15, 0, 15)])
        
        titleLab = UILabel()
        titleLab.font = .boldSystemFont(ofSize: 17)
        titleLab.textColor = .KTextBlack
        bg2.addSubview(titleLab)
        titleLab.bm.addConstraints([.top(14), .left(0), .right(0), .h(24)]);
        
        subtitleLab = UILabel()
        subtitleLab.font = .systemFont(ofSize: 14)
        subtitleLab.textColor = .KTextGray
        bg2.addSubview(subtitleLab)
        subtitleLab.bm.addConstraints([.under(titleLab, 0), .left(2), .right(0), .h(24)]);
        
        let line = UIView()
        line.backgroundColor = .KBGGray
        bg2.addSubview(line)
        line.bm.addConstraints([.left(0), .bottom(0), .right(0), .h(1)])
        
        btn = UIButton()
        self.addSubview(btn)
        btn.bm.addConstraints([.fill])
    }
    
}



