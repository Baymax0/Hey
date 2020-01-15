//
//  WeatherVC.swift
//  MySugarHeap
//
//  Created by lzw on 2018/9/3.
//  Copyright © 2018 lizhiwei. All rights reserved.
//

import UIKit
import Charts


class WeatherVC: BaseVC , ChartViewDelegate {

    var weatherModel:RealTimeWeatherModel? = nil

    var futureWeather:WeatherBase2! = nil

    @IBOutlet weak var nowWenduLab: UILabel!

    @IBOutlet weak var lineChart: LineChartView!

    @IBOutlet weak var historyBGView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        self.view.addGestureRecognizer(pan)

        request()

        lineChart.delegate = self
        lineChart.dragEnabled = false//不可拖动
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.legend.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.chartDescription?.text = ""
        lineChart.xAxis.enabled = false
        lineChart.leftAxis.spaceTop = 0.15
        lineChart.leftAxis.spaceBottom = 0.05


        lineChart.noDataText = ""

        let bgGradient = CAGradientLayer()
        bgGradient.colors = [KRGB(86, 147, 168).cgColor,
                             KRGB(81, 156, 236).cgColor]
        bgGradient.locations = [0.0, 0.55]
        bgGradient.startPoint = CGPoint(x: 0, y: 0)
        bgGradient.endPoint = CGPoint(x: 0, y: 1)
        bgGradient.frame = view.bounds
        let temp = UIView(frame: view.bounds)
        temp.layer.addSublayer(bgGradient)
        view.insertSubview(temp, at: 0)

        let gradientColors = [UIColor.init(white: 0, alpha: 0).cgColor,
                              UIColor.init(white: 0, alpha: 0).cgColor,
                              UIColor.init(white: 0, alpha: 0.5).cgColor,

                              UIColor.init(white: 0, alpha: 0.5).cgColor,
                              UIColor.init(white: 0, alpha: 1).cgColor,

                              UIColor.init(white: 0, alpha: 1).cgColor,
                              UIColor.init(white: 0, alpha: 0).cgColor,
                              UIColor.init(white: 0, alpha: 0).cgColor,]
        let gradientLocations:[NSNumber] = [0.0, 0.08, 0.09,
                                            0.19,0.25,
                                            0.91, 0.92, 1.0]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.lineChart.bounds
        lineChart.layer.mask = gradientLayer
    }

    func request() -> Void {
        if weatherModel == nil{
            return
        }
        self.nowWenduLab.text = (weatherModel?.temp_curr)! + "°"
        futureWeather = BMCache.getModel(.futureWeather, type: WeatherBase3.self)

        if futureWeather != nil && futureWeather.date != nil{
            if Date().toString("yyyyMMdd") == futureWeather.date{
                self.setChart()
                return
            }
        }

        Network.requestFutureWeather(address: (weatherModel?.citynm)!) { (mod) in
            if let _ = mod?.result{
                if let f = mod{
                    self.futureWeather = f
                    BMCache.set(.futureWeather, value: self.futureWeather)
                    self.setChart()
                }
            }
        }
    }

    //设置charts方法
    func setChart() {
        var weatherArr = futureWeather.result
        if weatherArr.count == 0{
            return
        }

        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []

        weatherArr.insert(weatherArr.first!, at: 0)
        weatherArr.append(weatherArr.last!)

        for i in 0..<weatherArr.count {
            let high = getTemp(weatherArr[i].high)
            let dataEntry = ChartDataEntry(x: Double(i), y: high)
            dataEntries.append(dataEntry)

            let low = getTemp(weatherArr[i].low)
            let dataEntry2 = ChartDataEntry(x: Double(i), y: low)
            dataEntries2.append(dataEntry2)
        }


        let set = LineChartDataSet(values: dataEntries, label: "")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = true//显示数值
        set.valueFont = UIFont(name: "Avenir", size: 11)!
        set.valueTextColor = .white
        set.valueFormatter = MyProticle()
        set.lineWidth = 1
        set.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set.fillColor = .white
        set.fillAlpha = 1
        set.setDrawHighlightIndicators(false)

        let set2 = LineChartDataSet(values: dataEntries2, label: "")
        set2.mode = .cubicBezier
        set2.drawCirclesEnabled = false
        set2.drawValuesEnabled = true//显示数值
        set2.valueTextColor = .white
        set2.valueFormatter = MyProticle()
        set2.valueFont = UIFont(name: "Avenir", size: 11)!
        set2.lineWidth = 1
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.fillColor = .white
        set2.fillAlpha = 1
        set2.setDrawHighlightIndicators(false)

        lineChart.data = LineChartData(dataSets: [set, set2])
        //添加显示动画
        lineChart.animate(yAxisDuration: 1)

        //
        for v in historyBGView.subviews{
            let mod = weatherArr[v.tag]
            let img = v.viewWithTag(11) as! UIImageView
            let lab = v.viewWithTag(12) as! UILabel
            img.image = mod.type.image
            if v.tag == 1{
                lab.text = "昨"
            }else if v.tag == 2{
                lab.text = "今"
            }else{
                let s = mod.date.components(separatedBy: "星期").last
                lab.text = "周\(s!)"
            }
            let w = KScreenWidth/7
            img.alpha = 1
            lab.alpha = 1
            img.frame = CGRect(x: 8, y: 0, width: w-16, height: w-16)
            lab.frame = CGRect(x: 0, y: w, width: w, height: 22)
            let t:Double = 0.6 + Double(v.tag) * 0.1
            v.y = v.y + 30
            UIView.animate(withDuration: t, delay: 0.5, options: .curveEaseInOut, animations: {
                v.y = v.y - 30
            }, completion: nil)
        }
    }

    func getTemp(_ str:String) -> Double {
        var res = str.replacingOccurrences(of: "高温 ", with: "")
        res = res.replacingOccurrences(of: "低温 ", with: "")
        res = res.replacingOccurrences(of: "℃", with: "")
        return Double(res)!
    }

    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

private class MyProticle: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%d°", Int(value))
    }
}


