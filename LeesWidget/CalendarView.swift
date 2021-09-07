//
//  CalendarView.swift
//  Hey
//
//  Created by 李志伟 on 2020/6/29.
//  Copyright © 2020 baymax. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SmallView : View {
    @State var date: Date = Date()
        
    var dayArr:Array<Array<String>>{
        return getDayArr()
    }
    
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
            
            VStack(alignment:.leading, spacing:6){
                HStack{
                    Text(date.monthString+"月")
                        .font(.system(size: 13, weight: .bold, design: .default))
                        .foregroundColor(.red)
                    Text(date.toString("HH:mm:ss"))
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(.red)
                        .offset(x: 40)
                        .onReceive(timer, perform: { _ in
                            date = Date()
                            print(date.toString())
                        })
                }
                
                ForEach(0..<dayArr.count,id:\.self){ i in
                    HStack(spacing:5){
                        ForEach(0..<dayArr[i].count,id:\.self){ j in
                            Text(dayArr[i][j])
                                .frame(width: 15, alignment: .center)
    //                            .background(Color.blue)
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(getColor(i, j))
                        }
                    }
                }
            }
        }
        
    }
    
    func getColor(_ i:Int, _ j:Int) -> Color {
        if dayArr[i][j] == date.dayString{
            return .red
        }else if j < 5{
            return .black
        }
        return .gray
    }
    
    init(_ date: Date) {
//        self.date = date
    }
    
    func getDayArr() -> Array<Array<String>>{
        var arr : Array<Array<String>> = []
        arr.append(["一","二","三","四","五","六","七"])
        let w = date.addTime(TimeInterval(-1 * (date.dayString.toInt()-1) * 86400)).weekend
        let dayArr = [31,28,31,30,31,30,31,31,30,31,30,31]
        let dayNum = dayArr[date.monthString.toInt()-1]
        var s = 1
        for _ in 0..<6{
            var temp = Array<String>()
            for _ in 0..<7{
                if s < w{
                    temp.append(" ")
                }else if s > w + dayNum - 1{
                    temp.append(" ")
                }else{
                    let str = (s - w + 1).toString() ?? " "
                    temp.append(str)
                }
                s += 1
            }
            arr.append(temp)
            if s > w + dayNum - 1{
                break
            }
        }
        return arr
    }
}

struct MediumView  : View {
    var date: Date
    var body: some View {
        HStack{
            SmallView(date)
            VStack{
                Text("123")
                    .font(.system(size: 12))
                Text("aa3")
                    .font(.system(size: 12))
            }
        }
    }
    init(_ date: Date) {
        self.date = date
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SmallView(Date())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MediumView(Date())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
        
    }
}


