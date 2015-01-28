//
//  PickManager.swift
//  LotifyMe
//
//  Created by Carl Schubert on 1/27/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

import UIKit

var pickMGR: PickManager = PickManager()

struct pick {
    var number : String
    var draw_date : String
    var result : String
    var game : String
}

class PickManager: NSObject {

    var picks = [pick]()
    
    func addPick(number: String, draw_date: String, result: String, game: String){
        picks.append(pick(number: number, draw_date: draw_date, result: result, game: game))
    }
}
