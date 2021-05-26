//
//  CustomViewController.swift
//  myRecipick
//
//  Created by hanwe lee on 2021/04/13.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomViewController: UIViewController, CoordinatorViewControllerProtocol, ClassIdentifiable {
    
    static func makeViewController(coordinator: CustomCoordinator) -> CustomViewController {
        let vc = CustomViewController(nibName: self.identifier, bundle: nil)
        vc.viewModel = CustomViewModel()
        vc.coordinator = coordinator
        return vc
    }
    
    typealias SelfType = CustomViewController
    typealias CoordinatorType = CustomCoordinator

    // MARK: outlet
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var menuCategoryView: MenuCategoryBar!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    // MARK: property
    
    var coordinator: CustomCoordinator!
    var viewModel: CustomViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: lifeCycle
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationView()
        initCategoryView()
        initCollectionView()
        bind()
        
        viewModel.fetchMenu(with: "fe544b1d-a2be-44d5-ab93-026b43e04eb5")
    }
    
    // MARK: func
    
    private func initNavigationView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.setTitle("메뉴선택")
        navigationView.setLeftButtonImage("iconsNavigation24ArrowLeft")
        navigationView.leftButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    
    private func initCategoryView() {
        menuCategoryView.delegate = self
        viewModel.menuListObservable
            .map { $0.map { $0.name } }
            .bind(to: menuCategoryView.categories)
            .disposed(by: disposeBag)
        menuCategoryView.moveIndicator(in: 0) // 서버에서 값 받아오면 바꾸기
    }
    
    private func initCollectionView() {
        menuCollectionView.register(UINib(nibName: MenuContainerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MenuContainerCollectionViewCell.identifier)
    }
    
}

// MARK: action

extension CustomViewController {
    @objc
    private func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension CustomViewController: MenuCategoryBarDelegate {
    func tapTabbar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        menuCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}


// MARK: - UICollectionViewDataSource
extension CustomViewController {
    
    private func bind() {
        disposeBag.insert(
            viewModel.menuListObservable.bind(to: menuCollectionView.rx.items(cellIdentifier: MenuContainerCollectionViewCell.identifier, cellType: MenuContainerCollectionViewCell.self)) { [weak self] index, element, cell in
                guard let self = self else { return }
                let item = element.menus
                cell.menuList(list: item, on: self)
            },
            menuCollectionView.rx.setDelegate(self)
        )
    }
}

// MARK: - UICollectionViewDelegate

extension CustomViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        menuCategoryView.moveIndicator(in: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CustomViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: menuCollectionView.frame.width, height: menuCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
