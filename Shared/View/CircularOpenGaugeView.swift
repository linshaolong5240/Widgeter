//
//  CircularOpenGaugeView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/30.
//

import SwiftUI

struct CircularClosedGaugeView: View {
    let percent: Double
    let color: Color

    init(_ percent: Double, color: Color = .accentColor) {
        self.color = color
        self.percent = percent
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let strokeLineWidth = minLength * 0.1
            let radius = (minLength - strokeLineWidth) / 2.0
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
            }
            .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * percent), clockwise: false)
            }
            .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
    }
}

struct CircularClosedGaugeTextView: View {
    let percent: Double
    let color: Color
    let centerTextPrivider: Text

    init(_ percent: Double,
         color: Color = .accentColor,
         centerTextPrivider: Text
         ) {
        self.color = color
        self.percent = percent
        self.centerTextPrivider = centerTextPrivider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularClosedGaugeView(percent, color: color)
                centerTextPrivider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1).frame(width: minLength * 0.8)
            }
        }
    }
}

struct CircularOpenGaugeView: View {
    let percent: Double
    let color: Color

    init(_ percent: Double, color: Color = .accentColor) {
        self.color = color
        self.percent = percent
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let strokeLineWidth = minLength * 0.1
            let radius = (minLength - strokeLineWidth) / 2.0
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(135), endAngle: .degrees(405), clockwise: false)
            }
            .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(135), endAngle: .degrees(135 + 270 * percent), clockwise: false)
            }
            .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
    }
}

struct CircularOpenGaugeImageTextView<Content: View>: View {
    let percent: Double
    let color: Color
    let centerTextPrivider: Text
    let bottomImagePrivider: (_ value: Double) -> Content

    init(_ percent: Double,
         color: Color = .accentColor,
         centerTextPrivider: Text,
         @ViewBuilder bottomImagePrivider: @escaping (_ value: Double) -> Content
         ) {
        self.color = color
        self.percent = percent
        self.centerTextPrivider = centerTextPrivider
        self.bottomImagePrivider = bottomImagePrivider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGaugeView(percent, color: color)
                centerTextPrivider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1).frame(width: minLength * 0.8)
                VStack {
                    Spacer()
                    bottomImagePrivider(percent)
                        .frame(width: minLength / 5.0, height: minLength / 5.0)
                }
            }
        }
    }
}

struct CircularOpenGaugeRangeView: View {
    let percent: Double
    let color: Color

    init(_ percent: Double, color: Color = .accentColor) {
        self.percent = percent
        self.color = color
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let strokeLineWidth = minLength * 0.1
            let radius = (minLength - strokeLineWidth) / 2.0
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(150), endAngle: .degrees(30), clockwise: false)
            }
            .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            Path { path in
                path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(150), endAngle: .degrees(150 + 240 * percent), clockwise: false)
            }
            .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
    }
}

struct CircularOpenGaugeRangeTextView: View {
    let percent: Double
    let color: Color
    let leadingTextPrivider: Text
    let centerTextPrivider: Text
    let trailingPrivider: Text
    
    init(_ percent: Double,
         color: Color = .accentColor,
         leadingTextPrivider: Text,
         centerTextPrivider: Text,
         trailingTextPrivider: Text) {
        self.percent = percent
        self.color = color
        self.leadingTextPrivider = leadingTextPrivider
        self.centerTextPrivider = centerTextPrivider
        self.trailingPrivider = trailingTextPrivider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGaugeRangeView(percent, color: color)
                ZStack {
                    VStack {
                        Spacer()
                        HStack{
                            leadingTextPrivider.font(.system(size: minLength / 6)).minimumScaleFactor(0.1).lineLimit(1)
                            Spacer()
                            trailingPrivider.font(.system(size: minLength / 6)).minimumScaleFactor(0.1).lineLimit(1)
                        }
                    }
                    centerTextPrivider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1)
                }
                .frame(width: minLength * 0.7, height: minLength)
            }
        }
    }
}

struct CircularOpenGradientGaugeView: View {
    let percent: Double
    let colors: [Color]

    init(_ percent: Double, colors: [Color] = [.white, .accentColor]) {
        self.percent = percent
        self.colors = colors
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let strokeLineWidth = minLength * 0.1
            let center: CGPoint = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
            let radius = (minLength - strokeLineWidth) / 2.0
            let startAngle: Angle = .degrees(135)
            let endAngle: Angle = .degrees(405)
            ZStack {
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                }
                .stroke(AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(135),
                            endAngle: .degrees(405)), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                VStack {
                    Spacer()
                    Circle().stroke(Color.black, lineWidth: strokeLineWidth / 5.0)
                        .frame(width: strokeLineWidth, height: strokeLineWidth, alignment: .center)
                }
                .rotationEffect(.degrees(45) + (endAngle - startAngle) * percent )
            }
        }
    }
}

struct CircularOpenGradientGaugeImageTextView<Content>: View where Content: View {
    let colors: [Color]
    let percent: Double
    let centerTextPrivider: Text
    let bottomImagePrivider: (_ value: Double) -> Content
    
    init(_ percent: Double,
         colors: [Color],
         centerTextPrivider: Text,
         @ViewBuilder bottomImagePrivider: @escaping (_ value: Double) -> Content) {
        self.percent = percent
        self.colors = colors
        self.centerTextPrivider = centerTextPrivider
        self.bottomImagePrivider = bottomImagePrivider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGradientGaugeView(percent, colors: colors)
                VStack {
                    centerTextPrivider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1).frame(width: minLength * 0.8)
                }
                VStack {
                    Spacer()
                    bottomImagePrivider(percent)
                        .frame(width: minLength / 5.0, height: minLength / 5.0)
                }
            }
        }
    }
}

#if DEBUG
struct CircularOpenGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            let percent = 0.5
            Color.white.ignoresSafeArea()
            VStack {
                CircularClosedGaugeView(percent)
                CircularClosedGaugeTextView(percent, centerTextPrivider: Text("\(Int(percent * 100))%"))
                CircularOpenGaugeView(percent)
                CircularOpenGaugeImageTextView(percent, centerTextPrivider: Text("\(Int(percent * 100))%")) {_ in
                    Image(systemName: "heart.fill").resizable().foregroundColor(.blue)
                }
                CircularOpenGaugeRangeView(percent)
                CircularOpenGaugeRangeTextView(percent,
                                               leadingTextPrivider: Text("24"),
                                               centerTextPrivider: Text("28°C"),
                                               trailingTextPrivider: Text("31"))
//                    .frame(width: 50, height: 50, alignment: .center)
                CircularOpenGradientGaugeView(percent)
                CircularOpenGradientGaugeImageTextView(percent, colors: [.green, .blue, .purple, .red],
                                                   centerTextPrivider: Text("\(String(format: "%.2f", percent))")) {_ in
                    Image(systemName: "heart.fill").resizable().foregroundColor(.blue)
                }
            }
        }
    }
}
#endif
