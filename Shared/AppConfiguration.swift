//
//  AppConfigure.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
import HealthKit

struct AppConfiguration {
    
}

struct HealthConfigration {
    public static let allTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                      HKObjectType.quantityType(forIdentifier: .stepCount)!])
    public static let toRead = Self.allTypes
}
