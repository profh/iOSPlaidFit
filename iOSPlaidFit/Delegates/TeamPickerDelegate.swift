//
//  TeamPickerDelegate.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import UIKit

class TeamPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var teams = [(String, Int)]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teams[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Futura-Bold", size: 16)
        label.text =  teams[row].0
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }

}
