//
//  HistoryTableViewController.swift
//  LotifyMe
//
//  Created by Carl Schubert on 1/26/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var picks = [Pick]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var newPick = Pick(number: "11 11 11 11 11 11", draw_date: "24-01-2015", result: "jackpot")
        picks.append(newPick)
        
        newPick = Pick(number: "11 11 11 11 11 11", draw_date: "24-01-2015", result: "Win $100")
        picks.append(newPick)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        return picks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pickCell", forIndexPath: indexPath) as UITableViewCell
        var currentPick = picks[indexPath.row]
        cell.textLabel?.text = currentPick.result
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
