//
//  BatchRunTableViewCell.swift
//  Arcstone Mobile
//
//  Created by Bilguun Batbold on 20/12/16.
//  Copyright © 2016 Bilguun. All rights reserved.
//

import UIKit

class BatchRunTableViewCell: UITableViewCell {

    @IBOutlet weak var name_text: UILabel!
    @IBOutlet var status_view: UIView!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
