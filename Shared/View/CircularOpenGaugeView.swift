//
//  CircularOpenGaugeView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/30.
//

import SwiftUI

@available(iOS, deprecated: 14, message: "This patch should no longer be needed when when dropping iOS 13 support")
struct GeometryReaderPatched<Content: View>: View {
    public var content: (GeometryProxy) -> Content

    @inlinable public init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { geometryProxy in
            content(geometryProxy)
                .frame(width: geometryProxy.size.width,
                       height: geometryProxy.size.height,
                       alignment: .top)
        }
    }
}

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
            ZStack {
                Path { path in
                    path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                }
                .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                Path { path in
                    path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * percent), clockwise: false)
                }
                .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            }
            .frame(width: minLength - strokeLineWidth, height: minLength - strokeLineWidth)
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
            ZStack {
                Path { path in
                    path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(120), endAngle: .degrees(60), clockwise: false)
                }
                .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                Path { path in
                    path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: .degrees(120), endAngle: .degrees(120 + 300 * percent), clockwise: false)
                }
                .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            }
            .frame(width: minLength - strokeLineWidth, height: minLength - strokeLineWidth)
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
            ZStack {
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
}

struct CircularOpenGaugeRangeTextView: View {
    let percent: Double
    let color: Color
    let leadingTextPrivider: (_ value: Double) -> Text
    let trailingPrivider: (_ value: Double) -> Text
    
    init(_ percent: Double,
         color: Color = .accentColor,
         @ViewBuilder leadingTextPrivider: @escaping (_ value: Double) -> Text,
         @ViewBuilder trailingTextPrivider: @escaping (_ value: Double) -> Text) {
        self.percent = percent
        self.color = color
        self.leadingTextPrivider = leadingTextPrivider
        self.trailingPrivider = trailingTextPrivider
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
            ZStack {
                ZStack {
                    VStack {
                        Spacer()
                        HStack{
                            leadingTextPrivider(percent).font(.system(size: minLength / 6)).minimumScaleFactor(0.1)
                            Spacer()
                            trailingPrivider(percent).font(.system(size: minLength / 6)).minimumScaleFactor(0.1)
                        }
                    }
                }
                .frame(width: minLength, height: minLength)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
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
            let startAngle: Angle = .degrees(120)
            let endAngle: Angle = .degrees(420)
            ZStack {
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                }
                .stroke(AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(120),
                            endAngle: .degrees(420)), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                VStack {
                    Spacer()
                    Circle().stroke(Color.black, lineWidth: strokeLineWidth / 5.0)
                        .frame(width: strokeLineWidth, height: strokeLineWidth, alignment: .center)
                }
                .rotationEffect(.degrees(30) + (endAngle - startAngle) * percent )
            }
        }
    }
}

struct CircularOpenGradientGaugeImageView<Content>: View where Content: View {
    let colors: [Color]
    let percent: Double
    let centerTextPrivider: (_ value: Double) -> Text
    let bottomPrivider: (_ value: Double) -> Content
    
    init(_ percent: Double,
         colors: [Color],
         @ViewBuilder centerTextPrivider: @escaping (_ value: Double) -> Text,
         @ViewBuilder bottomImagePrivider: @escaping (_ value: Double) -> Content) {
        self.percent = percent
        self.colors = colors
        self.centerTextPrivider = centerTextPrivider
        self.bottomPrivider = bottomImagePrivider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGradientGaugeView(percent, colors: colors)
                VStack {
                    Spacer()
                    bottomPrivider(percent)
                        .frame(width: minLength / 5.0, height: minLength / 5.0)
                }
                VStack {
                    centerTextPrivider(percent)
                }
            }
        }
    }
}

#if DEBUG
struct CircularOpenGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
//                CircularClosedGaugeView(0.5)
//                CircularOpenGaugeView(0.7)
                CircularOpenGaugeRangeView(0.7)
                CircularOpenGaugeRangeTextView(0.7,
                                               leadingTextPrivider: {value in Text("24")},
                                               trailingTextPrivider: {value in Text("31")})
//                    .frame(width: 50, height: 50, alignment: .center)
//                CircularOpenGradientGaugeView(0.7)
//                CircularOpenGradientGaugeImageView(0.25, colors: [.green, .blue, .purple, .red],
//                                           centerTextPrivider: {value in Text("\(String(format: "%.2f", value))")}) {_ in
//                    Image(systemName: "heart.fill").resizable().foregroundColor(.blue)
//                }
            }
        }
    }
}
#endif
