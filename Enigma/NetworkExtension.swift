//
//  NetworkExtension.swift
//  Whee
//
//  Created by 汤迪希 on 01/03/2018.
//  Copyright © 2018 Hobi. All rights reserved.
//

extension Bool: Parsable {
  
  /// Bool 类型遵循 `Parsable` 协议
  ///
  /// - Parameter json: 请求返回的 json 对象
  /// - Returns: 返回一个 `Result<Bool>` 对象
  /// - Note: 由于 `Parsable` 协议需要指定对应的解析 model 类型，针对一些无对应 model 的请求，我们统一将它们对应到 `Bool`，后续包装成 `Result<Bool>` 传给上层
  ///
  public static func parse(json: [String : Any]) -> Result<Bool> {
    return Result<Bool>.success(true)
  }
}
