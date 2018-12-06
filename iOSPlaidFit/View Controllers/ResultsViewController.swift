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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var andrewIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
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
            if let name = self.nameLabel {
                name.text = user.first_name! + " " + user.last_name!
            }
            if let andrewID = self.andrewIdLabel {
                andrewID.text = user.andrew_id
            }
            if let email = self.emailLabel {
                email.text = user.email
            }
            if let phone = self.phoneLabel {
                phone.text = format(phoneNumber: user.phone_number!)
            }
            if let year = self.yearLabel {
                year.text = user.year
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("asdasasdsadadsadsa")
        self.configureView()
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
    
    // leaving this function here in case we want to add the ability to edit users
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sleepSegue" {
            // go to profile view and set the current user to display info
            (segue.destination as! SleepViewController).currentUser = self.currentUser
        }
    }
    
}
