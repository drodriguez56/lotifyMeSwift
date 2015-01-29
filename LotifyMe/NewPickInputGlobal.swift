//
//  NewPickInputGlobal.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation
    import UIKit
    import CoreData

// NEW PICK INPUT VARIABLES

    public var gameTypeGlobal = "NYLotto"
    public var dateGlobal = ""
    public var numberGlobal = ["8", "8", "8", "8", "8", "8"]
    public var multiGlobal = false

    public var dateConvert = [
        ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        [Int](1...31),
        [Int](2010...2020)
    ]

// RESET NEW PICK INPUT VARIABLES

    public func resetNewPickInputVariables() {
        
        gameTypeGlobal = "NYLotto"
        dateGlobal = ""
        numberGlobal = ["8", "8", "8", "8", "8", "8"]
        multiGlobal = false
        
        println("resetNewPickInputVariables() called: All new pick input variables have been reset") // Report
        
    }

// BEFORE LOGIN VARIABLE

    public var beforeLoginVariable = ""

// RESET BEFORE LOGIN VARIABLE

    public func resetBeforeLoginVariable() {
        
        beforeLoginVariable = ""
        
        println("resetBeforeLoginVariable() called: beforeLoginVariable has been reset") // Report

    }

// BEFORE HISTORY VARIABLE

public var beforeHistoryVariable = ""

// RESET BEFORE HISTORY VARIABLE

public func resetBeforeHistoryVariable() {
    
    beforeHistoryVariable = ""
    
    println("resetBeforeHistoryVariable() called: beforeHistoryVariable has been reset") // Report
    
}

// NORMALIZE GAME NAMES

public func cleanGameTypeInput(gameTypeGlobal: String) -> String {
    println(gameTypeGlobal)
    if (gameTypeGlobal == "Megamillions")
    {
        return "MegaMillions"
    }
    else if (gameTypeGlobal == "NYLotto")
    {
        return "NyLotto"
    }
    return gameTypeGlobal
}
