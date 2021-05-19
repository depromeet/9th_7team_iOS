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
    
    private let menuList = BehaviorRelay<[String: Any]>(value: [:])
    
    var menuListObservable: Observable<[String: Any]> {
        return menuList.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    init() {
        menuList.accept([
            "샌드위치": ["로스트 치킨 베이컨", "로스트 치킨 아보카도", "로스트 치킨", "스테이크 & 치즈"],
            "찹샐러드": ["로스트 치킨", "스테이크 & 치즈", "터키베이컨 아보카도", "로티세리 치킨"]
        ])
    }
    
//    func fetchMenu(with brandID: String) {
//        var httpRequest = HttpRequest()
//        httpRequest.url = "brands/\(brandID)/menus"
//
//        ServerUtil.shared.rx.requestRx(with: httpRequest)
//            .subscribe(onNext: { (data: MenuDataModel) in
//                print(data)
//
//            }) { error in
//                print("error -> \(error)")
//            }.disposed(by: disposeBag)
//
//    }
    
}
