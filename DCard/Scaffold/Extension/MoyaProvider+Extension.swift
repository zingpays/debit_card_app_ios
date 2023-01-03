//
//  MoyaProvider+Extension.swift
//  Flashwire
//
//  Created by Fei Zhang on 2022/11/17.
//  Copyright © 2022 Zing Tech. All rights reserved.
//

import Moya
import ObjectMapper
import Moya_ObjectMapper

extension MoyaProvider {
    @discardableResult
    func requestStatus(_ target: Target, completion: @escaping ResponseNormalCompletion) -> Cancellable {
        return request(target) { result in
            var success = false
            var message = NETWORKERRORMESSAGE
            switch result {
            case .success(let response):
                do {
                    let resData = try response.mapObject(ResponseModel.self)
                    message = resData.message ?? message
                    success = resData.code == 0
                } catch let err {
                    DLog.error(err.localizedDescription)
                }
            case .failure(let error):
                message = error.localizedDescription
            }
            completion(success, message)
        }
    }

    @discardableResult
    func requestObject<T: Mappable>(_ target: Target, type: T.Type, completion: @escaping ((Bool, String, T?) -> Void)) -> Cancellable {
        return request(target) { result in
            var success = false
            var message = NETWORKERRORMESSAGE
            var data: T?
            switch result {
            case .success(let response):
                do {
                    guard let resDic = try response.mapJSON() as? NSDictionary else { return }
                    success = resDic["code"] as? Int == 0
                    message = resDic["message"] as? String ?? message
                    if let dataDic = resDic["data"] as? [String: Any] {
                        data = Mapper<T>().map(JSON: dataDic)
                    }
                } catch let err {
                    DLog.error(err.localizedDescription)
                }
            case .failure(let err):
                message = err.localizedDescription
            }
            completion(success, message, data)
        }
    }

    @discardableResult
    func requestObjects<T: Mappable>(_ target: Target, type: T.Type, completion: @escaping ((Bool, String, [T]?) -> Void)) -> Cancellable {
        return request(target) { result in
            var success = false
            var message = NETWORKERRORMESSAGE
            var data: [T]?
            switch result {
            case .success(let response):
                do {
                    guard let resDic = try response.mapJSON() as? NSDictionary else { return }
                    success = resDic["code"] as? Int == 0
                    message = resDic["message"] as? String ?? message
                    if let dataDic = resDic["data"] as? [[String: Any]] {
                        data = Mapper<T>().mapArray(JSONArray: dataDic)
                    }
                } catch let err {
                    DLog.error(err.localizedDescription)
                }
            case .failure(let err):
                message = err.localizedDescription
            }
            completion(success, message, data)
        }
    }
    
    @discardableResult
    func requestArray(_ target: Target, completion: @escaping ((Bool, String, [String : Any]?) -> Void)) -> Cancellable {
        return request(target) { result in
            var success = false
            var message = NETWORKERRORMESSAGE
            var data: [String : Any]?
            switch result {
            case .success(let response):
                do {
                    guard let resDic = try response.mapJSON() as? NSDictionary else { return }
                    success = resDic["code"] as? Int == 0
                    message = resDic["message"] as? String ?? message
                    data = resDic["data"] as? [String : Any]
                } catch let err {
                    DLog.error(err.localizedDescription)
                }
            case .failure(let err):
                message = err.localizedDescription
            }
            completion(success, message, data)
        }
    }
}

// MARK: - 模型

/// 网络返回体模型
struct ResponseModel: Mappable {
    /// 状态码，0：成功，其他：失败
    var code: Int = 404
    /// 信息
    var message: String?
    /// 错误模型
    var error: ResponseError?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        code    <- map["code"]
        error   <- map["error"]
        message <- map["message"]
    }
}

struct ResponseError: Mappable {
    /// 错误信息
    var message = [String]()

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        message <- map["message"]
    }
}
