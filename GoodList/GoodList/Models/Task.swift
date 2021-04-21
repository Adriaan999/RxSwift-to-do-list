//
//  Task.swift
//  GoodList
//
//  Created by Adriaan van Schalkwyk on 2021/04/21.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let prioroty: Priority
}
