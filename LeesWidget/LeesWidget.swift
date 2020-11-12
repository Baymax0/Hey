//
//  LeesWidget.swift
//  LeesWidget
//
//  Created by 李志伟 on 2020/11/10.
//  Copyright © 2020 baymax. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
    
//        let minuteOffset = 60 - currentDate.toString("ss").toInt()
//        let minuteOffset = 5
        let nextDate1 = Calendar.current.date(byAdding: .second, value: 5, to: currentDate)!
        let nextDate2 = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!

        let timeline = Timeline(entries: [SimpleEntry(nextDate1),SimpleEntry(nextDate2)], policy:.after(nextDate1))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let myInfo:Date?
    
    init(_ date:Date) {
        self.date = date
        self.myInfo = date
    }
}

struct PlaceholderView : View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        HStack{
            switch family {
            case .systemSmall: SmallView(Date(timeIntervalSince1970: 0))
            case .systemMedium: MediumView(Date(timeIntervalSince1970: 0))
            case .systemLarge: MediumView(Date(timeIntervalSince1970: 0))
            default: SmallView(Date(timeIntervalSince1970: 0))
            }
        }
    }
}

struct myWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        
        HStack{
            switch family {
            case .systemSmall: SmallView(entry.date)
            case .systemMedium: MediumView(entry.date)
            case .systemLarge: MediumView(entry.date)
            default: SmallView(entry.date)
            }
        }
    }
}

@main
struct LeesWidget: Widget {
    private let kind: String = "myWidget"

    public var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { (entry) -> myWidgetEntryView in
            return myWidgetEntryView(entry: entry)
        }
//        .configurationDisplayName("我的组件")
//        .description("日历")
    }
}

//struct LeesWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        myWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
