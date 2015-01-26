//
//  NewPickGameTypeViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/24/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit

    class NewPickGameTypeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        
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
        
// SETUP
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = blueBackground
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


