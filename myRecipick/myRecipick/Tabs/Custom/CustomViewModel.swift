//
//  CustomViewModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/17.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CustomViewModel {
    
    private let menuList = BehaviorRelay<[MenuCategoryModel]>(value: [])
    
    var menuListObservable: Observable<[MenuCategoryModel]> {
        return menuList.asObservable()
    }
    
    var disposeBag = DisposeBag()

    func fetchMenu(with brandID: String) {
        var httpRequest = HttpRequest()
        httpRequest.url = "brands/\(brandID)/menus"

        ServerUtil.shared.rx.requestRx(with: httpRequest)
            .subscribe(onNext: { [weak self ] (data: MenuDataModel) in
                self?.menuList.accept(data.data)
            }) { error in
                print("error -> \(error)")
            }.disposed(by: disposeBag)
    }
    
}
