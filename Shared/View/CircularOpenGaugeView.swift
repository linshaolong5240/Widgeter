//
//  CircularOpenGaugeView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/30.
//

import SwiftUI

protocol CircularGaugeProvider: View { }

extension Array where Element == Color {
    func intermediate(percent: CGFloat) -> Color? {
        guard count > 0 else {
            return nil
        }
        guard count != 1 else {
            return first
        }
        switch percent {
        case 0: return first
        case 1: return last
        default:
            let approxIndex = percent / (1 / CGFloat(count - 1))
            let firstIndex = Int(approxIndex.rounded(.down))
            let secondIndex = Int(approxIndex.rounded(.up))
            let fallbackIndex = Int(approxIndex.rounded())

            let firstColor = UIColor(self[firstIndex])
            let secondColor = UIColor(self[secondIndex])
            let fallbackColor = UIColor(self[fallbackIndex])

            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard firstColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return Color(fallbackColor) }
            guard secondColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return Color(fallbackColor) }

            let intermediatePercentage = approxIndex - CGFloat(firstIndex)
            return Color(UIColor(red: CGFloat(r1 + (r2 - r1) * intermediatePercentage),
                                 green: CGFloat(g1 + (g2 - g1) * intermediatePercentage),
                                 blue: CGFloat(b1 + (b2 - b1) * intermediatePercentage),
                                 alpha: CGFloat(a1 + (a2 - a1) * intermediatePercentage)))
        }
    }
}

struct CircularClosedGaugeView: CircularGaugeProvider {
    let percent: Double
    let color: Color

    init(_ percent: Double, color: Color = .accentColor) {
        self.color = color
        self.percent = percent
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
            let strokeLineWidth = minLength * 0.1
            let radius = (minLength - strokeLineWidth) / 2.0
            let startAngle: Angle = .degrees(-90)
            let endAngle: Angle = .degrees(270)
            Path { path in
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            Path { path in
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + (endAngle - startAngle) * percent, clockwise: false)
            }
            .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
        }
    }
}

struct CircularOpenGaugeView: CircularGaugeProvider {
    let percent: Double
    let colors: [Color]
    let startAngle: Angle
    let endAngle: Angle
    
    init(_ percent: Double,
         colors: [Color] = [.accentColor],
         startAngle: Angle = .degrees(135),
         endAngle: Angle = .degrees(405)) {
        self.colors = colors
        self.percent = percent
        self.startAngle = startAngle
        self.endAngle = endAngle
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
            let strokeLineWidth = minLength * 0.1
            let radius = (minLength - strokeLineWidth) / 2.0
            if colors.count == 1 {
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                }
                .stroke(colors[0].opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + (endAngle - startAngle) * percent, clockwise: false)
                }
                .stroke(colors[0], style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            } else {
                ZStack {
                    Path { path in
                        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    }
                    .stroke(AngularGradient(
                                gradient: Gradient(colors: colors),
                                center: .center,
                                startAngle: startAngle,
                                endAngle: endAngle), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                    VStack {
                        Spacer()
                        Circle().stroke(Color.black, lineWidth: strokeLineWidth / 5.0)
                            .frame(width: strokeLineWidth, height: strokeLineWidth, alignment: .center)
                    }
                    .frame(width: minLength, height: minLength, alignment: .center)
                    .rotationEffect((startAngle - .degrees(90)) + (endAngle - startAngle) * percent )
                }
            }
        }
    }
}

struct CircularOpenGaugeRangeView: CircularGaugeProvider {
    let percent: Double
    let colors: [Color]

    init(_ percent: Double, colors: [Color] = [.accentColor]) {
        self.percent = percent
        self.colors = colors
    }
    
    var body: some View {
        CircularOpenGaugeView(percent, colors: colors, startAngle: .degrees(150), endAngle: .degrees(390))
    }
}

struct CircularClosedGaugeTextView<G: CircularGaugeProvider>: View {
    let gaugeProvider: G
    let centerTextProvider: Text

    init(gaugeProvider: G,
         centerTextProvider: Text
         ) {
        self.gaugeProvider = gaugeProvider
        self.centerTextProvider = centerTextProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                gaugeProvider
                centerTextProvider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1).frame(width: minLength * 0.8)
            }
        }
    }
}
struct CircularOpenGaugeSimpleTextView: View {
    let percent: Double
    let colors: [Color]
    let centerTextProvider: Text
    let bottomTextProvider: Text
    
    init(_ percent: Double,
         colors: [Color],
         centerTextProvider: Text,
         bottomTextProvider: Text) {
        self.percent = percent
        self.colors = colors
        self.centerTextProvider = centerTextProvider
        self.bottomTextProvider = bottomTextProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGaugeView(percent, colors: colors)
                ZStack {
                    centerTextProvider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1)
                    VStack {
                        Spacer()
                        bottomTextProvider
                            .lineLimit(1)
                            .font(.system(size: minLength / 4))
                            .minimumScaleFactor(0.1)
                            .foregroundColor(colors.intermediate(percent: CGFloat(percent)))
                    }
                }
                .frame(width: minLength * 0.6, height: minLength)
            }
        }
    }
}

struct CircularOpenGaugeRangeTextView: View {
    let percent: Double
    let colors: [Color]
    let leadingTextProvider: Text
    let centerTextProvider: Text
    let trailingProvider: Text
    
    init(_ percent: Double,
         colors: [Color],
         leadingTextProvider: Text,
         centerTextProvider: Text,
         trailingTextProvider: Text) {
        self.percent = percent
        self.colors = colors
        self.leadingTextProvider = leadingTextProvider
        self.centerTextProvider = centerTextProvider
        self.trailingProvider = trailingTextProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGaugeRangeView(percent, colors: colors)
                ZStack {
                    VStack {
                        Spacer()
                        HStack{
                            leadingTextProvider
                                .lineLimit(1)
                                .font(.system(size: minLength / 6))
                                .minimumScaleFactor(0.1)
                                .foregroundColor(colors.first)

                            Spacer(minLength: 0)
                            trailingProvider
                                .lineLimit(1)
                                .font(.system(size: minLength / 6))
                                .minimumScaleFactor(0.1)
                                .foregroundColor(colors.last)
                        }
                        .padding([.horizontal, .bottom], minLength / 10.0)
                    }
                    centerTextProvider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1)
                }
                .frame(width: minLength * 0.7, height: minLength)
            }
        }
    }
}

struct CircularOpenGaugeImageView: View {
    let percent: Double
    let colors: [Color]
    let centerTextProvider: Text
    let bottomImageProvider: Image

    init(_ percent: Double,
         colors: [Color],
         centerTextProvider: Text,
         bottomImageProvider: Image
         ) {
        self.percent = percent
        self.colors = colors
        self.centerTextProvider = centerTextProvider
        self.bottomImageProvider = bottomImageProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                CircularOpenGaugeView(percent, colors: colors)
                centerTextProvider.font(.system(size: minLength / 4)).minimumScaleFactor(0.1).lineLimit(1).frame(width: minLength * 0.8)
                VStack {
                    Spacer()
                    bottomImageProvider
                        .resizable()
                        .foregroundColor(colors.intermediate(percent: CGFloat(percent)))
                        .frame(width: minLength / 5.0, height: minLength / 5.0)
                }
                .frame(width: minLength, height: minLength)
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
//            VStack {
//                CircularClosedGaugeTextView(gaugeProvider: CircularClosedGaugeView(percent), centerTextProvider: Text("\(Int(percent * 100))%"))
//                CircularOpenGaugeSimpleTextView(gaugeProvider: CircularOpenGaugeView(percent),
//                                                centerTextProvider: Text("345555"),
//                                                bottomTextProvider: Text("AQI"))
//                CircularOpenGaugeRangeTextView(gaugeProvider: CircularOpenGaugeRangeView(percent),
//                                               leadingTextProvider: Text("24"),
//                                               centerTextProvider: Text("28°C"),
//                                               trailingTextProvider: Text("31"))
//                CircularOpenGaugeRangeTextView(gaugeProvider: CircularOpenGradientGaugeRangeView(percent,
//                                                                                                 colors: [.blue, .green, .yellow, .orange, .pink, .red]),
//                                               leadingTextProvider: Text("24"),
//                                               centerTextProvider: Text("28°C"),
//                                               trailingTextProvider: Text("31"))
//                CircularOpenGaugeImageTextView(gaugeProvider: CircularOpenGaugeView(percent),
//                                               centerTextProvider: Text("\(Int(percent * 100))%"),
//                                               bottomImageProvider: { Image(systemName: "heart.fill").resizable().foregroundColor(.pink) })
//                CircularOpenGaugeImageTextView(gaugeProvider: CircularOpenGradientGaugeView(percent,
//                                                                                            colors: [.blue, .green, .yellow, .orange, .pink, .red]),
//                                               centerTextProvider: Text("\(String(format: "%.2f", percent))"),
//                                               bottomImageProvider: { Image(systemName: "heart.fill").resizable().foregroundColor(.pink) })
//            }
//            .frame(width: 50)
            
            ClockFunctionView(top: AnyView(CircularClosedGaugeTextView(gaugeProvider: CircularClosedGaugeView(percent),
                                                                   centerTextProvider: Text("\(Image(systemName: "battery.100.bolt"))\(Int(percent * 100))%"))),
                          bottom: AnyView(CircularOpenGaugeSimpleTextView(0.05,
                                                                          colors: [.blue, .green, .yellow, .orange, .pink, .red],
                                                                          centerTextProvider: Text("345555"),
                                                                          bottomTextProvider: Text("AQI"))),
                          left: AnyView(CircularOpenGaugeRangeTextView(percent,
                                                                       colors: [.blue, .green, .yellow, .orange, .pink, .red],
                                                                       leadingTextProvider: Text("24"),
                                                                       centerTextProvider: Text("28°C"),
                                                                       trailingTextProvider: Text("31"))),
                          right: AnyView(CircularOpenGaugeImageView(0.3, colors: [.pink],
                                                                        centerTextProvider: Text("75"),
                                                                        bottomImageProvider: Image(systemName: "heart.fill"))))
                .environment(\.colorScheme, .light)
//                .frame(width: 100, height: 100, alignment: .center)
        }
    }
}
#endif

struct ClockFunctionView: View {
    let top: AnyView
    let bottom: AnyView
    let left: AnyView
    let right: AnyView
    
    init(top: AnyView,
         bottom: AnyView,
         left: AnyView,
         right: AnyView) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
    }

    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                ZStack {
                    VStack {
                        top
//                            .background(Circle().fill(Color.black))
                        Spacer()
                            .frame(height: minLength / 3.0)
                        bottom
//                            .background(Circle().fill(Color.black))
                    }
                    HStack {
                        left
//                            .background(Circle().fill(Color.black))
                        Spacer()
                            .frame(width: minLength / 3.0)
                        right
//                            .background(Circle().fill(Color.black))
                    }
                }
                .frame(width: minLength, height: minLength, alignment: .center)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}
