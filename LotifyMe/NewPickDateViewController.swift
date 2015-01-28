//
//  NewPickDateViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/25/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit

    class NewPickDateViewController: UIViewController {
        
        @IBOutlet weak var submitButton: UIButton!
        
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
            self.view.backgroundColor = layerBackgroundColorGlobal
            if dateGlobal != "" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var dateGlobalObject = dateFormatter.dateFromString(dateGlobal)
                datePicker.setDate(dateGlobalObject!, animated: true)
            }

            // Layer Styling
            
            self.view.layer.borderColor = layerBorderColorGlobal
            self.view.layer.borderWidth = 3.0;
            
            // Next Button Styling
            
            submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 20)
            submitButton.setTitleColor( buttonTextColorGlobal, forState: UIControlState.Normal)
            submitButton.backgroundColor = mediumBlue
            submitButton.layer.cornerRadius = 2.0;
            
            // Nav Bar Styling
            
            self.navigationItem.title = "Date"
            
        }

        override func viewWillDisappear(animated: Bool) {
            captureValues()
            println("dateGlobal has been saved with a value of \(dateGlobal)") // Report
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }
