//
//  HydrationViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Refactored by Winston Chu on 12/07/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import Charts

class HydrationViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todayHydrate: UILabel!
    @IBOutlet weak var avgHydrate: UILabel!
    var weeklyWater : [Int] = []
    var average_water : String = ""
    var today_water : String = ""
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(weeklyStats: weeklyWater, stat: "Hydration", today_stat: today_water, average_stat: average_water, stat_unit: " oz", stat_api_var: "ounces_of_water_consumed", currentUser: currentUser!, barChartView: barChartView, todayStat: todayHydrate, avgStat: avgHydrate)
        chart.getWeeklyStat()
    }

}
