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

    @IBOutlet weak var nowWenduLab: UILabel!

    var weatherArr = Array<RealTimeWeatherModel>()

    @IBOutlet weak var lineChart: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        self.view.addGestureRecognizer(pan)

        self.nowWenduLab.text = (weatherModel?.temp_curr)! + "°"

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
    }

    func request() -> Void {
        Network.requestFutureWeather(address: (weatherModel?.citynm)!) { (mod) in
            if let temp = mod?.result{
                self.weatherArr = temp
                self.setChart()
            }
        }
    }

    //设置charts方法
    func setChart() {
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []

        for i in 0..<weatherArr.count {
            let high = getTemp(weatherArr[i].temp_high)
            let dataEntry = ChartDataEntry(x: Double(i), y: high)
            dataEntries.append(dataEntry)

            let low = getTemp(weatherArr[i].temp_low)
            let dataEntry2 = ChartDataEntry(x: Double(i), y: low)
            dataEntries2.append(dataEntry2)
        }


        let set = LineChartDataSet(values: dataEntries, label: "")
        set.mode = .horizontalBezier
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
        set2.mode = .horizontalBezier
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
        lineChart.animate(yAxisDuration: 0)
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


