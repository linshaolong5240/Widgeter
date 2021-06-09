//
//  AppCommand.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
import Combine
import UIKit.UIDevice
import HealthKit

protocol AppCommand {
    func execute(in store: Store)
}

struct InitActionCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(.initBaterry)
        store.dispatch(.healthRequestAuthorization)
    }
}

struct InitBaterryCommand: AppCommand {
    func execute(in store: Store) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        store.dispatch(.baterryUpdate)
//        NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification).receive(on: DispatchQueue.main).sink { _ in
//
//            store.dispatch(.baterryUpdate)
//        }.store(in: &store.cancellableSet)
        let batteryLevel = NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)
        let batteryState = NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)
        let battery = Publishers.Merge(batteryLevel, batteryState)

        battery.receive(on: DispatchQueue.main).sink { notification in
            store.dispatch(.baterryUpdate)
        }.store(in: &store.cancellableSet)
    }
}

struct HealthQueryCommand: AppCommand {
    enum HKDeviceModel: String {
        case iPhone
        case Watch
    }
    
    let type: AppState.Health.HealthType
    
    func execute(in store: Store) {
        query(in: store.healthStore, sampleType: type.sampleType) { samples in
            DispatchQueue.main.async {
                store.dispatch(.healthQueryDone(type: type, samples: samples))
            }
        }
    }
    
    func query(in store: HKHealthStore, sampleType: HKSampleType, completion: @escaping ([HKQuantitySample]?) -> Void) {
        let now = Date()
        var dateComponets = Calendar.current.dateComponents(in: .current, from: now)
        dateComponets.hour = 0
        dateComponets.minute = 0
        dateComponets.second = 0
        let day = Calendar.current.date(from: dateComponets)!
        let predicate = HKQuery.predicateForSamples(withStart: day, end: now, options: [])
        let descriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let limit  = 0
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: [descriptor]) { query, samples, error in
            if let watchSamples = samples?.compactMap({ $0 as? HKQuantitySample }).filter({$0.device?.model == HKDeviceModel.Watch.rawValue}) {
                completion(watchSamples)
            } else  if let phoneSamples = samples?.compactMap({ $0 as? HKQuantitySample }).filter({$0.device?.model == HKDeviceModel.iPhone.rawValue}) {
                completion(phoneSamples)
            }
        }
        store.execute(sampleQuery)
    }
}

struct HealthRequestAuthorizationCommand: AppCommand {
    func execute(in store: Store) {
        if HKHealthStore.isHealthDataAvailable() {
            store.healthStore.requestAuthorization(toShare: nil, read: HealthConfigration.toRead) { success, error in
                guard error == nil else {
                    store.dispatch(.error(AppError.healthRequestAuthorization(error!)))
                    return
                }
                DispatchQueue.main.async {
                    store.dispatch(.healthRequestAuthorizationDone(success: success))
                    store.dispatch(.healthQuery(type: .distanceWalkingRunning))
                    store.dispatch(.healthQuery(type: .stepCount))
                }
            }
        }
    }
}
