//
//  DaysCountdownView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/28.
//

import SwiftUI

fileprivate func getDaysCountdown(month: Int, day: Int, date: Date) -> (daysLeft: Int, targetDate: Date) {
    var targetCom = DateComponents()
    targetCom.month = month
    targetCom.day = day
    let nowCom = Calendar.current.dateComponents([.year, .month, .day], from: date)
    
    targetCom.year = (nowCom.month! >= targetCom.month! && nowCom.day! > targetCom.day!) == true ? nowCom.year! + 1 : nowCom.year
    let daysLeft = Calendar.current.dateComponents([.day], from: nowCom, to: targetCom).day ?? 0
    let targetDate = Calendar.current.date(from: targetCom)!
    return (daysLeft, targetDate)
}

struct DaysCountdownView: View {
    let month: Int = 6
    let day: Int = 28
    
    var body: some View {
        VStack {
            Text(getDaysCountdown(month: month, day: day, date: Date()).targetDate, style: .date)
            Text("\(getDaysCountdown(month: month, day: day, date: Date()).daysLeft) DaysLeft")
        }
    }
}

#if DEBUG
struct daysCountdown_Previews: PreviewProvider {
    static var previews: some View {
        DaysCountdownView()
    }
}
#endif
