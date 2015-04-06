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
            "game": cleanGameTypeInput(gameTypeGlobal),
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
        
        println("Ready to send postRequest for Pick#create, with the following parameters: \(params)") // Report
        
        postRequest.POST(
            "\(rootPath)/picks",
            parameters: params,
            success: {
                (response: HTTPResponse) in
                println("newPickPostRequest() called: Server returned success") // Report
                println("*")
                println(response.text())
                var jsonAsString = "\(response.text())" as String
                if oldTicket(jsonParseOldTicketDate(jsonAsString)) == 1 {
                    var result = jsonParseOldTicketResult(jsonAsString)
                    alert(
                        "Game Results",
                        "This game has already been drawn, and your result is: \(result). Best of luck as always!",
                        popupViewControllerCallingViewController
                    )
                } else {
                    alert(
                        "\(gameTypeGlobal) Ticket Submitted",
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
                if "\(response?.text())" == "Optional(\"fail to create pick\")" {
                    println("Reason for failure: Invalid pick, server rollback") // Report
                    alert(
                        "Duplicate Ticket",
                        "Looks like you've already submitted that ticket before...",
                        popupViewControllerCallingViewController
                    )
                } else if "\(response?.text())" == "nil" {
                    println("Reason for failure: Cannot contact server") // Report
                    alert(
                        "No Internet Connection",
                        "Looks like you don't have a connection right now...",
                        popupViewControllerCallingViewController
                    )
                } else {
                    println("Reason for failure: Uncaught exception") // Report
                    alert(
                        "Oops",
                        "Looks like something went wrong. Please try again!",
                        popupViewControllerCallingViewController
                    )
                }
            }
        )
        
    }