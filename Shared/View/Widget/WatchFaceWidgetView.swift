//
//  WatchFaceWidgetView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/29.
//

import SwiftUI
import WidgetKit

struct WatchFaceWidgetView: View {
    
    var body: some View {
        GeometryReader { geometry in
            let percent = 0.5
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                Color.black
                ZStack {
                    Group {
                        Circle().fill(Color.white)
                        ClockMarkView(60) { index in
                            Rectangle()
                                .fill(Color.secondary)
                                .frame(width: minLength * 0.008, height: minLength * 0.03, alignment: .center)
                        }
                        ClockMarkView(12) { index in
                            Rectangle()
                                .fill(Color.black)
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
                    .frame(width: minLength * 0.8)
                    Group {
                        ClockTemplateCornerGaugeImageView(percent: 0.5, color: .blue, position: .topLeading, leadingText: Text("0"), trailingText: Text("100")) { value in
                            Image(systemName: "speaker.wave.2")
                                .resizable()
                                .foregroundColor(.blue)
                        }
                        ClockTemplateCornerGaugeImageView(percent: 0.7, color: .orange, position: .topTrailing, leadingText: Text("0"), trailingText: Text("100")) { value in
                            Image(systemName: "sun.max")
                                .foregroundColor(.orange)
                        }
                        ClockTemplateCornerGaugeTextView(percent: 0.25, color: .yellow, position: .bottomLeading, text: Text("63%"))
                        ClockTemplateCornerGaugeTextView(percent: 0.25, color: .green, position: .bottomTrailing, text: Text("63%"))
                    }
                    ClockFuncView(top: AnyView(CircularClosedGaugeTextView(gaugeProvider: CircularClosedGaugeView(percent, color: .green),
                                                                              centerTextProvider: Text("\(Int(percent * 100))%"))),
                                  bottom: AnyView(CircularOpenGaugeSimpleTextView(gaugeProvider: CircularOpenGradientGaugeView(percent,
                                                                                                                               colors: [.green, .yellow, .orange, .pink, .purple]),
                                                                                 centerTextProvider: Text("345555"),
                                                                                 bottomTextProvider: Text("AQI"))),
                                  left: AnyView(CircularOpenGaugeRangeTextView(gaugeProvider: CircularOpenGradientGaugeRangeView(percent,
                                                                                                                                 colors: [.blue, .green, .yellow, .orange, .pink, .red]),
                                                                               leadingTextProvider: Text("24"),
                                                                               centerTextProvider: Text("28°C"),
                                                                               trailingTextProvider: Text("31"))),
                                  right: AnyView(CircularOpenGaugeImageTextView(gaugeProvider: CircularOpenGaugeView(percent, color:  .pink),
                                                                                centerTextProvider: Text("\(String(format: "%.2f", percent))"),
                                                                                bottomImageProvider: { Image(systemName: "heart.fill").resizable().foregroundColor(.pink) })))
                        .frame(width: minLength * 0.6, height: minLength * 0.6, alignment: .center)
                    Group {
                        ClockNeedleView(Date(), for: .hour) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 5, height: 40, alignment: .center)
                        }
                        ClockNeedleView(Date(), for: .minute) {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 3, height: 50, alignment: .center)
                        }
                        ClockNeedleView(Date(), for: .second) {
                            Rectangle()
                                .fill(Color.pink)
                                .frame(width: 3, height: 60, alignment: .center)
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
    }
}
