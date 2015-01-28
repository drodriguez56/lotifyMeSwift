//
//  HistoryTableViewController.swift
//  LotifyMe
//
//  Created by Carl Schubert on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // SHOW PICKS GET REQUEST
    
    func showPicksGetRequest() {
        
        struct Status : JSONJoy {
            var status: String?
            init() {
                
            }
            init(_ decoder: JSONDecoder) {
                status = decoder["status"].string
            }
        }
        
        var getRequest = HTTPTask()
        
        let pick: Dictionary<String,String> = [
            "email": "\(retrieveSession())",
        ]
        
        let params: Dictionary<String,AnyObject> = [
            "pick": pick
        ]

        var keepCheckingGetRequestStatus = true
        var getRequestStatus = ""
        
        getRequest.GET(
            "\(rootPath)/picks",
            parameters: params,
            success: {
                (response: HTTPResponse) in
                println("showPicksGetRequest() called: Server returned success") // Report
                if response.responseObject != nil {
                    let resp = Status(JSONDecoder(response.responseObject!))
                    self.showPicksGetRequestResponseParser("\(response.text())")
                    getRequestStatus = "success"
                } else {
                    println("Uncaught exception: Server returned success without a response (force quit)") // Report
                }
            },
            failure: {
                (error: NSError, response: HTTPResponse?) in
                println("showPicksGetRequest() called: Server returned failure") // Report
                getRequestStatus = "failure"
            }
        )
        
        while keepCheckingGetRequestStatus == true {
            if getRequestStatus == "success" {
                keepCheckingGetRequestStatus = false
                tableView.reloadData()
            } else if getRequestStatus == "failure" {
                keepCheckingGetRequestStatus = false
            }
        }
        
    }
    
    // SHOW PICKS GET REQUEST RESPONSE PARSER
    
    func showPicksGetRequestResponseParser(jsonAsString: String) -> [pick] {

        var jsonAsStringClean = jsonAsString.stringByReplacingOccurrencesOfString(
            "result\\\":null",
            withString: "result\\\":\\\"No Result\\\"",
            options: NSStringCompareOptions.LiteralSearch,
            range: nil
        )

        var jsonCharset = NSCharacterSet(charactersInString: "\\\"")
        var jsonAsArray = jsonAsStringClean.componentsSeparatedByCharactersInSet(jsonCharset)

        if (jsonAsArray.count - 3) % 64 == 0 {

            var numberOfPicks = (jsonAsArray.count - 3) / 64

            for (var i = 0; i < numberOfPicks; i++) {

                var pick_id_raw = jsonAsArray[5 + i * 64] as NSString
                var pick_id = pick_id_raw.substringWithRange(NSRange(location: 1, length: pick_id_raw.length - 2))
                var game = jsonAsArray[11 + i * 64]
                var result = jsonAsArray[19 + i * 64]
                var number = jsonAsArray[47 + i * 64]
                var draw_date_raw = jsonAsArray[55 + i * 64] as NSString
                var draw_date = draw_date_raw.substringWithRange(NSRange(location: 0, length: 10))
                
                pickMGR.addPick(pick_id, number: number, draw_date: draw_date, result: result, game: game)

            }
            
        }
        
        return pickMGR.picks
        
    }
    
    // SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPicksGetRequest()
        
    }
    
    
    // TABEL CELL FUNCS
    
    @IBOutlet var historyTableView: UITableView!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return pickMGR.picks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: PickCell = tableView.dequeueReusableCellWithIdentifier("PickCell") as PickCell
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor.purpleColor()
        }
        else
        {
           cell.backgroundColor = UIColor.orangeColor()
        }
        
  
        cell.leftTopLable?.text = pickMGR.picks[indexPath.row].game
        cell.leftBottomLabel?.text = pickMGR.picks[indexPath.row].draw_date
        cell.rightTopLabel?.text = pickMGR.picks[indexPath.row].number
        cell.rightBottomLable?.text = pickMGR.picks[indexPath.row].result
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            
            // DELETE PICK DELETE REQUEST
            
            struct Status : JSONJoy {
                var status: String?
                init() {
                    
                }
                init(_ decoder: JSONDecoder) {
                    status = decoder["status"].string
                }
            }

            var currentView = self
        
            var deleteRequest = HTTPTask()
            
            let params: Dictionary<String,AnyObject> = [
                "id": pickMGR.picks[indexPath.row].pick_id
            ]
            
            var keepCheckingDeleteRequestStatus = true
            var deleteRequestStatus = ""
            
            deleteRequest.DELETE(
                "\(rootPath)/picks/\(pickMGR.picks[indexPath.row].pick_id)",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("deletePickDeleteRequest() called: Server returned success") // Report
                    if "\(response.text())" == "Optional(\"pick destroyed\")" {
                        println("Server response: Pick successfully deleted") // Report
                        deleteRequestStatus = "success"
                    } else {
                        println("Uncaught exception: Server response is nil") // Report
                        alert(
                            "Oops",
                            "Looks like something went wrong. Please pull to refresh.",
                            currentView
                        )
                    }
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Response from server has content: \(response.text())") // Report
                    }
                },
                failure: {
                    (error: NSError, response: HTTPResponse?) in
                    println("deletePickDeleteRequest() called: Server returned failure") // Report
                    deleteRequestStatus = "failure"
                    if "\(response?.text())" == "Optional(\"pick not found\")" {
                        println("Reason for failure: Invalid pick, no deletion executed") // Report
                        alert(
                            "Oops",
                            "Looks like something went wrong. Please pull to refresh.",
                            currentView
                        )
                    } else if "\(response?.text())" == "nil" {
                        println("Reason for failure: Cannot contact server") // Report
                        alert(
                            "No Internet Connection",
                            "Looks like you don't have a connection right now...",
                            currentView
                        )
                    } else {
                        println("Reason for failure: Uncaught exception") // Report
                        alert(
                            "Oops",
                            "Looks like something went wrong. Please try again!",
                            currentView
                        )
                    }
                }
            )
            
            while keepCheckingDeleteRequestStatus == true {
                if deleteRequestStatus == "success" {
                    keepCheckingDeleteRequestStatus = false
                    pickMGR.picks.removeAtIndex(indexPath.row)
                    println("Pick deleted locally") // Report
                    self.historyTableView.reloadData()
                    println("Pick table refreshed") // Report
                } else if deleteRequestStatus == "failure" {
                    keepCheckingDeleteRequestStatus = false
                }
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
