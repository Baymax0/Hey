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

    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]

    @IBOutlet weak var lineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:)))
        self.view.addGestureRecognizer(pan)

        lineChart.delegate = self
        lineChart.dragEnabled = false
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        lineChart.xAxis.enabled = false
        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawAxisLineEnabled = false
        setChart(months, values: unitsSold)
    }

    //设置charts方法
    func setChart(_ dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let set = LineChartDataSet(values: dataEntries, label: "")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 1.8
        set.circleRadius = 4
        set.setCircleColor(.white)
        set.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set.fillColor = .white
        set.fillAlpha = 1
        set.drawHorizontalHighlightIndicatorEnabled = false
        lineChart.data = LineChartData(dataSet: set)
        //添加显示动画
        lineChart.animate(xAxisDuration: 3)
    }

    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
