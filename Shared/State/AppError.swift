//
//  AppError.swift
//  Widget
//
//  Created by 林少龙 on 2021/6/9.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }
    case healthRequestAuthorization(Error)
}
extension AppError {
    var localizedDescription: String {
        switch self {
        case .healthRequestAuthorization(let error): return "Health Authorization Error:\n\(error.localizedDescription)"
        }
    }
}
