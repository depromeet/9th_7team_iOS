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

class CustomOptionTitleCell: UICollectionViewCell, ClassIdentifiable {

    @IBOutlet weak var contentsView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var tooltipLabel: UILabel!
    
    var tapObservable: Observable<Void> {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabAction))
        contentsView.addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.map { _ in () }
    }
    var disposeBag = DisposeBag()
    
    // Configure
    var section: OptionSection? = nil {
        didSet {
            disposeBag = DisposeBag()
            titleLabel.text = section?.title
            descriptionLabel.text = section?.title
            tooltipLabel.text = "여러개 선택가능"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @objc private func tabAction() {
        
    }
}
