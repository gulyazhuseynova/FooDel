//
//  FoodTableViewCell.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 20.12.22.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnAddToCart(_ sender: Any) {
    }
}
