//
//  ProfileViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var athleteLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var andrewIDLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!

    var currentUser: User? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    // MARK: - Functional
    
    func configureView() {
        // Update the user interface for the current user.
        if let user: User = self.currentUser {
            if let team = self.teamLabel {
                team.text = user.team_string
            }
            if let andrewID = self.andrewIDLabel {
                andrewID.text = user.andrew_id
            }
            if let email = self.emailLabel {
                email.text = user.email
            }
            if let phone = self.phoneLabel {
                phone.text = user.formatPhone()
            }
            if let year = self.yearLabel {
                year.text = user.year
            }
            if let major = self.majorLabel {
                major.text = user.major
            }
            if let profile = self.profileLabel {
                profile.text = user.first_name! + "'s Profile"
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
    
    // MARK: - Navigation
    
    // leaving this function here in case we want to add the ability to edit users
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

// Used to formatting the phone number string
extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
