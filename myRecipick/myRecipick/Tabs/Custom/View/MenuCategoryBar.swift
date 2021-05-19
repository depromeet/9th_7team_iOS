//
//  MenuCategoryBar.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol MenuCategoryBarDelegate: AnyObject {
    func tapTabbar(scrollTo index: Int)
}

class MenuCategoryBar: BaseCustomView {
    
    @IBOutlet weak var tabbarCollectionView: UICollectionView!
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.primaryNormal.color
        return view
    }()
    
    let categories = BehaviorRelay<[String]>(value: [])
    var disposeBag = DisposeBag()
    
    weak var delegate: MenuCategoryBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initTabBar()
        bind()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initTabBar()
        bind()
    }
    
    private func initTabBar() {
        initCollectionView()
        addSubview(indicatorView)
        indicatorView.snp.updateConstraints { snp in
            snp.height.equalTo(2)
            snp.width.equalTo((self.frame.width / 4) - 24)
            snp.leading.equalTo(self.snp.leading).offset(12 + 12)
            snp.bottom.equalTo(self.snp.bottom)
        }
    }
    
    private func initCollectionView() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        tabbarCollectionView.collectionViewLayout = collectionViewFlowLayout
        tabbarCollectionView.register(UINib(nibName: MenuCategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MenuCategoryCollectionViewCell.identifier)
    }
    
    func moveIndicator(in index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        tabbarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        indicatorView.snp.updateConstraints { snp in
            snp.leading.equalTo(self.snp.leading).offset((Int(self.frame.width) / 4) * index + 12 + 12)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

extension MenuCategoryBar {
    
    private func bind() {
        disposeBag.insert(
            categories.asObservable()
                .bind(to: tabbarCollectionView.rx.items(cellIdentifier: MenuCategoryCollectionViewCell.identifier, cellType: MenuCategoryCollectionViewCell.self)) { index, element, cell in
                    if index == 0 { cell.isSelected = true }
                    cell.bind(element)
                },
            tabbarCollectionView.rx.setDelegate(self),
            tabbarCollectionView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.moveIndicator(in: indexPath.item)
                self.delegate?.tapTabbar(scrollTo: indexPath.item)
            }),
            
            tabbarCollectionView.rx.itemDeselected.bind(onNext: { [weak self] indexPath in
                guard let cell = self?.tabbarCollectionView.cellForItem(at: indexPath) as? MenuCategoryCollectionViewCell else { return }
                cell.titleLabel.textColor = Colors.grayScale66.color
            })
        )
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension MenuCategoryBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4, height: 50)
    }
}
