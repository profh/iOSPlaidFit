//
//  AboutViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/9/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background image
        let backgroundImage = UIImage(named: "pic_background")
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func close(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
