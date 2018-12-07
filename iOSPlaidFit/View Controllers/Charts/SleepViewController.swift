//
//  SleepViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Refactored by Winston Chu on 12/07/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import Charts

class SleepViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todaySleep: UILabel!
    @IBOutlet weak var avgSleep: UILabel!
    var weeklyHours : [Int] = []
    var average_sleep : String = ""
    var today_sleep : String = ""
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(weeklyStats: weeklyHours, stat: "Sleep", today_stat: today_sleep, average_stat: average_sleep, stat_unit: " hours", stat_api_var: "hours_of_sleep", currentUser: currentUser!, barChartView: barChartView, todayStat: todaySleep, avgStat: avgSleep)
        chart.getWeeklyStat()
    }

}
