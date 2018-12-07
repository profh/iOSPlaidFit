//
//  StressViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Refactored by Winston Chu on 12/07/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import Charts

class StressViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todayStress: UILabel!
    @IBOutlet weak var avgStress: UILabel!
    var weeklyStress : [Int] = []
    var average_stress : String = ""
    var today_stress : String = ""
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(weeklyStats: weeklyStress, stat: "Stress", today_stat: today_stress, average_stat: average_stress, stat_unit: "", stat_api_var: "life_stress", currentUser: currentUser!, barChartView: barChartView, todayStat: todayStress, avgStat: avgStress)
        chart.getWeeklyStat()
    }

}
