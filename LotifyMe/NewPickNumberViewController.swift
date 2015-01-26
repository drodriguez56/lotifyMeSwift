//
//  NewPickNumberViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/24/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit
    import Foundation

    class NewPickNumberViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

// NUMBER PICKER
        
        @IBOutlet weak var numberInput: UIPickerView!
        @IBOutlet weak var multiToggle: UISwitch!
        
        let numberInputData = [
            [Int](1...99),
            [Int](1...99),
            [Int](1...99),
            [Int](1...99),
            [Int](1...99),
            [Int](1...99)
        ]
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 6
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return numberInputData[component].count
        }
        
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return "\(numberInputData[component][row])"
        }
        
        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
            numberGlobal[component] = "\(numberInputData[component][row])"
            println("numberGlobal dial has been moved, with a new value of \(numberGlobal)")  // Report
        }
    
// LOTIFY BUTTON ACTION
        
        @IBAction func lotifyButton(sender: AnyObject) {
            captureValues()
            println("New Pick object will be created shortly. Input values will be:") // Report
            println("* gameTypeGlobal: \(gameTypeGlobal)") // Report
            println("* dateGlobal:     \(dateGlobal)") // Report
            println("* numberGlobal:   \(numberGlobal)") // Report
            println("* multiGlobal:    \(multiGlobal)") // Report
            var currentSession = retrieveSession()
            if currentSession == "nilUser" {
                println("lotifyButton pressed: No users logged in; segue to LoginViewController") // Report
                beforeLoginVariable = "onCreate"
                performSegueWithIdentifier(
                    "NewPickNumberSegueToLoginViewController",
                    sender: sender
                )
            } else if currentSession == "#Error" {
                println("lotifyButton pressed: Error in fetching session; do nothing") // Report
            } else {
                println("lotifyButton pressed: User is logged in; segue to ProfileViewController") // Report
                newPickPostRequest()
                sleep(2)
                newPickPostRequest()
                performSegueWithIdentifier(
                    "NewPickNumberSegueToProfileViewController",
                    sender: sender
                )
            }
        }
        
// CAPTURE VALUES FUNCTION
        
        func captureValues() {
            multiGlobal = multiToggle.on
            // Report moved to viewWillDisappear() call
        }
        
// SETUP

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = blueBackground
            multiToggle.tintColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            numberInput.delegate = self
            numberInput.dataSource = self
            for (var i = 0; i < numberGlobal.count; i++) {
                numberInput.selectRow(
                    numberGlobal[i].toInt()! - 1,
                    inComponent: i,
                    animated: true
                )
            }
            if multiGlobal == true {
                multiToggle.setOn(true, animated: true)
            }
        }

        override func viewWillDisappear(animated: Bool) {
            captureValues()
            println("multiGlobal has been saved with a value of \(multiGlobal)") // Report
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }

