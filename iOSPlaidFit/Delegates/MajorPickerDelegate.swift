//
//  MajorPickerDelegate.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import UIKit

class MajorPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let majors = ["Information Systems", "Computer Science", "Engineering", "Business", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return majors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return majors[row]
    }
}
