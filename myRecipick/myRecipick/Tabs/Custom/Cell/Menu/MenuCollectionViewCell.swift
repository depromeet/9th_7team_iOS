//
//  MenuCollectionViewCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/17.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(with item: String) {
        titleLabel.text = item
    }

}
