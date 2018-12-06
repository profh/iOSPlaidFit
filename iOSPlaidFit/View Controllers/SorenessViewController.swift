//
//  SorenessViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import CoreData
import Charts

class SorenessViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todaySoreness: UILabel!
    @IBOutlet weak var avgSoreness: UILabel!
    var weeklySoreness : [Int] = []
    var average_soreness : String = ""
    var today_soreness : String = ""
    var dates : [Date] = []
    var currentUser: User?
    
    func configureView() {
        if let tSoreness = self.todaySoreness {
            tSoreness.text = today_soreness
        }
        if let aSoreness = self.avgSoreness {
            aSoreness.text = average_soreness
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeeklySoreness()
    }
    
    func populateDates() {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 0
        dateComponent.year = 0
        Calendar.current.date
    }
    
    func setChartValues() {
        let dataEntries = weeklySoreness
        let size = dataEntries.count
        let values = (0..<size).map { (i) -> BarChartDataEntry in
            let val = dataEntries[i]
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        
        let dates = ["12/1","12/2","12/3","12/4","12/5","12/6","12/6"]
        
        let set1 = BarChartDataSet(values: values, label: "Soreness")
        let data = BarChartData(dataSet: set1)
        
        self.barChartView.data = data
        
        self.barChartView.rightAxis.enabled = false
        
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.axisMaximum = 7
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.barChartView.xAxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = ""
        leftAxisFormatter.positiveSuffix = ""
        
        self.barChartView.leftAxis.axisMaximum = 10
        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    }
    
    func getWeeklySoreness() {
        if let user_id = currentUser?.id, let api_key = currentUser?.api_key {
            let user_url = "http://localhost:3000/v1/users/" + String(user_id)
            let headers: HTTPHeaders = [
                "Authorization": "Token token=\(api_key)"
            ]
            Alamofire.request(user_url, headers: headers).responseJSON { response in
                if let error = response.error {
                    print(error.localizedDescription)
                }
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let weeklySore = JSON["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklySore {
                            if let this_soreness = survey["soreness"] {
                                self.weeklySoreness.append(this_soreness as! Int)
                            }
                        }
                    }
                }
                self.setChartValues()
                self.getAverageSoreness()
                self.getTodaySoreness()
                self.configureView()
            }
        }
    }
    
    func getTodaySoreness() {
        if weeklySoreness.count < 7 {
            today_soreness = "N/A"
        } else {
            today_soreness = String(weeklySoreness[6])
        }
    }
    
    func getAverageSoreness() {
        let weeklySore = weeklySoreness
        var total_soreness = 0
        var days = 0
        for day in weeklySore {
            total_soreness = total_soreness + day
            days = days + 1
        }
        average_soreness = String(total_soreness / days)
    }
}
