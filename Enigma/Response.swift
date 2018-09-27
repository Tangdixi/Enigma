//
//  NetworkResponse.swift
//  Whee
//
//  Created by 汤迪希 on 01/03/2018.
//  Copyright © 2018 Hobi. All rights reserved.
//

import ObjectMapper

/// 通用 response model 类
struct ResponseWrapper {
  
  var result: Int!
  var code: Int!
  var errorInfo: String!
  var message: String!
  var data: [String: Any]!
}

/// 最外层 response JSON 的数据结构封装
///
extension ResponseWrapper: Mappable {
  
  init?(map: Map) { }
  mutating func mapping(map: Map) {
    result <- map["ret"]
    code <- map["error_code"]
    errorInfo <- map["error"]
    message <- map["msg"]
    data <- map["data"]
  }
}

extension ResponseWrapper: Parsable {
  
  /// 负责解析最外层 response，以及 error code 处理
  static func unwrap(json: [String: Any]) throws -> [String: Any] {
    let result = self.parse(json: json)
    
    switch result {
    case .success(let response):
      guard response.result == 0 else {
        throw VVError(rawCode: response.code)
      }
      return response.data
    case .failure(let error):
      throw error
    }
  }
}

extension Parsable where Self: Mappable {
  static func parse(json: [String: Any]) -> Result<Self> {
    guard let result = Mapper<Self>().map(JSON: json) else {
      return Result<Self>.failure(VVError(code: .parseFailed))
    }
    return Result<Self>(value: result)
  }
}
