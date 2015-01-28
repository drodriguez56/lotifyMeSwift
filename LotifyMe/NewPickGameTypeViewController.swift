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
        
// GAME TYPE PICKER
        
        @IBOutlet weak var submitButton: UIButton!
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
//        
//func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSMutableAttributedString? {
//    
//    var attributedString: NSMutableAttributedString!
//    
//    attributedString = NSMutableAttributedString(string: gameTypeData[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
//    
//    attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "AmericanTypewriter-Bold", size: 18.0)!, range: NSRange(location:2,length:4))
//
//    return attributedString
//}
        
func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

    let pickerLabel = UILabel()
        pickerLabel.textAlignment = .Center
    let hue = CGFloat(row) / CGFloat(gameTypeData.count)
//        pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 0.2)
    
    let titleData = gameTypeData[row]
    
    let myTitle = NSAttributedString(
        string: titleData, attributes: [
            NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 24.0)!,
            NSForegroundColorAttributeName:UIColor.whiteColor()
        ]
    )
    
    pickerLabel.attributedText = myTitle
    return pickerLabel
}
        
// SETUP
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = blueBackground
//self.view.layer.borderColor = (UIColor( red: 0.4, green: 0.8, blue: 0.95, alpha: 0.5)).CGColor
//self.view.layer.borderWidth = 15.0;
//self.view.layer.cornerRadius = 10.0;
submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 20)
submitButton.setTitleColor(
    UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8),
    forState: UIControlState.Normal
)
navigationController?.navigationBar.barTintColor = UIColor( red: 0.3, green: 0.7, blue: 0.95, alpha: 1)
submitButton.backgroundColor = UIColor( red: 0.3, green: 0.7, blue: 0.95, alpha: 1)
submitButton.layer.cornerRadius = 2.0;
//submitButton.layer.shadowColor = (UIColor.darkGrayColor()).CGColor
//submitButton.layer.shadowOffset = CGSizeMake(5, 5)
//            submitButton.layer.cornerRadius = 2.0;
//            submitButton.layer.borderWidth = 1.0;
            
//            submitButton.layer.shadowColor = (UIColor.darkGrayColor()).CGColor;
//            submitButton.layer.shadowOpacity = 1.0;
//            submitButton.layer.shadowRadius = 12;
//            submitButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            gameType.delegate = self
            gameType.dataSource = self
            gameType.selectRow(
                2,
                inComponent: 0,
                animated: true
            )
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    }


