//
//  AppAction.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
import HealthKit

enum AppAction {
    case initAction
    case initBaterry
    case error(AppError)
    
    case baterryUpdate
    case healthQuery(type: AppState.Health.HealthType)
    case healthQueryDone(type: AppState.Health.HealthType, samples: [HKQuantitySample]?)
    case healthRequestAuthorization
    case healthRequestAuthorizationDone(success: Bool)
}
