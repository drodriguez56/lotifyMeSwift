//
//  Session.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/25/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation
    import CoreData

    class Session: NSManagedObject {

        @NSManaged var currentUserEmail: String
        
    }