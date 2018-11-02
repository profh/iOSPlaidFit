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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var andrewIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
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
                phone.text = user.phone_number
            }
            if let year = self.yearLabel {
                year.text = user.year
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    

    // MARK: - Navigation
    
    // leaving this function here in case we want to add the ability to edit users
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
