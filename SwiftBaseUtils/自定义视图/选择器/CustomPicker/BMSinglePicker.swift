//
//  BMSinglePicker.swift
//  wangfuAgent
//
//  Created by lzw on 2018/7/26.
//  Copyright © 2018 zhuanbangTec. All rights reserved.
//

import UIKit

class BMSinglePicker: BMBasePicker {

    var dataArray:Array<String>

    var selectedIndex:Int

    var changed: ((_:Int)->())?

    var selected: ((_:Int)->())

    init(_ dataArray:Array<String>,_ index:Int = 0, _ selected:@escaping(_:Int)->(), _ changed:((_:Int)->())? = nil) {
        self.dataArray = dataArray
        self.selectedIndex = index
        self.selected = selected
        self.changed = changed
        super.init()
        self.setContentH(240)
        self.rowH = 35
    }

    required init?(coder aDecoder: NSCoder) {   fatalError("init(coder:) has not been implemented") }

}


// MARK: - 重写的方法
extension BMSinglePicker{

    override func comfirm(){
        super.comfirm()
        selected(selectedIndex)
    }
    override func show() {
        super.show()
        pickerView.reloadAllComponents()
        //显示初始水印
        if bgLab.isHidden == false{
            bgLab.text = dataArray[selectedIndex]
        }
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }


    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.bgLab.text = dataArray[row]
        self.selectedIndex = row
        changed?(row)
    }
}





