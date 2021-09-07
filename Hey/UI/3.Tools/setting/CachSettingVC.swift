//
//  CachSettingVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/14.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit
import LTMorphingLabel

class BMCacheBackUp {
    
    class BackUpModel: HandyJSON {
        var timeStamp   : TimeInterval!
        var data        :Dictionary<String, Any>!
        required init(){}
    }
    
    static let ICloudKey = "Hey_ICloudKey"
    static let cachePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0] as NSString).appendingPathComponent("Cache_BackUp.json")
    
    static func isIcloudAvailable() -> Bool {
        if FileManager.default.ubiquityIdentityToken != nil{
            return true
        } else {
            return false
        }
    }
    
    static func saveToFile() -> BackUpModel{
        let saveModel = BackUpModel()
        saveModel.data = cache.allCache()
        saveModel.timeStamp = Date().toTimeInterval()
        
        let json = saveModel.toJSONString() ?? "{}"
        print("..........")
        print("..........")
        do {
            try json.write(to: URL(fileURLWithPath: BMCacheBackUp.cachePath), atomically: true, encoding: .utf8)
            print("本地 存档 ..... success .....")
        } catch {
            print("本地 存档 ..... fault .....")
        }
        return saveModel
    }
    
    static func saveToICloud() -> BackUpModel{
        let saveModel = BackUpModel()
        saveModel.data = cache.allCache()
        saveModel.timeStamp = Date().toTimeInterval()
        
        let json = saveModel.toJSONString() ?? "{}"
        print("..........")
        print("..........")
        if isIcloudAvailable() {
            // 判断icloud是否可用
            NSUbiquitousKeyValueStore.default.set(json, forKey: ICloudKey)
            print("icloud 存档 ..... success .....")
        }else{
            print("icloud 存档 ..... fault .....")
        }
        return saveModel
    }
    
    static func getCacheFile() ->BackUpModel?{
        var jsonStr:String = ""
        print("............")
        //先读取本地文件
        if let data = try? Data(contentsOf: URL(fileURLWithPath: cachePath)){
            jsonStr = String(data: data, encoding: .utf8) ?? ""
            print("加载本地成功")
        }else{
            return nil
        }
        let model = BackUpModel.deserialize(from: jsonStr)
        return model
    }
    
    
    static func getICloudFile() ->BackUpModel?{
        var jsonStr:String = ""
        print("............")
        //先读取本地文件
        // 从icloud读取
        if let data = NSUbiquitousKeyValueStore.default.object(forKey: ICloudKey) as? Data{
            jsonStr = String(data: data, encoding: .utf8) ?? ""
            print("icloud 读取成功")
        }else{
            print("icloud 读取失败")
            return nil
        }
        let model = BackUpModel.deserialize(from: jsonStr)
        return model
    }
}


class CachSettingVC: BaseVC {
    
    var keyStore:NSUbiquitousKeyValueStore!

    @IBOutlet weak var fileSaveTimeLab: UILabel!
    @IBOutlet weak var fileSizeLab: UILabel!
    
    @IBOutlet weak var icloudSaveTimeLab: UILabel!
    @IBOutlet weak var icloudSizeLab: UILabel!

    @IBOutlet weak var contentStack: UIStackView!
    
    var fileBackUpModel:BMCacheBackUp.BackUpModel?
    var icloudBackUpModel:BMCacheBackUp.BackUpModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get{ return .lightContent}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNav = true
        
        var delay:TimeInterval = 0
        for v in contentStack.arrangedSubviews{
            v.hero.modifiers = [.translate(x: 0, y: 70, z: 0), .delay(delay)]
            delay += 0.1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        fileBackUpModel = BMCacheBackUp.getCacheFile()
        icloudBackUpModel = BMCacheBackUp.getICloudFile()
        self.reloadTimeLab()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        if sender.tag == 0{
            if let data = fileBackUpModel?.data{
                cache.clearCache()
                // file
                for (k,v) in data{
                    cache.Defaults.setValue(v, forKey: k)
                }
                Hud.showText("读取成功")
            }
        }else{
            // icloud
            if let data = icloudBackUpModel?.data{
                // file
                for (k,v) in data{
                    cache.clearCache()
                    cache.Defaults.setValue(v, forKey: k)
                }
                Hud.showText("读取成功")
            }
        }
        self.reloadTimeLab()
    }
    
    func reloadTimeLab() {
        if fileBackUpModel != nil{
            let date = Date(timeIntervalSince1970: fileBackUpModel!.timeStamp)
            fileSaveTimeLab.text = date.toString("yyyy/MM/dd HH:mm")
            fileSizeLab.text = fileBackUpModel?.data.getJsonStr()?.count.toString()
        }else{
            fileSaveTimeLab.text = "未归档"
            fileSizeLab.text = ""
        }
        if icloudBackUpModel != nil{
            let date = Date(timeIntervalSince1970: icloudBackUpModel!.timeStamp)
            icloudSaveTimeLab.text = date.toString("yyyy/MM/dd HH:mm")
            icloudSizeLab.text = icloudBackUpModel?.data.getJsonStr()?.count.toString()
        }else{
            icloudSaveTimeLab.text = "未归档"
            icloudSizeLab.text = ""

        }
    }

    @IBAction func saveAction(_ sender: UIButton) {
        if sender.tag == 0{
            // file
            showComfirm("提醒", "确认覆盖当前存档吗") {
            } complish: {
                Hud.showWait()
                self.fileBackUpModel = BMCacheBackUp.saveToFile()
                self.reloadTimeLab()
                Hud.hide()
            }
        }else{
            // icloud
            showComfirm("提醒", "确认覆盖当前存档吗") {
            } complish: {
                Hud.showWait()
                self.icloudBackUpModel = BMCacheBackUp.saveToICloud()
                self.reloadTimeLab()
                Hud.hide()
            }
        }
    }
    

}
