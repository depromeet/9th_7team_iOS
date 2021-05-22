//
//  MenuCategoryCollectionViewCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class MenuCategoryCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.textColor = isSelected ? Colors.primaryNormal.color : Colors.grayScale66.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLabel()
    }
    
    private func initLabel() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = Colors.grayScale66.color
    }
    
    func bind(_ title: String) {
        titleLabel.text = title
    }

}
