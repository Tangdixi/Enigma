//
//  NetworkEngineTwo.swift
//  Network_research
//
//  Created by 汤迪希 on 24/02/2018.
//  Copyright © 2018 Meitu. All rights reserved.
//

import Foundation

/// HTTP 请求方法
public enum HTTPMethod: String {
  case get, post, put, update, delete
}

/// 网络层抽象协议
public protocol Enigma {
  
  /// Host 名称
  var host: String { get }
  
  /// Header 信息
  var header: [String: Any] { get }
  
  /// 抽象 request 接口
  ///
  /// - Parameter r: 一个遵循 Requestable 协议的类型
  /// - Parameter completion: 请求返回后的闭包，内容是一个包含对应 model 的 `Result` 对象
  ///
  func send<T: Requestable>(_ r: T, completion: @escaping (Result<T.Response>) -> Void)
}

/// 请求抽象协议
public protocol Requestable {
  
  /// 指定关联类型必须遵循 `Parsable` 协议
  associatedtype Response: Parsable
  
  /// 该请求的子路径
  var path: String { get }
  
  /// 该请求对应的 HTTP 方法
  var method: HTTPMethod { get }
  
  /// 该请求对应的参数字典
  var parameters: [String: Any]? { set get }
  
  /// 默认 initializer
  init()
  
  /// 包含参数时的 initializer
  init(parameters: [String: Any]?)
}

/// 可解析 JSON 协议
public protocol Parsable {
  
  /// 解析 JSON 字典并返回一个 `Result` 对象
  ///
  /// - Parameter json: 一个 JSON 字典
  /// - Returns: 返回一个包含 `Result<Self>` 对象
  ///
  static func parse(json: [String: Any]) -> Result<Self>
}

extension Requestable {
  
  /// 为遵循 `Requestable` 的对象提供一个默认的实现，避免业务处每次都要实现此方法
  ///
  /// - Parameter parameters: 对应的参数字典
  ///
  init(parameters: [String: Any]?) {
    self.init()
    self.parameters = parameters
  }
}
