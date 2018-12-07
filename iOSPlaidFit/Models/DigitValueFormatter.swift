//
//  DigitValueFormatter.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/6/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import Charts

class DigitValueFormatter : NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.0f", value)
        return "\(valueWithoutDecimalPart)"
    }
}
