//
//  NewPickDateViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/25/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit

    class NewPickDateViewController: UIViewController {
        
// DATE PICKER
        
        @IBOutlet weak var datePicker: UIDatePicker!
        
// NEXT BUTTON ACTION
        
        @IBAction func submitButton(sender: AnyObject) {
            captureValues()
        }
        
// CAPTURE VALUES FUNCTION
        
        func captureValues() {
            var dateString = "\(datePicker.date)" as NSString
            dateGlobal = dateString.substringWithRange(NSRange(location: 0, length: 10))
            // Report moved to viewWillDisappear() call
        }
        
// SETUP
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = blueBackground
//            thisViewForAlert = self
            if dateGlobal != "" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var dateGlobalObject = dateFormatter.dateFromString(dateGlobal)
                datePicker.setDate(dateGlobalObject!, animated: true)
            }
        }

        override func viewWillDisappear(animated: Bool) {
            captureValues()
            println("dateGlobal has been saved with a value of \(dateGlobal)") // Report
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }
