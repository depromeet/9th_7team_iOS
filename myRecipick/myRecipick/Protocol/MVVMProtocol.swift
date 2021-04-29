//
//  MVVMProtocol.swift
//  myRecipick
//
//  Created by hanwe on 2021/04/18.
//  Copyright © 2021 depromeet. All rights reserved.
//

import RxSwift

protocol MVVMViewControllerBaseProtocol: AnyObject {
    associatedtype MVVMViewModelClassType: MVVMViewModel
    
    var disposeBag: DisposeBag { get set }
    var isViewModelBinded: Bool { get set }
    var viewModel: MVVMViewModelClassType! { get set }
    
    func bind(viewModel: MVVMViewModel)
    func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T
}

extension MVVMViewControllerBaseProtocol {
    @discardableResult func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T {
        bind(viewModel: viewModel)
        viewModel.subscribeInputs()
        self.isViewModelBinded = true
        return viewModel
    }
}

protocol MVVMViewModel: AnyObject {
    var disposeBag: DisposeBag { get set }
    
    func subscribeInputs()
}

protocol MVVMViewControllerProtocol: MVVMViewControllerBaseProtocol {
    associatedtype SelfType: MVVMViewControllerBaseProtocol
    static func makeViewController(viewModel: MVVMViewModelClassType) -> SelfType?
}

