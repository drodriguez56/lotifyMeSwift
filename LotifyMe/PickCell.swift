//
//  pickCell.swift
//  LotifyMe
//
//  Created by Carl Schubert on 1/27/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

import UIKit

class PickCell: UITableViewCell {

    @IBOutlet weak var leftTopLable: UILabel!
    @IBOutlet weak var leftBottomLabel: UILabel!

    @IBOutlet weak var rightTopLabel: UILabel!
    @IBOutlet weak var rightBottomLable: UILabel!
    
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}