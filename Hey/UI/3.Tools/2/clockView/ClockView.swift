//
//  ClockView.swift
//  
//
//  Created by 李志伟 on 2020/9/22.
//

import UIKit

class ClockView: UIView {

    var state : Bool!
    

    @IBOutlet weak var timeDayLab: UILabel!
    @IBOutlet weak var timeHourLab: UILabel!
    @IBOutlet weak var timeAmPmLab: UILabel!

    @IBOutlet weak var leftBGView: UIView!
    @IBOutlet weak var rightBGView: UIView!
    
    @IBOutlet weak var onOffView: UIView!
    
    static func create(_ state:Bool) -> ClockView{
        let v = ClockView.loadFromNib()
        v.state = state
        v.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 300)
        v.initUI()
        return v
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initUI() {
        rightBGView.layer.borderWidth = 4
        rightBGView.layer.borderColor = UIColor.white.cgColor
        rightBGView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9764705882, blue: 0.9882352941, alpha: 1)
         
        leftBGView.addInnerShadow(w: 5)
        
    }
    
    @IBAction func changeState(_ sender: Any) {
        
    }
    
}





