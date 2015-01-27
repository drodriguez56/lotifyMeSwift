//
//  UserAuthSession.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/25/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation
    import UIKit
    import CoreData

    public var currentUserEmailOrUsernameAttempt = [""]

    public func resetCurrentUserEmailOrUsernameAttempt() {
        currentUserEmailOrUsernameAttempt[0] = ""
        println("resetCurrentUserEmailOrUsernameAttempt() called: currentUserEmailOrUsernameAttempt variable has been reset") // Report
    }

// LOGIN SESSION FUNCTION

    public func instantiateSession(currentUserEmailOrUsername: String) {
        
        killSession()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName(
            "Session",
            inManagedObjectContext: managedContext
        )
        
        let session = NSManagedObject(
            entity: entity!,
            insertIntoManagedObjectContext: managedContext
        )
        
        session.setValue(currentUserEmailOrUsername, forKey: "currentUserEmailOrUsername")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("#SessionError: Could not save \(error), \(error?.userInfo)")
        }
        
        // Report
        let fetchRequest = NSFetchRequest(entityName:"Session")
        var postError: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &postError) as [NSManagedObject]?
        if let results = fetchedResults {
            println("instantiateSession(\(currentUserEmailOrUsername)) executed: Session length should be: 1, and is \(results.count)")
        } else {
            println("instantiateSession(\(currentUserEmailOrUsername)) executed: Session could not be fetched")
        }
        
    }

// GET SESSION FUNCTION

    public func retrieveSession() -> String {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(
            entityName:"Session"
        )
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(
            fetchRequest,
            error: &error
            ) as [NSManagedObject]?
        
        if let results = fetchedResults {
            if results.count == 1 {
                var user = results.first?.valueForKey("currentUserEmailOrUsername") as NSString
                println("retrieveSession() executed: Session length is \(results.count), and user is \(user)") // Report
                return user
            } else if results.count == 0 {
                println("retrieveSession() executed: Session length is \(results.count), and nilUser dummy returned") // Report
                return "nilUser"
            } else {
                println("retrieveSession() executed: Session length is \(results.count), error in session length") // Report
                return "#Error"
            }
        } else {
            println("retrieveSession() executed: Session could not be fetched") // Report
            return "#Error"
        }

    }

// LOGOUT SESSION FUNCTION

    public func endSession() {
        
        killSession()
        instantiateSession("nilUser")
        
    }

// FORCE KILL SESSION FUNCTION

    public func killSession() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        var fetchRequest = NSFetchRequest(
            entityName:"Session"
        )
        
        var error: NSError?
        
        var fetchedResults = managedContext.executeFetchRequest(
            fetchRequest,
            error: &error
            ) as [NSManagedObject]?
        
        if let results = fetchedResults? {
            for item in results {
                managedContext.deleteObject(item)
            }
            managedContext.save(&error)
            println("killSession() executed: Session length should be: 0, and is \(results.count)") // Report
        }
        
    }

// LOGIN JSON PARSER

    public func jsonParseEmail(jsonAsString: String) -> String {

        var jsonAsStringClean = jsonAsString.stringByReplacingOccurrencesOfString(
            "\\\":null",
            withString: "\\\":\\\"None\\\"",
            options: NSStringCompareOptions.LiteralSearch,
            range: nil
        )
        
        var jsonCharset = NSCharacterSet(charactersInString: "\\\"")
        var jsonAsArray = jsonAsStringClean.componentsSeparatedByCharactersInSet(jsonCharset)

        var username = jsonAsArray[11]
        var phone = jsonAsArray[19]
        var email = jsonAsArray[27]
        
        return email

    }

// NEW PICK JSON PARSER

    public func jsonParseOldTicket(jsonAsString: String) -> String {
        
        var jsonAsStringClean = jsonAsString.stringByReplacingOccurrencesOfString(
            "result\\\":null",
            withString: "result\\\":\\\"No Result\\\"",
            options: NSStringCompareOptions.LiteralSearch,
            range: nil
        )
        
        var jsonCharset = NSCharacterSet(charactersInString: "\\\"")
        var jsonAsArray = jsonAsStringClean.componentsSeparatedByCharactersInSet(jsonCharset)

        var result = jsonAsArray[19]
        
        return result
        
    }
