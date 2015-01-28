//
//  GlobalOpt.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation
    import UIKit
    import CoreData

    // ROOT PATH

    public var rootPath = "http://localhost:4848"

    // COLOR SCHEME

    public var lightBlue    =   UIColor(red: 0.25, green: 0.65, blue: 0.95, alpha: 1.0)
    public var mediumBlue   =   UIColor(red: 0.28, green: 0.68, blue: 0.95, alpha: 1.0)
    public var darkBlue     =   UIColor(red: 0.203125, green: 0.59375, blue: 0.85546875, alpha: 1.0)

    // APPLY COLOR SCHEME

    public var navBarBackgroundColorGlobal = lightBlue
    public var layerBackgroundColorGlobal = darkBlue
    public var buttonBackgroundColorGlobal = mediumBlue

    public var layerBorderColorGlobal = (UIColor( red: 0.4, green: 0.8, blue: 0.95, alpha: 0.5)).CGColor

    public var buttonTextColorGlobal = UIColor( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)

    public var buttonBorderColorGlobal = UIColor(red: 0.20, green: 0.60, blue: 0.85, alpha: 1.0).CGColor