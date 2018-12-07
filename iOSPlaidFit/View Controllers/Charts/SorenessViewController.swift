//
//  SorenessViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Refactored by Winston Chu on 12/07/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import Charts

class SorenessViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todaySoreness: UILabel!
    @IBOutlet weak var avgSoreness: UILabel!
    var weeklySoreness : [Int] = []
    var average_soreness : String = ""
    var today_soreness : String = ""
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(weeklyStats: weeklySoreness, stat: "Soreness", today_stat: today_soreness, average_stat: average_soreness, stat_unit: "", stat_api_var: "soreness", currentUser: currentUser!, barChartView: barChartView, todayStat: todaySoreness, avgStat: avgSoreness)
        chart.getWeeklyStat()
    }

}
