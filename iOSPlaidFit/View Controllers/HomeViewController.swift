//
//  HomeViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
class HomeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            // go back to login screen and clear the current user
            self.currentUser = nil
            _ = navigationController?.popToRootViewController(animated: true)
        } else if segue.identifier == "profileSegue" {
            // go to profile view and set the current user to display info
            (segue.destination as! ProfileViewController).currentUser = self.currentUser
        }
    }

}
