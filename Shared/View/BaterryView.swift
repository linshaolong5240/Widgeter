//
//  BaterryView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

struct BaterryView: View {
    let baterryLevel: Float
    let baterryStatus: UIDevice.BatteryState
    let showPercent: Bool = true
    
    var body: some View {
        HStack {
            switch baterryStatus {
            case .unknown: Image(systemName: "battery.0")
            case .unplugged: ZStack {
                Image(systemName: "battery.0")
                    .background(
                        GeometryReader { geometry in
                            if baterryLevel >= 0 {
                                let width: CGFloat = geometry.size.width - 11
//                                let tPaddingOffset = (width - 11) * baterryLevel
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(baterryLevel > 0.25 ? Color.green : Color.yellow)
                                    .frame(width: width * CGFloat(baterryLevel))
                                    .padding(.vertical, 3)
                                    .padding([.leading], 4)
                                    .padding([.trailing], 7)
                            }
                        }
                    )
            }
            case .charging: Image(systemName: "battery.100.bolt")
            case .full: Image(systemName: "battery.100")
            @unknown default: Image(systemName: "battery.0")
            }
            if showPercent {
                if baterryLevel >= 0 {
                    Text("\(Int(baterryLevel * 100))%")
                }else {
                    Text("0%")
                }
            }
        }
    }
}

#if DEBUG
struct BaterryView_Previews: PreviewProvider {
    static var previews: some View {
        BaterryView(baterryLevel: 0.2, baterryStatus: .unplugged)
    }
}
#endif
