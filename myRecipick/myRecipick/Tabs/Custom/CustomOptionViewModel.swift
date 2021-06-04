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
    
    private let saveEnable = BehaviorRelay<Bool>(value: false)
    var saveEnableObservable: Observable<Bool> {
        saveEnable.asObservable()
    }
    
    let resetEnable = BehaviorRelay<Bool>(value: false)
    var resetEnableObservable: Observable<Bool> {
        resetEnable.asObservable()
    }
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var disposeBag = DisposeBag()
    
    init(menu: MenuModel) {
        self.menu = menu
    }
    
    func selectAction() -> Disposable {
        return Single.just(optionList.value)
            .map {
                $0.map { item -> Bool in
                    let selected = item.items.filter { $0.isSelected }
                    let policy = item.option.policy
                    if policy.max != 0 {
                        return (policy.max >= selected.count)
                            && (policy.min <= selected.count)
                    } else {
                        return true
                    }
                }
                .allSatisfy { $0 }
            }.subscribe(onSuccess: { isOn in
                self.saveEnable.accept(isOn)
            })
    }
    
    func resetEnableCheck() -> Disposable {
        return Single.just(optionList.value)
            .map {
                $0.map { item -> Bool in
                    let selected = item.items.filter { $0.isSelected }
                    return selected.isEmpty
                }
                .contains(true)
            }.subscribe(onSuccess: { isOn in
                self.resetEnable.accept(isOn)
            })
    }

    func fetchOption() {
        guard let menuItem = menu else { return }
        isLoading.accept(true)
        var httpRequest = HttpRequest()
        httpRequest.url = "menus/\(menuItem.id)/options"
        
        ServerUtil.shared.rx.requestRx(with: httpRequest)
            .do(onCompleted: { [weak self] in
                self?.isLoading.accept(false)
            })
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
    
    func saveCustomOption(with name: String, completion: @escaping (DetailService.DetailServiceInfoModel?) -> Void) {
        isLoading.accept(true)
        var httpRequest = HttpRequest()
        httpRequest.url = "my/custom-menus"
        httpRequest.method = .post
        httpRequest.headers = .customMenus(uniqueId: UniqueUUIDManager.shared.uniqueUUID)
        httpRequest.parameters = setCustomModel(with: name)?.dictionary

        ServerUtil.shared.rx.requestRx(with: httpRequest)
            .subscribe(onNext: { [weak self] (data: MenuResponseModel<MadeOptionModel>) in
                self?.isLoading.accept(false)
                let item = self?.mapData(with: data.data, menuName: name)
                completion(item)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
      
    }
    
    private func mapData(with data: MadeOptionModel, menuName: String) -> DetailService.DetailServiceInfoModel? {
        guard let menu = menu else { return nil }
        let value = optionList.value.map { list -> CustomMenuDetailOptionGroupObjModel in
            let item = list.items.map { item -> CustomMenuDetailOptionGroupOptionsObjModel in
                return CustomMenuDetailOptionGroupOptionsObjModel(name: item.item.name, imageUrl: item.item.image, category: nil)
            }
            return CustomMenuDetailOptionGroupObjModel(id: list.option.id, name: list.option.name, imageUrl: list.option.image, options: item)
        }
        return DetailService.DetailServiceInfoModel(customMenuDetailObjModel: CustomMenuDetailObjModel(id: data.id,
                                                                                                       userId: UniqueUUIDManager.shared.uniqueUUID,
                                                                                                       name: menuName,
                                                                                                       optionGroups: value,
                                                                                                       createdDate: data.createdDate,
                                                                                                       updatedDate: data.updatedDate),
                                                    customMenuObjModel: CustomMenuObjModel(id: menu.id,
                                                                                           name: menu.name,
                                                                                           description: "",
                                                                                           imageUrl: menu.image,
                                                                                           createdDate: menu.createdDate))
    }
    
    private func setCustomModel(with name: String) -> CustomModel? {
        guard let menu = self.menu else { return nil }
        return CustomModel(name: name,
                           menu: CustomMenuModel(id: menu.id, name: menu.name, image: menu.image),
                           optionGroups: customMenuList())
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
