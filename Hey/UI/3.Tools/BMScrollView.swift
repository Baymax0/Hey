//
//  BMScrollView.swift
//  LisApp
//
//  Created by yimi on 2019/2/25.
//  Copyright © 2019 baymax. All rights reserved.
//

import UIKit

@objc protocol BMScrollViewDelegate{
    /// 点击图片回调
    @objc optional func bm_scrollView(didSelected index:Int)
    /// 图片加载回调
    @objc optional func bm_scrollView(view:UIImageView,willLoadIndex index:Int)
    /// 点击图片回调
    @objc optional func bm_scrollView(didScrollTo index:Int)
    
    @objc optional func bm_scrollView(DidScroll scrollView:UIScrollView)
}

class BMScrollView: UIView ,UIScrollViewDelegate{

    weak var delegate:BMScrollViewDelegate?
    
    var currentIndex:Int = 0{
        didSet{
            if self.delegate != nil{
                self.delegate!.bm_scrollView?(didScrollTo: self.currentIndex)
            }
        }
    }
    
    var dataArr:Array<String> = Array<String>()
    
    // 间隔时间
    var interval:TimeInterval = 4
    
    // 自动方向 不为0则 不自动 正向取1 反向-1
    var direct:Int = 0{
        didSet{
            if direct != 0{
                if timer == nil{
                    time = 100
                    timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(repeatAction), userInfo: nil, repeats: true)                    
                }
            }else{
                if timer != nil{
                    timer.invalidate()
                    timer = nil                    
                }
                interval = 4
            }
        }
    }
    
    var timer:Timer!
    private var time:TimeInterval = 0;

    var imgViewMode:UIView.ContentMode = .scaleAspectFit{
        didSet{
            leftImageView.contentMode = imgViewMode
            centerImageView.contentMode = imgViewMode
            rightImageView.contentMode = imgViewMode
        }
    }
    
    var scWidth:CGFloat = 0
    var scHeight:CGFloat = 0
    

    lazy var sc:UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .black
//        view.bounces = false
        view.isPagingEnabled = true
        view.alwaysBounceVertical = NO;
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.frame = self.bounds
        view.contentSize = CGSize(width: scWidth * 3, height: scHeight+1)
        view.contentOffset = CGPoint(x: scWidth, y: 0)
        view.delegate = self
        return view
    }()
    
    
    func changeWidth(w:CGFloat){
        self.scWidth = w;
        self.w = w
        sc.w = w
        sc.contentSize = CGSize(width: scWidth * 3, height: scHeight+1)
        sc.contentOffset = CGPoint(x: scWidth, y: 0)

        leftImageView.w = w
        centerImageView.x = w
        centerImageView.w = w
        rightImageView.x = w*2
        rightImageView.w = w
        
    }
    
    
    
    lazy private var leftImageView:UIImageView={
        var view = UIImageView(frame: CGRect(x: 0, y: 0, width: scWidth, height: scHeight))
        view.contentMode = self.imgViewMode
        view.clipsToBounds = true
        return view
    }()
    lazy var centerImageView:UIImageView={
        var view = UIImageView(frame: CGRect(x: scWidth, y: 0, width: scWidth, height: scHeight))
        view.contentMode = self.imgViewMode
        view.clipsToBounds = true
        return view
    }()
    lazy private var rightImageView:UIImageView={
        var view = UIImageView(frame: CGRect(x: scWidth*2, y: 0, width: scWidth, height: scHeight))
        view.contentMode = self.imgViewMode
        view.clipsToBounds = true
        return view
    }()
    //用户滑动界面
//    private var humanTouch:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scWidth = frame.size.width
        scHeight = frame.size.height
        self.addSubview(sc)
        sc.addSubview(leftImageView)
        sc.addSubview(centerImageView)
        sc.addSubview(rightImageView)
        sc.delaysContentTouches = true
    }
    
    convenience init(frame: CGRect,currentIndex:Int,dataArr:Array<String>,delegate:BMScrollViewDelegate?) {
        self.init(frame: frame)
        self.delegate = delegate
        self.currentIndex = currentIndex
        self.dataArr = dataArr
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        centerImageView.addGestureRecognizer(tap)
        
        let btn = UIButton(frame: centerImageView.frame)
        btn.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        sc.addSubview(btn)
        
        self.loadImage()
    }
    func loadImage(){
        self.loadImage(leftImageView, index: currentIndex-1)
        self.loadImage(centerImageView, index: currentIndex)
        self.loadImage(rightImageView, index: currentIndex+1)
    }
    
    @objc func repeatAction(){
        time = time + 0.2
        if time >= interval{
            let x = scWidth + scWidth * CGFloat(direct)
            sc.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            time = 0
            //
            let deadline = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.scrollViewDidEndDecelerating(self.sc)
            }
        }
    }
    
    func loadImage(_ view:UIImageView,index:Int){
        let newIndex = getRemainder(index)
        if delegate != nil{
            // 手动加载图片
            delegate!.bm_scrollView?(view: view, willLoadIndex: newIndex)
        }else{
            // 默认加载方式
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if sc.contentOffset.x == scWidth{
            return
        }
        
        if sc.contentOffset.x == 0{
            currentIndex = getRemainder(currentIndex - 1)
        }else if sc.contentOffset.x > scWidth*2-10{
            currentIndex = getRemainder(currentIndex + 1)
        }
        self.loadImage(centerImageView, index: currentIndex)
        sc.contentOffset = CGPoint(x: scWidth, y: 0)
        self.loadImage(leftImageView, index: currentIndex-1)
        self.loadImage(rightImageView, index: currentIndex+1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.delegate != nil{
            self.delegate!.bm_scrollView?(DidScroll: sc)
        }
    }
    
    @objc func tapAction(){
        if self.delegate != nil{
            self.delegate!.bm_scrollView?(didSelected: currentIndex)
        }
    }
    
    // 得到循环非负的index
    func getRemainder(_ index:Int) -> Int {
        var newIndex = index
        if index < 0{
            newIndex += dataArr.count
        }
        newIndex = newIndex % dataArr.count
        return newIndex
    }

}
