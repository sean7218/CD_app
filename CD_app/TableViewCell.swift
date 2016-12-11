//
//  TableViewCell.swift
//  CD_app
//
//  Created by Sean Zhang on 11/22/16.
//  Copyright © 2016 Sean Zhang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UILabel!
    @IBOutlet var tags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
