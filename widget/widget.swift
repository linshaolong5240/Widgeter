//
//  widget.swift
//  widget
//
//  Created by 林少龙 on 2021/6/9.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        #if DEBUG
        MonthWidgetView(date: entry.date)
        #else
        switch entry.configuration.timeType {
        case .time:
            Text(entry.date, style: .time)
        case .timer:
            Text(entry.date, style: .timer)
        case .date:
            Text(entry.date, style: .date)
        case .digital:
            DititalClockView(entry.date)
        case .unknown:
            Text(entry.date, style: .time)
        }
        #endif
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
                    widgetEntryView(entry: WidgetEntry(date: Date(), configuration: ConfigurationIntent()))
                        .previewContext(WidgetPreviewContext(family: .systemSmall))
                    widgetEntryView(entry: WidgetEntry(date: Date(), configuration: ConfigurationIntent()))
                        .previewContext(WidgetPreviewContext(family: .systemMedium))
                    widgetEntryView(entry: WidgetEntry(date: Date(), configuration: ConfigurationIntent()))
                        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
