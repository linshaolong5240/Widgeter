//
//  AppState.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation
import Combine
#if canImport(UIKit)
import UIKit.UIDevice
#endif
#if canImport(HealthKit)
import HealthKit.HKSample
#endif

@propertyWrapper
struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    public var wrappedValue: T {
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue) , forKey: key)
            UserDefaults.standard.synchronize()
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
    }
    
    init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
    }
}

struct AppState {
    var baterry = Baterry()
    var health = Health()
    var settings = Settings()
    var error: AppError?
}

extension AppState {
    struct Baterry {
        var baterryLevel: Float = -1.0
        #if false//DEBUG
        var baterryStatus: UIDevice.BatteryState { get { UIDevice.BatteryState.unplugged } set { } }
        #else
        #if canImport(UIKit)
        var baterryStatus: UIDevice.BatteryState = .unknown
        #endif
        #endif
    }
    struct Health {
        enum HealthType {
            case distanceWalkingRunning
            case stepCount
        }
        var healthAuthorizationStatus: Bool = false
        
        var distanceWalkingRunning:Int = 0
        var stepCount: Int = 0
    }
    struct Storage {
        
    }
    struct Settings {
    }
}
