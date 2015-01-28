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

        var keepCheckingForCompletion = true
        var getRequestCompleted = false
        
        getRequest.GET(
            "\(rootPath)/picks",
            parameters: params,
            success: {
                (response: HTTPResponse) in
                println("showPicksGetRequest() called: Server returned success") // Report
                if response.responseObject != nil {
                    let resp = Status(JSONDecoder(response.responseObject!))
                    self.showPicksGetRequestResponseParser("\(response.text())")
                    getRequestCompleted = true
                }
            },
            failure: {
                (error: NSError, response: HTTPResponse?) in
                println("showPicksGetRequest() called: Server returned failure") // Report
            }
        )
        
        while keepCheckingForCompletion == true {
            if getRequestCompleted == true {
                keepCheckingForCompletion = false
                tableView.reloadData()
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

                var game = jsonAsArray[11 + i * 64]
                var result = jsonAsArray[19 + i * 64]
                var number = jsonAsArray[47 + i * 64]
                var draw_date_raw = jsonAsArray[55 + i * 64] as NSString
                var draw_date = draw_date_raw.substringWithRange(NSRange(location: 0, length: 10))

                
                pickMGR.addPick(number, draw_date: draw_date, result: result, game: game)
                
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
            pickMGR.picks.removeAtIndex(indexPath.row)
            self.historyTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
