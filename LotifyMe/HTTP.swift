//
//  HTTP.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import Foundation

// NEW PICK POST REQUEST FUNCTION

    func newPickPostRequest(popupViewControllerCallingViewController: AnyObject) {

        struct Status : JSONJoy {
            var status: String?
            init() {
                
            }
            init(_ decoder: JSONDecoder) {
                status = decoder["status"].string
            }
        }
        
        var postRequest = HTTPTask()
        
        let pick: Dictionary<String,String> = [
            "email": "\(retrieveSession())",
            "game": gameTypeGlobal,
            "draw_date": dateGlobal,
            "number1": numberGlobal[0],
            "number2": numberGlobal[1],
            "number3": numberGlobal[2],
            "number4": numberGlobal[3],
            "number5": numberGlobal[4],
            "number6": numberGlobal[5],
            "multiplier": "\(multiGlobal)"
        ]
        
        let params: Dictionary<String,AnyObject> = [
            "pick": pick
        ]
        
        postRequest.POST(
            "\(rootPath)/picks",
            parameters: params,
            success: {
                (response: HTTPResponse) in
                println("newPickPostRequest() called: Server returned success") // Report
                if oldTicket(dateGlobal) == 1 {
                    var jsonAsString = "\(response.text())" as String
                    var result = jsonParseOldTicket(jsonAsString)
                    alert(
                        "Game Results",
                        "This game has already been drawn, and your result is: \(result). Best of luck as always!",
                        popupViewControllerCallingViewController
                    )
                } else {
                    alert(
                        "\(gameTypeGlobal) Pick Submitted",
                        "You will receive an email at \(retrieveSession()) when the results come out.",
                        popupViewControllerCallingViewController
                    )
                }
                if response.responseObject != nil {
                    let resp = Status(JSONDecoder(response.responseObject!))
                    println("Response from server has content: \(response.text())") // Report
                    resetNewPickInputVariables()
                    println("Expecting resetNewPickInputVariables() to have been called") // Report
                }
            },
            failure: {
                (error: NSError, response: HTTPResponse?) in
                println("newPickPostRequest() called: Server returned failure") // Report
                alert(
                    "Duplicate Pick",
                    "Looks like you've already submitted that pick before...",
                    popupViewControllerCallingViewController
                )
            }
        )
        
    }