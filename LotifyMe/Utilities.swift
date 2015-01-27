//
//  Utilities.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation
    import UIKit

// ALERT FUNCTION

    public func alert(title: String, body: String, popupViewControllerCallingViewController: AnyObject) {
        
            let alertController = UIAlertController(
                title: title,
                message: body,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alertController.addAction(
                UIAlertAction(
                    title: "Dismiss",
                    style: UIAlertActionStyle.Default,
                    handler: nil
                )
            )
            
            popupViewControllerCallingViewController.presentViewController(
                alertController,
                animated: true,
                completion: nil
            )

            println("alert() called by viewController: \(popupViewControllerCallingViewController)") // Report
        
    }

// OLD TICKET FUNCTION

    public func oldTicket(drawDateString: String) -> Boolean {

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var drawDate = dateFormatter.dateFromString(drawDateString) as NSDate!
        var currentDate = NSDate()
        
        if currentDate.compare(drawDate) == NSComparisonResult.OrderedAscending {
            return 0
        } else {
            return 1
        }

    }