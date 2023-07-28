//
//  DevoteWidget.swift
//  DevoteWidget
//
//  Created by Matteo Buompastore on 28/07/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DevoteWidgetEntryView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    var fontStyle : Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        } else {
            return .system(.headline, design: .rounded)
        }
    }
    
    var entry: Provider.Entry

    var body: some View {
        //Text(entry.date, style: .time)
        
        //MARK: - FAST WAY TO POSITION THE LOGO AND TEXT IN TOP RIGHT CORNER...
//        ZStack(alignment: .topTrailing) {
//            backgroundGradient
//
//            HStack(alignment: .center) {
//                Image("rocket-small")
//                    .resizable()
//                .scaledToFit()
//            }
//            .frame(maxWidth: .infinity)
//
//            Image("logo")
//                .resizable()
//                .frame(width: 36, height: 36)
//                .padding(widgetFamily != .systemLarge ? 12 : 8)
//
//            HStack {
//                VStack {
//                    Spacer()
//                    Text("Just Do It")
//                        .foregroundColor(.white)
//                        .font(.system(.footnote, design: .rounded))
//                        .fontWeight(.bold)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 4)
//                        .background(
//                            Color.black.opacity(0.5)
//                                .blendMode(.overlay)
//                        )
//                        .clipShape(Capsule())
//                    .padding(.top, 120)
//                } //: VSTACK
//                .padding(.bottom)
//            } //: HSTACK
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//        } //: ZSTACK
        
        //MARK: - MORE PRECISE WAY TO POSITION THE LOGO AND TEXT IN TOP RIGHT CORNER
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                    
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36,
                        height: widgetFamily != .systemSmall ? 56 : 36)
                    .padding(.top, widgetFamily != .systemSmall ? 32 : 12)
                    .padding(.trailing, widgetFamily != .systemSmall ? 32 : 12)
                    .offset(
                        x: (geometry.size.width / 2) - 20,
                        y: (geometry.size.height / -2) + 20
                    )
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                
                HStack {
                    Text("Just Do It")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Color.black.opacity(0.5)
                                .blendMode(.overlay)
                        )
                    .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                    
                } //: HSTACK
                .padding()
                .offset(y: (geometry.size.height / 2) - 24)
                
            } //: ZSTACK
        } //: ZSTACK
        
    }
}

struct DevoteWidget: Widget {
    let kind: String = "DevoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DevoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Devote Launcher")
        .description("This is an example widget for the personal task manager app.")
    }
}

struct DevoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
