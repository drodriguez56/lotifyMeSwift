//
//  NewPickGameTypeViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/24/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit
    import QuartzCore

    class NewPickGameTypeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        
        @IBOutlet weak var historyButton: UIBarButtonItem!
        @IBOutlet weak var submitButton: UIButton!
        
// GAME TYPE PICKER
        
        @IBOutlet weak var gameType: UIPickerView!
        
        let gameTypeData = [
            "Cash4Life",
            "Megamillions",
            "NYLotto",
            "Pick10",
            "Powerball",
            "Take5"
        ]
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return gameTypeData.count
        }
        
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return gameTypeData[row]
        }
        
        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
            gameTypeGlobal = "\(gameTypeData[row])"
            println("gameTypeGlobal dial has been moved, with a new value of \(gameTypeGlobal)") // Report
        }
        
// FORMAT PICKER VIEW
        
        func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

            let titleData = gameTypeData[row]
            
            let myTitle = NSAttributedString(
                string: titleData, attributes: [
                    NSFontAttributeName:UIFont(
                        name: "HelveticaNeue",
                        size: 23.0
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

        func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 200
        }
        
// HISTORY BUTTON
        
        @IBAction func historyButton(sender: AnyObject) {

            var currentSession = retrieveSession()
            if currentSession == "nilUser" {
                
                println("historyButton pressed: No users logged in; show popup alert for login or signup") // Report
                
                let alertController = UIAlertController(
                    title: "Please Login",
                    message: "Login to see your history of picks, or create an account if you don't have one.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                alertController.addAction(
                    UIAlertAction(
                        title: "Login",
                        style: UIAlertActionStyle.Default,
                        handler: {(actionSheet: UIAlertAction!) in
                            println("Login selected: Segue to LoginViewController") // Report
                            self.performSegueWithIdentifier(
                                "NewPickGameTypeSegueToLoginViewController",
                                sender: sender
                            )
                        }
                    )
                )
                
                alertController.addAction(
                    UIAlertAction(
                        title: "Signup",
                        style: UIAlertActionStyle.Default,
                        handler: {(actionSheet: UIAlertAction!) in
                            println("Signup selected: Segue to SignupViewController") // Report
                            self.performSegueWithIdentifier(
                                "NewPickGameTypeSegueToSignupViewController",
                                sender: sender
                            )
                        }
                    )
                )
        
                presentViewController(
                    alertController,
                    animated: true,
                    completion: nil
                )
                
            } else if currentSession == "#Error" {
                println("historyButton pressed: Error in fetching session; do nothing") // Report
            } else {
                println("historyButton pressed: User is logged in; segue to HistoryTableViewController") // Report
                performSegueWithIdentifier(
                    "NewPickGameTypeSegueToHistoryTableViewController",
                    sender: sender
                )
            }
            
        }
        
        // DETECT SWIPE TO CONTINUE
        
        func leftSwiped() {
            performSegueWithIdentifier(
                "NewPickGameTypeSegueToNewPickDateViewController",
                sender: self
            )
        }
        
// SETUP
        
        override func viewDidLoad() {

            super.viewDidLoad()
            self.view.backgroundColor = layerBackgroundColorGlobal
            self.navigationItem.setHidesBackButton(true, animated: true)

            gameType.delegate = self
            gameType.dataSource = self
            gameType.selectRow(
                2,
                inComponent: 0,
                animated: true
            )
            
            // Layer Styling
            
            self.view.layer.borderColor = layerBorderColorGlobal
            self.view.layer.borderWidth = 3.0;

            
            // Next Button Styling
            
            submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 19)
            submitButton.setTitleColor(buttonTextColorGlobal, forState: UIControlState.Normal)
            submitButton.backgroundColor = mediumBlue
            submitButton.layer.cornerRadius = 2.0;
            
            submitButton.layer.borderColor = buttonBorderColorGlobal
            submitButton.layer.borderWidth = 1.0
            
            // Nav Bar Styling
            
            self.navigationItem.title = "Game"
            
            // Swipe to Continue
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
            self.view.addGestureRecognizer(swipeLeft)
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }
//    var attributedString: NSMutableAttributedString!
//
//    attributedString = NSMutableAttributedString(string: gameTypeData[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
//
//    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 18.0)!, range: NSRange(location:2,length:4))
//
//    return attributedString

