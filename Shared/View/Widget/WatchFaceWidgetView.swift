//
//  WatchFaceWidgetView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/29.
//

import SwiftUI
import WidgetKit

struct WatchFaceWidgetView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            let percent = 0.5
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                colorScheme == .light ? Color.white : Color.black
                ZStack {
                    Group {
                        Circle().fill(colorScheme == .light ? Color.black : Color.white)
                        ClockMarkView(60) { index in
                            Rectangle()
                                .fill(colorScheme == .light ? Color.gray : Color.black)
                                .frame(width: minLength * 0.008, height: minLength * 0.03, alignment: .center)
                        }
                        ClockMarkView(12) { index in
                            Rectangle()
                                .fill(colorScheme == .light ? Color.white : Color.black)
                                .frame(width: minLength * 0.01, height: minLength * 0.04, alignment: .center)
                        }
//                        ClockMarkView(12, origin: true) { index in
//                            Text("\(index == 0 ? 12 : index)")
//                                .font(.system(size: 16))
//                                .minimumScaleFactor(0.5)
//                                .foregroundColor(.black)
//                                .frame(width: minLength / 10 , height: minLength / 10)
//                                .padding(.all, 5)
//                        }
                    }
                    .frame(width: minLength * 0.7)
                    Group {
                        CornerGaugeSimpleTextView(0.5,
                                                  colors: [.green],
                                                  position: .topLeading,
                                                  textProvider: Text("50%"))
                        CornerCalendarView(Date(), position: .topTrailing)
                        CornerGaugeSimpleTextView(0.5,
                                                  colors: [.green, .orange, .pink],
                                                  position: .bottomTrailing,
                                                  textProvider: Text("50%"))
                        CornerGaugeImageView(0.8,
                                             colors: [.blue, .purple],
                                             position: .bottomLeading,
                                             leadingTextProvider: Text("0"),
                                             trailingTextProvider: Text("100")) {
                            Image(systemName: "speaker.wave.2").resizable()}
                    }
                    .frame(width: minLength * 0.85, height: minLength * 0.85, alignment: .center)
                    ClockFunctionView(top: AnyView(CircularClosedGaugeTextView(gaugeProvider: CircularClosedGaugeView(percent, color: .green),
                                                                              centerTextProvider: Text("\(Int(percent * 100))%"))),
                                  bottom: AnyView(CircularOpenGaugeSimpleTextView(percent,
                                                                                  colors: [.green, .yellow, .orange, .pink, .purple],
                                                                                 centerTextProvider: Text("345"),
                                                                                 bottomTextProvider: Text("AQI"))),
                                  left: AnyView(CircularOpenGaugeRangeTextView(percent,
                                                                               colors: [.blue, .green, .yellow, .orange, .pink, .red],
                                                                               leadingTextProvider: Text("24"),
                                                                               centerTextProvider: Text("28°C"),
                                                                               trailingTextProvider: Text("31"))),
                                  right: AnyView(CircularOpenGaugeImageView(percent,
                                                                            colors:  [.pink],
                                                                            centerTextProvider: Text("72"),
                                                                            bottomImageProvider: Image(systemName: "heart.fill"))))
                        .frame(width: minLength * 0.6, height: minLength * 0.6, alignment: .center)
                    Group {
                        ClockNeedleView(Date(), for: .hour) {
                            Capsule()
                                .fill(Color.blue)
                                .frame(width: 5, height: minLength * 0.2, alignment: .center)
                        }
                        ClockNeedleView(Date(), for: .minute) {
                            Capsule()
                                .fill(Color.green)
                                .frame(width: 3, height: minLength * 0.25, alignment: .center)
                        }
                        ClockNeedleView(Date(), for: .second) {
                            Capsule()
                                .fill(Color.pink)
                                .frame(width: 3, height: minLength * 0.3, alignment: .center)
                        }
                        Circle()
                            .frame(width: 5, height: 5, alignment: .center)
                    }
                }
                .frame(width: minLength)
            }
        }
    }
}

struct WatchFaceWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WatchFaceWidgetView()
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            WatchFaceWidgetView()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            WatchFaceWidgetView()
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        .environment(\.colorScheme, .dark)
    }
}
