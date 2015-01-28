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
    var pick_id : String
    var number : String
    var draw_date : String
    var result : String
    var game : String
}

class PickManager: NSObject {

    var picks = [pick]()
    
    func addPick(pick_id: String, number: String, draw_date: String, result: String, game: String){
        picks.append(pick(pick_id: pick_id, number: number, draw_date: draw_date, result: result, game: game))
//        for i in picks {
//            println(i.pick_id)
//            
//            if i.pick_id == pick_id
//            {
//               println("if")
//            }
//            else
//            {
//                println("else")
//                
//            }
//        }
    }
}
