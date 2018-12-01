//
//  myDataTableViewCell.swift
//  tvOS-SpriteKit-Assignment
//
//  Created by Jatin Rampal on 2018-11-28.
//  Copyright © 2018 Jatin Rampal. All rights reserved.
//

import UIKit

class myDataTableViewCell: UITableViewCell {

    @IBOutlet var myName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
