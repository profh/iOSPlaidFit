//
//  StressViewController.swift
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

class StressViewController: UIViewController {

    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todayStress: UILabel!
    @IBOutlet weak var avgStress: UILabel!
    
    var currentUser: User? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        if let tStress = self.todayStress {
            tStress.text = String(getTodayStress())
        }
//        if let aStress = self.avgStress {
//            aStress.text = String(getAverageStress())
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.setChartValues()
        // Do any additional setup after loading the view.
    }
    
    func setChartValues() {
        let dataEntries = getWeeklyStress()
        let size = dataEntries.count
        //        let values = (0..<size).map { (i) -> BarChartDataEntry in
        let values = (0..<7).map { (i) -> BarChartDataEntry in
            //            let val = dataEntries[i]
            let val = i
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        
        //        let dates = getDates()
        let dates = ["12/1","12/2","12/3","12/4","12/5","12/6","12/6"]
        
        let set1 = BarChartDataSet(values: values, label: "Stress")
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
        
        self.barChartView.leftAxis.axisMaximum = 10
        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    }
    
    func getWeeklyStress() -> Array<Int> {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var weeklyStress : [Int] = []
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let weekStress = result["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weekStress {
                            if let this_stress = survey["life_stress"] {
                                let stress = this_stress as! Int
                                weeklyStress.append(stress)
                            }
                        }
                    }
                }
            }
        }
        return weeklyStress
    }
    
    func getTodayStress() -> Int {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var today_stress = 0
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let tStress = result["daily_wellness_survey_today_objects"] as? [String: Any] {
                        today_stress = tStress["life_stress"] as! Int
                    }
                }
            }
        }
        return today_stress
    }
    
    func getAverageStress() -> Int {
        let weeklyStress = getWeeklyStress()
        var total_stress = 0
        var days = 0
        for day in weeklyStress {
            total_stress = total_stress + day
            days = days + 1
        }
        return total_stress/days
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
