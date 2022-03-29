//
//  ViewModel.swift
//  TestGraphProject
//
//  Created by Taras Chernysh on 29.03.2022.
//

import Foundation

final class ViewModel {
    typealias MaxValue = Double
        
    func makeConfigs() -> ([StatisticGraphView.Config], MaxValue) {
        // test data
        var values: [StatisticGraphView.Config] = []
        for i in 1...30 {
            let date1 = DateComponents(calendar: .current, year: 2022, month: 4, day: i, hour: 9, minute: 1)
            let val = Double(arc4random_uniform(7) + 3)
            let config = StatisticGraphView.Config(moodLevel: val, timeInterval: date1.date?.timeIntervalSince1970 ?? 0)
            values.append(config)
        }
        return (values, 12)
    }
    
}
