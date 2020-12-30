//
//  CachSettingVC.swift
//  Lee
//
//  Created by 李志伟 on 2020/10/14.
//  Copyright © 2020 baymax. All rights reserved.
//

import UIKit

class BMCacheBackUp {
    
    class BackUpModel: HandyJSON {
        
        var timeStamp   : TimeInterval!
        var data        :Dictionary<String, Any>!
        required init(){}
    }
    
//    let `default` = BMCacheBackUp()
    
//    let kvoStore = NSUbiquitousKeyValueStore.default
    
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
        }
        let model = BackUpModel.deserialize(from: jsonStr)
        return model
    }
}


class CachSettingVC: BaseVC {
    
    var keyStore:NSUbiquitousKeyValueStore!

    @IBOutlet weak var fileSaveTimeLab: UILabel!
    @IBOutlet weak var icloudSaveTimeLab: UILabel!
    
    var fileBackUpModel:BMCacheBackUp.BackUpModel?
    var icloudBackUpModel:BMCacheBackUp.BackUpModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
    }
    
    func loadData() {
        Hud.showWait()
        
        fileBackUpModel = BMCacheBackUp.getCacheFile()
        icloudBackUpModel = BMCacheBackUp.getICloudFile()
        self.reloadTimeLab()
        Hud.hide()
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        if sender.tag == 0{
            // file
            fileBackUpModel = BMCacheBackUp.saveToFile()
        }else{
            // icloud
            icloudBackUpModel = BMCacheBackUp.saveToICloud()
        }
        self.reloadTimeLab()
    }
    
    func reloadTimeLab() {
        if fileBackUpModel != nil{
            let date = Date(timeIntervalSince1970: fileBackUpModel!.timeStamp)
            fileSaveTimeLab.text = date.toString("MM/dd HH:mm")
        }else{
            fileSaveTimeLab.text = "未归档"
        }
        if icloudBackUpModel != nil{
            let date = Date(timeIntervalSince1970: icloudBackUpModel!.timeStamp)
            icloudSaveTimeLab.text = date.toString("MM/dd HH:mm")
        }else{
            fileSaveTimeLab.text = "未归档"
        }
    }

    @IBAction func downLoadAction(_ sender: UIButton) {
        if sender.tag == 0{
            if fileBackUpModel?.data == nil{ return }
            // file
            showComfirm("提醒", "确认覆盖当前存档吗") {
                
            } complish: {
                Hud.showWait()
                
            }
        }else{
            if icloudBackUpModel?.data == nil{ return }
            // icloud
            showComfirm("提醒", "确认覆盖当前存档吗") {
                
            } complish: {
                Hud.showWait()
                
            }
        }
    }
    

}
