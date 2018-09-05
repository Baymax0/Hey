//
//  MeVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/8/22.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit

class MeVC: BaseVC {

    var lastWeatherTime :String! = ""
    var ip :String! = nil
    var weatherModel:RealTimeWeatherModel? = nil
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherWenduLab: UILabel!
    @IBOutlet weak var weatherTypeLab: UILabel!
    @IBOutlet weak var weatherQuaLab: UILabel!
    @IBOutlet weak var weatherTypeImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()


        weatherModel = BMCache.getModel(.WeatherInfo, type: RealTimeWeatherModel.self)
        loadWeatherMod()

        requestWeather()
    }

    //查询实时天气
    func requestWeather() ->  Void{
        if ip == nil {
            //获取ip地址
            Network.requiredIP { (ip) in
                self.ip = ip
                if self.ip == nil{
                    HUD.text("ip获取失败")
                }else{
                    self.requestWeather()
                }
            }
            return
        }
        let now = Date().toString("yyyy-MM-dd-HH")
        if now != lastWeatherTime{
            //请求天气
            Network.requesrCurrentWeather(address: ip!) { (mod) in
                if mod != nil{
                    self.weatherModel = mod
                    self.loadWeatherMod()
                    BMCache.set(.WeatherInfo, value: mod)
                    self.lastWeatherTime = now
                }
            }
        }
    }

    //加载天气信息
    func loadWeatherMod() -> Void {
        guard self.weatherModel != nil else {
            return
        }
        self.weatherWenduLab.text = (weatherModel?.temp_curr)! + "°"
        let type = (weatherModel?.citynm)! + " " + (weatherModel?.weather_curr)!
        self.weatherTypeLab.text = type
        let pm:Int! = Int((weatherModel?.aqi)!)
        var att : NSMutableAttributedString!
        if pm < 50{
            att = NSMutableAttributedString(string: String(format: "空气优 %@", (weatherModel?.aqi)!))
            att.addAttribute(.foregroundColor, value: KGreen_Light, range: NSRange(location: 0, length: att.length))
        }else if pm < 100{
            att = NSMutableAttributedString(string: String(format: "空气良 %@", (weatherModel?.aqi)!))
            att.addAttribute(.foregroundColor, value: KGreen_Light, range: NSRange(location: 0, length: att.length))
        }else {
            att = NSMutableAttributedString(string: String(format: "空气差 %@", (weatherModel?.aqi)!))
            att.addAttribute(.foregroundColor, value: KRed, range: NSRange(location: 0, length: att.length))
        }
        att.addAttribute(.font, value: UIFont(name: "AvenirNext-DemiBold", size: 11) ?? UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: att.length))
        att.addAttribute(.foregroundColor, value: KBlack_178, range: NSRange(location: 0, length: 3))
        att.addAttribute(.font, value: UIFont.systemFont(ofSize: 11), range: NSRange(location: 0, length: 3))
        self.weatherQuaLab.attributedText = att
        if let img = weatherModel?.weather_curr.image{
            self.weatherTypeImg.image = img
        }
    }

    @IBAction func weatherAction(_ sender: Any) {
        let vc = WeatherVC.fromStoryboard() as! WeatherVC
        vc.weatherModel = weatherModel
        present(vc, animated: true, completion: nil)
    }


    @IBAction func faviriteImgAction(_ sender: UIButton) {
        present(FavoriteImgVC.fromStoryboard(), animated: true, completion: nil)

    }

    @IBAction func clearAction(_ sender: Any) {
        BMCache.clear()
    }


}
