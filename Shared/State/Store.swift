//
//  Store.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
import Combine
import HealthKit
import UIKit.UIDevice

class Store: ObservableObject {
    var cancellableSet = Set<AnyCancellable>()

    public static let shared = Store()
    let healthStore = HKHealthStore()
    

    @Published var appState = AppState()
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = reduce(state: appState, action: action)
        appState = result.0
        if let appCommand = result.1 {
            #if DEBUG
            print("[COMMAND]: \(appCommand)")
            #endif
            appCommand.execute(in: self)
        }
    }
    
    func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        switch action {
        case .initAction:
            appCommand = InitActionCommand()
        case .initBaterry:
            appCommand = InitBaterryCommand()
        case .error(let error):
            appState.error = error
            
        case .baterryUpdate:
            appState.baterry.baterryLevel = UIDevice.current.batteryLevel
            appState.baterry.baterryStatus = UIDevice.current.batteryState
        case .healthQuery(let type):
            appCommand = HealthQueryCommand(type: type)
        case .healthQueryDone(let type, let samples):
            switch type {
            case .distanceWalkingRunning:
                appState.health.distanceWalkingRunning = Int(samples?.map({$0.quantity.doubleValue(for: HKUnit.meter())}).reduce(0, +) ?? 0)
            case .stepCount:
                appState.health.stepCount =  Int(samples?.map({$0.quantity.doubleValue(for: HKUnit.count())}).reduce(0, +) ?? 0)
            }
        case .healthRequestAuthorization:
            appCommand = HealthRequestAuthorizationCommand()
        case .healthRequestAuthorizationDone(let success):
            appState.health.healthAuthorizationStatus = success
        }
        return (appState, appCommand)
    }
}


