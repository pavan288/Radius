//
//  RadiusTableViewCell.swift
//  RadiusAssignment
//
//  Created by Pavan Powani on 30/08/18.
//  Copyright © 2018 Pavan Powani. All rights reserved.
//

import UIKit

class RadiusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var facilityLabel: UILabel!
    @IBOutlet weak var facilityImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
