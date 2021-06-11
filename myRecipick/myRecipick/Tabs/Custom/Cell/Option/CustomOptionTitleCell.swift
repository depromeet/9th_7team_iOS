//
//  CustomOptionTitleCell.swift
//  myRecipick
//
//  Created by Min on 2021/05/21.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class CustomOptionTitleCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var tooltip: UIImageView!
    
    var tapObservable: Observable<Void> {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabAction))
        contentsView.addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.map { _ in () }
    }
    var disposeBag = DisposeBag()
    var cancellable: Cancellable?
    
    // Configure
    var section: OptionSection? = nil {
        didSet {
            disposeBag = DisposeBag()
            titleLabel.text = section?.option.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initLabels()
        initToolTip()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Combine
    func bindArrayDirection() {
        cancellable = section?.$isExpanded.sink(receiveValue: { [weak self] isExpanded in
            self?.rotateArrowAnimation(isExpanded: isExpanded)
            self?.tooltipAnimation(isExpanded: isExpanded)
        })
    }
    
    private func rotateArrowAnimation(isExpanded: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = isExpanded ? self.arrowImageView.transform.rotated(by: .pi) : .identity
        }
    }
    
    private func tooltipAnimation(isExpanded: Bool) {
        guard let section = self.section else { return }
        UIView.transition(with: self.tooltip, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tooltip.isHidden = section.isSingleSelection ? section.isSingleSelection : !isExpanded
        })
    }
    
    private func initLabels() {
        titleLabel.text = nil
        titleLabel.font = .myRecipickFont(.subTitle2)
        titleLabel.textColor = Colors.grayScale33.color
        
        optionLabel.text = nil
        optionLabel.font = .myRecipickFont(.caption)
        optionLabel.textColor = Colors.primaryNormal.color
        optionLabel.isHidden = true
        
        arrowImageView.image = Images.iconsNavigation24ArrowClose.image.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = Colors.grayScale99.color
    }
    
    private func initToolTip() {
        tooltip.isHidden = true
    }
    
    func updateSelectedMenu(with names: String) {
        optionLabel.isHidden = names.isEmpty
        optionLabel.text = names
    }
    
    @objc private func tabAction() {
//        UIView.animate(withDuration: 0.5) {
//            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
//
//        }
    }
}
