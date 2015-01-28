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

        @IBOutlet weak var submitButton: UIButton!

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

// FORMAT PICKER VIEW
        
        func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
            
            let titleData = "\(numberInputData[component][row])"
            
            let myTitle = NSAttributedString(
                string: titleData,
                attributes: [
                    NSFontAttributeName:UIFont(
                        name: "HelveticaNeue",
                        size: 24.0
                        )!,
                    NSForegroundColorAttributeName:UIColor.whiteColor()
                ]
            )

            let pickerLabel = UILabel()
                pickerLabel.textAlignment = .Center
                pickerLabel.backgroundColor = UIColor( red: 0.3, green: 0.7, blue: 0.95, alpha: 0.5)
                pickerLabel.attributedText = myTitle
            
            return pickerLabel
            
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
                
                println("lotifyButton pressed: No users logged in; show popup alert for login or signup") // Report
                
                let alertController = UIAlertController(
                    title: "Almost There!",
                    message: "Create an account with your email, or login if you already have one.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                alertController.addAction(
                    UIAlertAction(
                        title: "Login",
                        style: UIAlertActionStyle.Default,
                        handler: {(actionSheet: UIAlertAction!) in
                            println("Login selected: Segue to LoginViewController") // Report
                            beforeLoginVariable = "onCreate"
                            self.segueToLogin(sender)
                        }
                    )
                )
                
                alertController.addAction(
                    UIAlertAction(
                        title: "Signup",
                        style: UIAlertActionStyle.Default,
                        handler: {(actionSheet: UIAlertAction!) in
                            println("Signup selected: Segue to SignupViewController") // Report
                            beforeLoginVariable = "onCreate"
                            self.segueToSignup(sender)
                        }
                    )
                )
                
                presentViewController(
                    alertController,
                    animated: true,
                    completion: nil
                )
                
            } else if currentSession == "#Error" {
                println("lotifyButton pressed: Error in fetching session; do nothing") // Report
            } else {
                println("lotifyButton pressed: User is logged in; segue to HistoryTableViewController") // Report
                newPickPostRequest(self)
                performSegueWithIdentifier(
                    "NewPickNumberSegueToHistoryTableViewController",
                    sender: sender
                )
            }
        }

// SEGUE TO LOGIN
        
        func segueToLogin(sender: AnyObject) {
            performSegueWithIdentifier(
                "NewPickNumberSegueToLoginViewController",
                sender: sender
            )
        }
        
// SEGUE TO SIGNUP

        func segueToSignup(sender: AnyObject) {
            performSegueWithIdentifier(
                "NewPickNumberSegueToSignupViewController",
                sender: sender
            )
        }
        
// CAPTURE VALUES FUNCTION
        
        func captureValues() {
            multiGlobal = multiToggle.on
            // Report moved to viewWillDisappear() call
        }
        
// SETUP

        override func viewDidLoad() {

            super.viewDidLoad()
            self.view.backgroundColor = layerBackgroundColorGlobal
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

            // Layer Styling
            
            self.view.layer.borderColor = layerBorderColorGlobal
            self.view.layer.borderWidth = 3.0;
            
            // Next Button Styling
            
            submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Medium", size: 17)
            submitButton.setTitleColor( buttonTextColorGlobal, forState: UIControlState.Normal)
            submitButton.backgroundColor = mediumBlue
            submitButton.layer.cornerRadius = 2.0;
            
            // Nav Bar Styling
            
            self.navigationItem.title = "Make Your Pick"
        
        }

        override func viewWillDisappear(animated: Bool) {
            captureValues()
            println("multiGlobal has been saved with a value of \(multiGlobal)") // Report
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }

