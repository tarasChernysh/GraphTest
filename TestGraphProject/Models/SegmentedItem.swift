//
//  SegmentedItem.swift
//  TestGraphProject
//
//  Created by Taras Chernysh on 29.03.2022.
//

import Foundation

enum SegmentedItem: Int, Equatable {
    case week, month
    
    var title: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
    
    var amountOfDays: Int {
        switch self {
        case .week: return 7
        case .month: return 365
        }
    }
}
