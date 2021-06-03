//
//  CustomOptionSubTitleCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/21.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class CustomOptionSubTitleCell: UICollectionViewCell, ClassIdentifiable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    
    var optionModel: OptionModel?
    weak var vc: UIViewController?
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? Colors.primaryNormal.color : Colors.grayScale66.color
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
        questionButton.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLabel()
    }
    
    private func initLabel() {
        titleLabel.text = nil
        titleLabel.textColor = Colors.grayScale66.color
        titleLabel.font = .myRecipickFont(.body2)
        questionButton.isHidden = true
    }
    
    func bind(item: OptionModel) {
        optionModel = item
        titleLabel.text = item.name
        switch item.type {
        case .check:
            imageView.image = Images.uncheckBox.image
            imageView.highlightedImage = Images.checkBox.image
        case .radio:
            imageView.image = Images.editNonCheck.image
            imageView.highlightedImage = Images.editCheck.image
        default:
            imageView.image = nil
            imageView.highlightedImage = nil
        }
        
        if item.calorie != nil || item.description != nil {
            questionButton.isHidden = false
        }
        
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        guard let item = optionModel else { return }
        if let baseVC = vc as? CustomOptionViewController {
            let vc = OptionInfoViewController.makeViewController(item: item)
            baseVC.present(vc, animated: true, completion: nil)
        }
    }
    
}
