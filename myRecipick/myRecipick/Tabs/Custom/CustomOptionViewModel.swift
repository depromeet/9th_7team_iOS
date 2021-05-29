//
//  CustomOptionViewModel.swift
//  myRecipick
//
//  Created by Min on 2021/05/19.
//  Copyright © 2021 depromeet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CustomOptionViewModel {
    var menu: MenuModel?
    
    private let optionList = BehaviorRelay<[OptionSection]>(value: [])
    var optionListObservable: Observable<[OptionSection]> {
        return optionList.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    init(menu: MenuModel) {
        self.menu = menu
    }
    
    func fetchOption() {
        guard let menuItem = menu else { return }
        var httpRequest = HttpRequest()
        httpRequest.url = "menus/\(menuItem.id)/options"
        
        ServerUtil.shared.rx.requestRx(with: httpRequest)
            .map({ (data: MenuResponseModel<[OptionKindModel]>) -> [OptionSection] in
                let sectionList = data.data.map { data -> OptionSection in
                    let optionList = data.options.map {
                        return OptionItem(item: $0)
                    }
                    return OptionSection(option: data, isSingleSelection: data.type == "SINGLE", items: optionList)
                }
                return sectionList
            })
            .bind(to: optionList)
            .disposed(by: disposeBag)
    }
    
    func saveCustomOption() {
        var httpRequest = HttpRequest()
        httpRequest.url = "my/custom-menus"
        httpRequest.method = .post
        httpRequest.headers = .customMenus(uniqueId: UniqueUUIDManager.shared.uniqueUUID)
        httpRequest.parameters = [
            "name": "테스트용",
            "menu": CustomMenuModel(id: menu?.id ?? "", name: menu?.name ?? "", image: menu?.image ?? "").toJSONString,
            "optionGroups": customMenuList().toJSONString
        ]
        
        ServerUtil.shared.rx.requestRx(with: httpRequest)
            .subscribe(onNext: { (data: String) in
                print(data)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
      
    }

    private func customMenuList() -> [CustomOptionGroupModel] {
        let item = optionList.value
            .map { option -> CustomOptionGroupModel in
            let selectedItem = option.items
                .compactMap { item -> CustomOptionModel? in
                    if item.isSelected {
                        return CustomOptionModel(image: item.item.image, name: item.item.name)
                    } else {
                        return nil
                    }
                }
            return CustomOptionGroupModel(id: option.option.id, name: option.option.name, options: selectedItem)
            
        }
        return item
    }
    
}
