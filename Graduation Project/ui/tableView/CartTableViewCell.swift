//
//  CartTableViewCell.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 22.12.22.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    
    @IBOutlet weak var orderIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
