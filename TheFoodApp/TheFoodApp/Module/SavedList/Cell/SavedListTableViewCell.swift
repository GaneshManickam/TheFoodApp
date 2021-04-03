//
//  SavedListTableViewCell.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import UIKit

class SavedListTableViewCell: UITableViewCell {

    @IBOutlet weak var receipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SavedListTableViewCell {
    /**
     Function to update cell by receipe value
     - PARAMETER receipe: Instance of `ReceipeDetailResponse`
     */
    func updateCellBy(_ receipe: ReceipeDetailResponse) {
        self.titleLabel.text = receipe.strMeal ?? ""
        var categoryName = receipe.strCategory ?? ""
        if !categoryName.isEmpty {
            categoryName += " "
        }
        if let areaName = receipe.strArea, !areaName.isEmpty {
            categoryName += "(\(areaName))"
        }
        
        self.subTitleLabel.text = categoryName
        if let imgUrl = URL(string: receipe.strMealThumb ?? "") {
            self.receipeImageView.kf.setImage(with: imgUrl)
        }
        
        self.receipeImageView.layer.cornerRadius = 5
        self.receipeImageView.clipsToBounds = true

    }
}
