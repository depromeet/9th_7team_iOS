//
//  ServerUtil.swift
//  myRecipick
//
//  Created by Min on 2021/04/12.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import SwiftyJSON

 protocol HttPRequestRx {
    func requestRx<T: Decodable>(with request: HttpRequest) -> Observable<T>
 }

struct ServerUtil {
    static let shared = ServerUtil()
    private init() { }
    let manager = Alamofire.Session.default
    
    @discardableResult func request(with request: HttpRequest, baseUrl: APIDefine.BaseUrl = .v1, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) -> DataRequest? {
        let baseURL = baseUrl.getUrlString()
        let dataRequest: DataRequest = AF.request(baseURL + request.url,
                                                  method: request.method.toAlamofire,
                                                  parameters: request.parameters,
                                                  encoding: request.encoding?.toAlamofire ?? JSONEncoding.default,
                                                  headers: request.headers?.toAlamofire
        ).validate().responseJSON { (responseObject) -> Void in
            switch responseObject.result {
            case .success(let value):
                let resJson = JSON(value)
                success(resJson)
            case .failure(let error):
                let errorValue: Error = error
                failure(errorValue)
            }
        }
        return dataRequest
    }
}

extension ServerUtil: ReactiveCompatible { }

extension Reactive where Base == ServerUtil {
    func requestRx<T>(with request: HttpRequest, baseUrl: APIDefine.BaseUrl = .v1) -> Observable<T> where T: Decodable {
        return base.manager.httpRequest(with: request, baseUrl: baseUrl)
            .decodedObject()
    }
    
    func requestRxToJson(with request: HttpRequest, baseUrl: APIDefine.BaseUrl = .v1) -> Observable<JSON> {
        return base.manager.httpRequest(with: request, baseUrl: baseUrl)
            .swiftyJsonDataObject()
    }
}

extension Observable where Element == (HTTPURLResponse, Any) {
    fileprivate func decodedObject<T: Decodable>() -> Observable<T> {
        return flatMap { (response, json) -> Observable<T> in
            
            switch response.statusCode {
            case 200..<300:
                if let response: T = JSONConverter.decode(from: json) {
                    return .just(response)
                } else {
                    return .error(self.updateWithError(with: json))
                }
            default:
                return .error(self.updateWithError(with: json))
            }
        }
    }
    
    fileprivate func swiftyJsonDataObject() -> Observable<JSON> {
        return flatMap { (response, json) -> Observable<JSON> in
            switch response.statusCode {
            case 200..<300:
                let data = JSON(json)["data"]
                return .just(data)
            default:
                return .error(self.updateWithError(with: json))
            }
        }
    }
    
    fileprivate func updateWithError(with json: Any) -> Error {
        if let error: APIError = JSONConverter.decode(from: json) {
            return error
        } else {
            return ErrorMessage(message: "unknown Error", name: 500)
        }
    }
}



extension Session {
    fileprivate func httpRequest(with httpRequest: HttpRequest, baseUrl: APIDefine.BaseUrl = .test) -> Observable<(HTTPURLResponse, Any)> {
        let baseURL = baseUrl.rawValue
        return Session.default.rx.responseJSON(httpRequest.alamofireMethod,
                                               baseURL + httpRequest.url,
                                               parameters: httpRequest.parameters,
                                               encoding: httpRequest.alamofireEncoding,
                                               headers: httpRequest.alamofireHeaders)
    }
}
