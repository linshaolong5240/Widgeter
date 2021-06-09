//
//  WidgeterApp.swift
//  Shared
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

@main
struct WidgeterApp: App {
    @StateObject private var store: Store = Store.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    store.dispatch(.initAction)
                }
                .environmentObject(store)
        }
    }
}
