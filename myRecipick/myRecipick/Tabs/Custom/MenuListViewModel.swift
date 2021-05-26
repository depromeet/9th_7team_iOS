//
//  MenuListViewModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/17.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MenuListViewModel {
    
    private let menuList = BehaviorRelay<[MenuModel]>(value: [])
    
    var menuListObservable: Observable<[MenuModel]> {
        return menuList.asObservable()
    }
    
    init(menuList: [MenuModel]) {
        self.menuList.accept(menuList)
        
    }
    
}
