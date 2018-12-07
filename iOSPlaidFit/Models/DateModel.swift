//
//  DateModel.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/7/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation

class DateModel {
    
    // gets a date array of the past week, formatted for the bar chart
    // https://stackoverflow.com/questions/26996330/swift-get-last-7-days-starting-from-today-in-array
    func getDates() -> [String] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [String]()
        for _ in 1 ... 7 {
            let day = cal.component(.day, from: date)
            let month = cal.component(.month, from: date)
            days.append(String(month) + "/" + String(day))
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        return days.reversed()
    }
    
}
