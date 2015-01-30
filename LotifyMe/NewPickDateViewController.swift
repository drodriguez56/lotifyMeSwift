//
//  NewPickDateViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/25/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit

    class NewPickDateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        
        @IBOutlet weak var submitButton: UIButton!
        
// DATE PICKER
        
        @IBOutlet weak var datePicker: UIPickerView!
        
        let datePickerData = [
            [Int](0...11),
            [Int](0...30),
            [Int](0...10)
        ]
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 3
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return datePickerData[component].count
        }
        
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
            return "\(dateConvert[component][datePickerData[component][row]])"
        }
        
        func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
            
            var dateGlobalCharset = NSCharacterSet(charactersInString: "-")
            var dateGlobalAsArrayBeforeTranslate = dateGlobal.componentsSeparatedByCharactersInSet(dateGlobalCharset)
            var int = Int()
            
            if component == 2 { // Year
                int = datePickerData[component][row] + 2010
                dateGlobalAsArrayBeforeTranslate[0] = "\(int)"
            } else if component == 1 { // Day
                int = datePickerData[component][row] + 1
                dateGlobalAsArrayBeforeTranslate[2] = "\(int)"
            } else if component == 0 { // Month
                int = datePickerData[component][row] + 1
                dateGlobalAsArrayBeforeTranslate[1] = "\(int)"
            }
            
            var year = dateGlobalAsArrayBeforeTranslate[0].toInt()!
            var month = dateGlobalAsArrayBeforeTranslate[1].toInt()!
            var day = dateGlobalAsArrayBeforeTranslate[2].toInt()!
            
            dateGlobal = "\(year)-\(month)-\(day)"
            println("dateGlobal dial has been moved, with a new value of \(dateGlobal)")  // Report
            
        }
        
// FORMAT PICKER VIEW
        
        func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
            
            let titleData = "\(dateConvert[component][datePickerData[component][row]])"
            
            let myTitle = NSAttributedString(
                string: titleData,
                attributes: [
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
            if component == 0 {
                return 160
            } else if component == 1 {
                return 70
            } else {
                return 110
            }
        }
        
// NEXT BUTTON ACTION
        
        @IBAction func submitButton(sender: AnyObject) {
            captureValues()
        }
        
// CAPTURE VALUES FUNCTION
        
        func captureValues() {
//            var dateString = "\(datePicker.date)" as NSString
//            dateGlobal = dateString.substringWithRange(NSRange(location: 0, length: 10))
            // Report moved to viewWillDisappear() call
        }
        
        // DETECT SWIPE TO CONTINUE
        
        func leftSwiped() {
            performSegueWithIdentifier(
                "NewPickDateSegueToNewPickNumberViewController",
                sender: self
            )
        }
        
        func rightSwiped() {
            navigationController?.popViewControllerAnimated(true)
        }
        
// SETUP
        
        override func viewDidLoad() {

            super.viewDidLoad()
            self.view.backgroundColor = layerBackgroundColorGlobal
            datePicker.delegate = self
            datePicker.dataSource = self
            
            if dateGlobal == "" {
                var dateString = "\(NSDate())" as NSString
                dateGlobal = dateString.substringWithRange(NSRange(location: 0, length: 10))
            }
            
            var dateGlobalCharset = NSCharacterSet(charactersInString: "-")
            var dateGlobalAsTempArray = dateGlobal.componentsSeparatedByCharactersInSet(dateGlobalCharset)
            
            for (var i = 0; i < 3; i++) {
                if i == 0 { // Month
                    datePicker.selectRow(
                        dateGlobalAsTempArray[1].toInt()! - 1,
                        inComponent: i,
                        animated: true
                    )
                } else if i == 1 { // Day
                    datePicker.selectRow(
                        dateGlobalAsTempArray[2].toInt()! - 1,
                        inComponent: i,
                        animated: true
                    )
                } else if i == 2 { // Year
                    datePicker.selectRow(
                        dateGlobalAsTempArray[0].toInt()! - 2010,
                        inComponent: i,
                        animated: true
                    )
                }
            }

            // Layer Styling
            
            self.view.layer.borderColor = layerBorderColorGlobal
            self.view.layer.borderWidth = layerBorderWidth
            
            // Next Button Styling
            
            submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 19)
            submitButton.setTitleColor(buttonTextColorGlobal, forState: UIControlState.Normal)
            submitButton.backgroundColor = mediumBlue
            submitButton.layer.cornerRadius = buttonCornerRadius
            
            submitButton.layer.borderColor = buttonBorderColorGlobal
            submitButton.layer.borderWidth = buttonBorderWidth
            
            // Nav Bar Styling
            
            self.navigationItem.title = "Date"
            
            // Swipe to Continue
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
            self.view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
            swipeRight.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(swipeRight)
            
        }

        override func viewWillDisappear(animated: Bool) {
            captureValues()
            println("dateGlobal has been saved with a value of \(dateGlobal)") // Report
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }
