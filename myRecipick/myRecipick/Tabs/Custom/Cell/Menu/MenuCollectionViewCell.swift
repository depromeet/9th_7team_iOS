//
//  MenuCollectionViewCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/17.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import Kingfisher

class MenuCollectionViewCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
    }
    
    private func initLabel() {
        titleLabel.font = .myRecipickFont(.body2)
        titleLabel.textColor = Colors.grayScale66.color
    }
    
    func bind(with item: MenuModel) {
        titleLabel.text = item.name
        self.imageView.kf.setImage(with: URL(string: item.image),
                                   placeholder: nil,
                                   options: [.cacheMemoryOnly],
                                   completionHandler: { [weak self] _ in
                                    self?.imageView.fadeIn(duration: 0.1, completeHandler: nil)
                                   })
    }

}
