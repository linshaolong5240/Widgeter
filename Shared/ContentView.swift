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
        VStack(alignment: .leading) {
            Text("\(Image(systemName: "figure.walk")) \(health.stepCount) step")
            Text("\(Image(systemName: "figure.walk")) \(health.distanceWalkingRunning) m")
            BaterryView(baterryLevel: baterry.baterryLevel, baterryStatus: baterry.baterryStatus)
            StorageUsageView()
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Store.shared)
    }
}
