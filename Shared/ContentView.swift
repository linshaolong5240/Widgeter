//
//  ContentView.swift
//  Shared
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: Store
    private var health: AppState.Health { store.appState.health }
    private var baterry: AppState.Baterry { store.appState.baterry }

    var body: some View {
        VStack {
            MonthView(month: Date()) { date in
                Text(String(Calendar.current.component(.day, from: date)))
                    //            .frame(width: 40, height: 40, alignment: .center)
                    .frame(minWidth: 20, idealWidth: 40, maxWidth: .infinity, minHeight: 20, idealHeight: 40, maxHeight: 40, alignment: .center)
                    .background(
                        Circle()
                            .fill(Calendar.current.isDateInToday(date) ? Color.pink : Color.blue)
                    )
                    .padding(.vertical, 4)
            }
            VStack(alignment: .leading) {
                Text("\(Image(systemName: "figure.walk")) \(health.stepCount) step")
                Text("\(Image(systemName: "figure.walk")) \(health.distanceWalkingRunning) m")
                #if canImport(UIKit)
                BaterryView(baterryLevel: baterry.baterryLevel, baterryStatus: baterry.baterryStatus)
                #endif
                StorageUsageView()
                DititalClockView(Date())
            }
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store.shared)
    }
}
