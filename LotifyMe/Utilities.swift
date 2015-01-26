//
//  Utilities.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

import Foundation

public func alert(title: String, body: String) {

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
    
    self.presentViewController(
        alertController,
        animated: true,
        completion: nil
    )

}