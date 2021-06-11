//
//  BrandSelectViewController.swift
//  myRecipick
//
//  Created by hanwe lee on 2021/04/20.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BrandSelectViewControllerDelegate: AnyObject {
    func pushRequestBrandViewController()
}

class BrandSelectViewController: UIViewController, MVVMViewControllerProtocol, ClassIdentifiable, ActivityIndicatorable {
    
    typealias SelfType = BrandSelectViewController
    typealias MVVMViewModelClassType = BrandSelectViewModel

    // MARK: outlet
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContentsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomIconImageView: UIImageView!
    @IBOutlet weak var bottomContentsLabel: UILabel!
    
    
    // MARK: property
    var disposeBag: DisposeBag = DisposeBag()
    
    var isViewModelBinded: Bool = false
    var viewModel: BrandSelectViewModel!
    
    weak var delegate: BrandSelectViewControllerDelegate?
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.collectionView.register(UINib(nibName: BrandSelectCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BrandSelectCollectionViewCell.identifier)
        bindingViewModel(viewModel: self.viewModel)
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    func bind(viewModel: MVVMViewModel) {
        if type(of: viewModel) == BrandSelectViewModel.self {
            guard let vm: BrandSelectViewModel = (viewModel as? BrandSelectViewModel) else { return }
            
            vm.outputs.isLoading
                .subscribe(onNext: { [weak self] in
                    if $0 {
                        self?.startIndicatorAnimating()
                    } else {
                        self?.stopIndicatorAnimating()
                    }
                })
                .disposed(by: self.disposeBag)
            
            vm.outputs.brands
                .observe(on: MainScheduler.instance)
                .bind(to: self.collectionView.rx.items(cellIdentifier: BrandSelectCollectionViewCell.identifier, cellType: BrandSelectCollectionViewCell.self)) { index, element, cell in
                    cell.infoData = element
                }
                .disposed(by: self.disposeBag)
            
            self.collectionView.rx.itemSelected
                .subscribe(onNext: { index in
                    print("index: \(index)")
                })
                .disposed(by: self.disposeBag)
            
        }
    }
    
    // MARK: func
    
    static func makeViewController(viewModel: BrandSelectViewModel) -> BrandSelectViewController? {
        let brandSelectViewController: BrandSelectViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: BrandSelectViewController.identifier)
        brandSelectViewController.viewModel = viewModel
        return brandSelectViewController
    }
    
    func initUI() {
        self.backgroundContainerView.backgroundColor = UIColor(asset: Colors.white)
        self.mainContainerView.backgroundColor = .clear
        
        self.topContainerView.backgroundColor = .clear
        self.topContentsLabel.font = UIFont.myRecipickFont(.subTitle1)
        self.topContentsLabel.textColor = UIColor(asset: Colors.grayScale33)
        self.topContentsLabel.text = "브랜드 변경"
        
        self.bottomContainerView.backgroundColor = .clear
        self.bottomContentsLabel.font = UIFont.myRecipickFont(.subTitle1)
        self.bottomContentsLabel.textColor = UIColor(asset: Colors.primaryNormal)
        self.bottomContentsLabel.text = "브랜드 추가 요청"
        
        self.bottomIconImageView.image = self.bottomIconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.bottomIconImageView.tintColor = UIColor(asset: Colors.primaryNormal)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 21
        layout.itemSize = CGSize(width: 74, height: 111)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: action
    @IBAction func requestNewBrandAction(_ sender: Any) {
        self.dismiss(animated: false, completion: { [weak self] in
            self?.delegate?.pushRequestBrandViewController()
        })
    }
    
}
