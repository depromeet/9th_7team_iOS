//
//  CustomOptionViewController.swift
//  myRecipick
//
//  Created by Min on 2021/05/19.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit

class CustomOptionViewController: UIViewController, ClassIdentifiable {

    static func makeViewController(menuID: String) -> CustomOptionViewController {
        let vm = CustomOptionViewModel(menuID: menuID)
        let vc = CustomOptionViewController(nibName: self.identifier, bundle: nil)
        vc.viewModel = vm
        return vc
    }
    
    @IBOutlet weak var navigationView: CustomNavigationView!
    @IBOutlet weak var tableTopView: UIView!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    var options: [OptionSection] = [
        OptionSection(title: "빵", items: [OptionItem(title: "빵1"), OptionItem(title: "빵2"), OptionItem(title: "빵3")]),
        OptionSection(title: "치즈", isSingleSelection: true, items: [OptionItem(title: "치즈1"), OptionItem(title: "치즈2"), OptionItem(title: "치즈3")]),
        OptionSection(title: "야채", items: [OptionItem(title: "야채1"), OptionItem(title: "야채2"), OptionItem(title: "야채3"), OptionItem(title: "야채4"), OptionItem(title: "야채5"), OptionItem(title: "야채6")]),
        OptionSection(title: "소스", isSingleSelection: true, items: [OptionItem(title: "소스1"), OptionItem(title: "소스2"), OptionItem(title: "소스3")]),
    ]
    
    lazy var dataSource = OptionDatasource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomOptionSubTitleCell.identifier, for: indexPath) as? CustomOptionSubTitleCell else { fatalError() }
        return cell
    } selectClosure: { [weak self] in
        self?.updateSnapshot()
    }
    
    private var viewModel: CustomOptionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationView()
        initCollectionView()
        updateSnapshot()
    }
    
    private func initNavigationView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationView.setTitle("메뉴 이름")
        navigationView.setLeftButtonImage("iconsNavigation24ArrowLeft")
        navigationView.leftButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        navigationView.setRightButtonImage("iconClose")
        navigationView.rightButton.addTarget(self, action: #selector(popToRootView(_:)), for: .touchUpInside)
    }
    
    private func initTableTopView() {
        tableTopView.backgroundColor = Colors.grayScaleEE.color
        resetView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(Colors.grayScale66.color, for: .normal)
        resetButton.titleLabel?.font = .myRecipickFont(.button)
    }
    
    private func initCollectionView() {
        collectionView.allowsMultipleSelection = true
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.register(UINib(nibName: CustomOptionTitleCell.identifier, bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: CustomOptionTitleCell.identifier)
        collectionView.register(UINib(nibName: CustomOptionSubTitleCell.identifier, bundle: nil), forCellWithReuseIdentifier: CustomOptionSubTitleCell.identifier)
    }
    
    private func initTableBottomView() {
        

    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layoutSize = NSCollectionLayoutSize.init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        
        let section = NSCollectionLayoutSection(group: .vertical(layoutSize: layoutSize,
                                                                 subitems: [.init(layoutSize: layoutSize)] ) )
        
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 0
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        
        section.boundarySupplementaryItems = [header]

        return .init(section: section)
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<OptionSection, OptionItem>()
        snapshot.appendSections(options)
        options.forEach {
            if $0.isExpanded {
                snapshot.appendItems($0.items, toSection: $0)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension CustomOptionViewController {
    
    @objc
    private func dismiss(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func popToRootView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


class OptionSection: Hashable {
    let title: String
    let isSingleSelection: Bool
    var isExpanded = false
    var items: [OptionItem] = []
    private let uuid = UUID()
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    init(title: String, isSingleSelection: Bool = false, items: [OptionItem]) {
        self.title = title
        self.isSingleSelection = isSingleSelection
        self.items = items
    }
    
    static func == (lhs: OptionSection, rhs: OptionSection) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

class OptionItem: Hashable {
    let title: String
    var isSelected = false
    private let uuid = UUID()
    
    public func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    init(title: String) {
        self.title = title
    }
    
    static func == (lhs: OptionItem, rhs: OptionItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

class OptionDatasource: UICollectionViewDiffableDataSource<OptionSection, OptionItem>, UICollectionViewDelegate {
    
    var headerSelectClosure: (() -> Void)?
    
    init(collectionView: UICollectionView,
         cellProvider: @escaping UICollectionViewDiffableDataSource<OptionSection, OptionItem>.CellProvider,
         selectClosure: (() -> Void)?) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        self.headerSelectClosure = selectClosure
        collectionView.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomOptionSubTitleCell.identifier, for: indexPath) as? CustomOptionSubTitleCell else { fatalError() }
        let item = self.itemIdentifier(for: indexPath)
        if item?.isSelected ?? false {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init(rawValue: 0))
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "header" {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomOptionTitleCell.identifier, for: indexPath) as? CustomOptionTitleCell else { fatalError("정의되지 않은 헤더입니다.") }
            let item = self.snapshot().sectionIdentifiers[indexPath.section]
            header.section = item
            header.tapObservable.subscribe(onNext: { [weak item, weak self] in
                guard let item = item, let self = self else { return }
                self.snapshot().sectionIdentifiers.forEach { $0.isExpanded = false }
                item.isExpanded = true
                self.headerSelectClosure?()
            }).disposed(by: header.disposeBag)
            return header
        }
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.itemIdentifier(for: indexPath)
        item?.isSelected = true
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let item = self.itemIdentifier(for: indexPath)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = self.snapshot().sectionIdentifiers[indexPath.section]
        if section.isSingleSelection {
            section.items.enumerated().forEach { (offset, item) in
                item.isSelected = false
                collectionView.deselectItem(at: IndexPath(item: offset, section: indexPath.section), animated: true)
            }
        }
        return true
    }
    
}

