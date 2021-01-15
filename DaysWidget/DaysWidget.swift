//
//  DaysWidget.swift
//  DaysWidget
//
//  Created by Jiaqi Feng on 1/14/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let defaults = UserDefaults.standard
    
    var content: String{
        return defaults.string(forKey: "widgetContent") ?? "Set content by long pressing on a moment."
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(content: "Placeholder")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(content: content)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //let currentDate = Date()
        for _ in 0 ..< 5 {
            //let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(content: content)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        var timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            WidgetCenter.shared.reloadAllTimelines()
            completion(timeline)
        }
        
        //completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date = Date()
    let content: String
}

struct DaysWidgetEntryView : View {
    var entry: Provider.Entry
    
    
    var body: some View {
        Text(entry.content).padding()
    }
}

@main
struct DaysWidget: Widget {
    let kind: String = "DaysWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DaysWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DaysWidget_Previews: PreviewProvider {
    static var previews: some View {
        DaysWidgetEntryView(entry: SimpleEntry(content:"This is test content"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
