//
//  AppAction.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
#if canImport(HealthKit)
import HealthKit
#endif

enum AppAction {
    case initAction
    case error(AppError)
    #if canImport(UIKit)
    case baterryInit
    case baterryUpdate
    #endif
    #if canImport(HealthKit)
    case healthQuery(type: AppState.Health.HealthType)
    case healthQueryDone(type: AppState.Health.HealthType, samples: [HKQuantitySample]?)
    case healthRequestAuthorization
    case healthRequestAuthorizationDone(success: Bool)
    #endif
}
