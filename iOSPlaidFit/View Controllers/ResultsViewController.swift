//
//  ProfileViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var athleteLabel: UILabel!
    
    var currentUser: User? {
        didSet {
            // Update the view.
            print("set user")
            self.configureView()
        }
    }
    
    // MARK: - Functional
    
    func configureView() {
        // Update the user interface for the current user.
        if let user: User = self.currentUser {
            if let result = self.resultLabel {
                result.text = user.first_name! + "'s Data"
            }
            if let athlete = self.athleteLabel {
                athlete.text = "Athlete: " + user.first_name! + " " + user.last_name!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // set the date label
        // not sure why if you take out this logic from viewDidLoad(), build will fail
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: currentDate)
        self.dateLabel.numberOfLines = 2
        self.dateLabel.text = dateString
    }
    
    // https://stackoverflow.com/questions/32364055/formattting-phone-number-in-swift
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sleepSegue" {
            (segue.destination as! SleepViewController).currentUser = self.currentUser
        } else if segue.identifier == "stressSegue" {
            (segue.destination as! StressViewController).currentUser = self.currentUser
        } else if segue.identifier == "sorenessSegue" {
            (segue.destination as! SorenessViewController).currentUser = self.currentUser
        } else if segue.identifier == "hydrationSegue" {
            (segue.destination as! HydrationViewController).currentUser = self.currentUser
        }
    }
    
}
