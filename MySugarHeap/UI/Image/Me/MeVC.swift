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
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherWenduLab: UILabel!
    @IBOutlet weak var weatherTypeLab: UILabel!
    @IBOutlet weak var weatherQuaLab: UILabel!
    @IBOutlet weak var weatherTypeImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        requestWeather()

    }

    //查询实时天气
    func requestWeather() ->  Void{
        if ip == nil {
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
        //以小时为单位刷新
        if now != lastWeatherTime{
            Network.requesrCurrentWeather(address: ip!) { (mod) in
                if mod != nil{
                    self.weatherWenduLab.text = mod?.temp_curr
                    let type = (mod?.citynm)! + " " + (mod?.weather_curr)!
                    self.weatherTypeLab.text = type
                    let pm:Int! = Int((mod?.aqi)!)
                    var att : NSMutableAttributedString!
                    if pm < 50{
                        att = NSMutableAttributedString(string: String(format: "空气优 %@", (mod?.aqi)!))
                        att.addAttribute(.foregroundColor, value: KGreen_Light, range: NSRange(location: 0, length: att.length))
                    }else if pm < 100{
                        att = NSMutableAttributedString(string: String(format: "空气良 %@", (mod?.aqi)!))
                        att.addAttribute(.foregroundColor, value: KGreen_Light, range: NSRange(location: 0, length: att.length))
                    }else {
                        att = NSMutableAttributedString(string: String(format: "空气差 %@", (mod?.aqi)!))
                        att.addAttribute(.foregroundColor, value: KRed, range: NSRange(location: 0, length: att.length))
                    }
                    att.addAttribute(.font, value: UIFont(name: "AvenirNext-DemiBold", size: 11) ?? UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: att.length))
                    att.addAttribute(.foregroundColor, value: KBlack_178, range: NSRange(location: 0, length: 3))
                    att.addAttribute(.font, value: UIFont.systemFont(ofSize: 11), range: NSRange(location: 0, length: 3))
                    self.weatherQuaLab.attributedText = att
                    if let img = mod?.weather_curr.image{
                        self.weatherTypeImg.image = img
                    }
                }
            }
            lastWeatherTime = now
        }

    }

    @IBAction func weatherAction(_ sender: Any) {
        let vc = WeatherVC.fromStoryboard()
        weatherView.hero.id = "v"
        vc.view.hero.id = "v"
        present(vc, animated: true, completion: nil)
    }


    @IBAction func faviriteImgAction(_ sender: UIButton) {
        present(FavoriteImgVC.fromStoryboard(), animated: true, completion: nil)

    }

    @IBAction func clearAction(_ sender: Any) {
        BMCache.clear()
    }


}
