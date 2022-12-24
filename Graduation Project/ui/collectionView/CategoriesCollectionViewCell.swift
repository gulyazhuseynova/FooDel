//
//  CategoriesCollectionViewCell.swift
//  Graduation Project
//
//  Created by Gulyaz Huseynova on 19.12.22.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var categoriesImage: UIImageView!
    
    var category: String?
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                

                
                super.isSelected = true
            
                self.contentView.backgroundColor = .white
                self.contentView.layer.borderWidth = 2
                self.contentView.layer.borderColor = UIColor(named: "brown")?.withAlphaComponent(0.2).cgColor
                self.contentView.clipsToBounds = true
                self.contentView.layer.cornerRadius = self.contentView.frame.height / 10

//
            }else{
                super.isSelected = false
                
                self.contentView.backgroundColor = .clear
                self.contentView.layer.borderWidth = 0
                self.contentView.layer.shadowOpacity = 0
            }
        }
    }
}
