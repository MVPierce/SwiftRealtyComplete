//
//  CustomHomeTableViewCell.swift
//  SwiftRealty
//
//  Created by Pierce on 1/24/17.
//  Copyright © 2017 Pierce. All rights reserved.
//

import UIKit

class CustomHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellContent(address: String, price: Double) {
        
        addressLabel.text = address
        priceLabel.text = "$\(price)"
        
    }
    
}
