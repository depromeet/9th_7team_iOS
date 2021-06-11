//
//  YourPageService.swift
//  myRecipick
//
//  Created by hanwe on 2021/05/02.
//  Copyright © 2021 depromeet. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

protocol YourPageServiceProtocol {
    var error: PublishSubject<String> { get set }
    func getYourCustomMenus() -> Observable<[CustomMenuObjModel]>
    func getDetailCustomMenuData(data: CustomMenuObjModel) -> Observable<CustomMenuDetailObjModel>
    func removeCustomMenus(modelObjArr: [CustomMenuObjModel]) -> Observable<Void>
}

class YourPageService: YourPageServiceProtocol {
    
    // MARK: property
    
    var disposeBag: DisposeBag = DisposeBag()
    var error: PublishSubject<String>
    
    // MARK: lifeCycle
    
    init() {
        self.error = .init()
    }
    
    // MARK: function
    
    func getYourCustomMenus() -> Observable<[CustomMenuObjModel]> {
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            self.requestYourCustomMenus()
                .subscribe(onNext: { responseJson in
                    var items: [CustomMenuObjModel] = []
                    for i in 0..<responseJson.count {
                        let item: JSON = responseJson[i]
                        let itemData = item.rawString()?.data(using: .utf8)
                        if let obj: CustomMenuObjModel = CustomMenuObjModel.fromJson(jsonData: itemData, object: CustomMenuObjModel()) {
                            items.append(obj)
                        }
                    }
                    emitter.onNext(items)
                    emitter.onCompleted()
                }, onError: { [weak self] err in
                    self?.error.onNext(err.localizedDescription)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getDetailCustomMenuData(data: CustomMenuObjModel) -> Observable<CustomMenuDetailObjModel> {
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            self.requestDetailYourCustomMenu(menuId: data.id)
                .subscribe(onNext: { [weak self] responseJson in
                        let json: JSON = responseJson
                        let jsonData = json.rawString()?.data(using: .utf8)
                        if let item: CustomMenuDetailObjModel = CustomMenuDetailObjModel.fromJson(jsonData: jsonData, object: CustomMenuDetailObjModel()) {
                            emitter.onNext(item)
                            emitter.onCompleted()
                        } else {
                            self?.error.onNext("데이터 역직렬화 실패")
                            emitter.onCompleted()
                        }
                }, onError: { [weak self] err in
                    self?.error.onNext(err.localizedDescription)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func removeCustomMenus(modelObjArr: [CustomMenuObjModel]) -> Observable<Void> {
        return Observable.create { [weak self] emitter in
            guard let self = self else { return Disposables.create() }
            self.removeYoutCustomMenu(modelObjArr: modelObjArr)
                .subscribe(onNext: { _ in
                    NotificationCenter.default.post(name: Notification.Name(.myRecipickNotificationName(.customMenuRemoved)), object: nil)
                    emitter.onCompleted()
                }, onError: { [weak self] err in
                    self?.error.onNext(err.localizedDescription)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    // MARK: private function
    
    private func requestYourCustomMenus() -> Observable<JSON> {
        var httpRequest = HttpRequest()
        httpRequest.url = APIDefine.MY_CUSTOM_MENUS
        httpRequest.headers = .customMenus(uniqueId: UniqueUUIDManager.shared.uniqueUUID)
        return ServerUtil.shared.rx.requestRxToJson(with: httpRequest)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .retry(3)
    }
    
    private func requestDetailYourCustomMenu(menuId: String) -> Observable<JSON> {
        var httpRequest = HttpRequest()
        httpRequest.url = APIDefine.MY_CUSTOM_MENU_DETAIL + "/\(menuId)"
        httpRequest.headers = .default
        return ServerUtil.shared.rx.requestRxToJson(with: httpRequest)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .retry(3)
    }
    
    private func removeYoutCustomMenu(modelObjArr: [CustomMenuObjModel]) -> Observable<JSON> {
        var httpRequest = HttpRequest()
        httpRequest.url = makeRemoveURL(modelObjArr: modelObjArr)
        httpRequest.method = .delete
        httpRequest.headers = .customMenus(uniqueId: UniqueUUIDManager.shared.uniqueUUID)
        return ServerUtil.shared.rx.requestRxToJson(with: httpRequest)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observe(on: MainScheduler.instance)
            .retry(3)
    }
    
    private func makeRemoveURL(modelObjArr: [CustomMenuObjModel]) -> String {
        var returnValue: String = APIDefine.MY_CUSTOM_MENUS
        for i in 0..<modelObjArr.count {
            if i == 0 {
                returnValue += "?" + "id=" + modelObjArr[i].id
            } else {
                returnValue += "&" + "id=" + modelObjArr[i].id
            }
        }
        return returnValue
    }
    
}

struct CustomMenuObjModel: JsonDataProtocol {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var imageUrl: String?
    var createdDate: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl = "image"
        case createdDate
    }
}
