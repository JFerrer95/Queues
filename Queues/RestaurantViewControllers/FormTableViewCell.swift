//
//  FormTableViewCell.swift
//  Queues
//
//  Created by Jonathan Ferrer on 7/31/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var seatingOptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
}
