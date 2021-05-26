//
//  MenuListViewController.swift
//  myRecipick
//
//  Created by Min on 2021/05/14.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuListViewController: UIViewController, ClassIdentifiable {
    
    static func makeViewController(menuList: [MenuModel], parentVC: UIViewController? = nil) -> MenuListViewController {
        let vm = MenuListViewModel(menuList: menuList)
        let vc = MenuListViewController(nibName: MenuListViewController.identifier, bundle: nil)
        vc.parentVC = parentVC
        vc.viewModel = vm
        return vc
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var parentVC: UIViewController?
    
    var viewModel: MenuListViewModel!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        bind()
    }
    
    private func initCollectionView() {
        collectionView.register(UINib(nibName: MenuCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
    }
}

extension MenuListViewController {
    
    private func bind() {
        disposeBag.insert(
            viewModel.menuListObservable
                .bind(to: collectionView.rx
                        .items(cellIdentifier: MenuCollectionViewCell.identifier,
                               cellType: MenuCollectionViewCell.self)) { index, element, cell in
                    cell.bind(with: element)
                },
            collectionView.rx.setDelegate(self),
            collectionView.rx.modelSelected(MenuModel.self)
                .bind(onNext: { [weak self] item in
                print(item)
                guard let parentVC = self?.parentVC as? CustomViewController else { return }
                    let vc = CustomOptionViewController.makeViewController(menuID: item.id)
                parentVC.navigationController?.pushViewController(vc, animated: true)
                
            })
        )
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 48, height: view.frame.width / 2 - 48)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
