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
    
    var currentUser: User?
    
    func configureView() {
        if let tSoreness = self.todaySoreness {
            tSoreness.text = String(getTodaySoreness())
        }
//        if let aSoreness = self.avgSoreness {
//            aSoreness.text = String(getAverageSoreness())
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser?.first_name)
        self.configureView()
        self.setChartValues()
        // Do any additional setup after loading the view.
    }
    
    func setChartValues() {
        let dataEntries = getWeeklySoreness()
        let size = dataEntries.count
        //        let values = (0..<size).map { (i) -> BarChartDataEntry in
        let values = (0..<7).map { (i) -> BarChartDataEntry in
            //            let val = dataEntries[i]
            let val = i
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        
        //        let dates = getDates()
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
    
    func getWeeklySoreness() -> Array<Int> {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var weeklySoreness : [Int] = []
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let weeklySore = result["post_practice_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklySore {
                            if let this_soreness = survey["soreness"] {
                                let soreness = this_soreness as! Int
                                weeklySoreness.append(soreness)
                            }
                        }
                    }
                }
            }
        }
        return weeklySoreness
    }
    
    func getTodaySoreness() -> Int {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var today_soreness = 0
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let tSoreness = result["post_practice_survey_yesterday_objects"] as? [String: Any] {
                        today_soreness = tSoreness["soreness"] as! Int
                    }
                }
            }
        }
        return today_soreness
    }
    
    func getAverageSoreness() -> Int {
        let weeklySoreness = getWeeklySoreness()
        var total_soreness = 0
        var days = 0
        for day in weeklySoreness {
            total_soreness = total_soreness + day
            days = days + 1
        }
        return total_soreness/days
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
