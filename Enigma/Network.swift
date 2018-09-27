//
//  File.swift
//  Whee
//
//  Created by 汤迪希 on 27/02/2018.
//  Copyright © 2018 Meitu. All rights reserved.
//

import Foundation
import ObjectMapper

/// 负责管理项目中所有 HTTP 请求
public class VVNetwork {
  
  /// VVNetwork 单例
  static let client = VVNetwork()
  
  /// AFNetworking 底层的 NSURLSession
  fileprivate lazy var sessionManager = makeSessionManager()
}

extension VVNetwork {
  func makeSessionManager() -> AFURLSessionManager {

    let securityPolicy = AFSecurityPolicy(pinningMode: .none)
    securityPolicy.allowInvalidCertificates = true
    securityPolicy.validatesDomainName = false

    let sessionManager = AFURLSessionManager()
    sessionManager.securityPolicy = securityPolicy
    
    return sessionManager
  }
}

extension VVNetwork: Enigma {
  
  public var host: String { return "https://preapi.whee.meitu-int.com/v1/" }
  public var header: [String : Any] { return [:] }
  
  public func send<T>(_ r: T, completion: @escaping (Result<T.Response>) -> Void) where T: Requestable {
    guard let url = URL(string: host.appending(r.path)) else { return }
    
    let request = AFHTTPRequestSerializer()
      .request(withMethod: r.method.rawValue,
               urlString: url.absoluteString,
               parameters: r.signedParameters,
               error: nil)
    
    let task = sessionManager
      .dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) {
        _, rawJson, error in
        
        // 确保请求没有错误再解析
        guard error == nil else {
          // 包装后抛给上层
          if let error = error as NSError? {
            completion(Result<T.Response>.failure(VVError(error: error)))
          }
          return
        }
        
        if let rawJson = rawJson as? [String: Any] {
          
          // 解析操作放在异步队列
          DispatchQueue(label: "com.whee.network.parser").async {
            do {
              let json = try ResponseWrapper.unwrap(json: rawJson)
              let result = T.Response.parse(json: json)
              DispatchQueue.main.async { completion(result) }
            } catch {
              let result = Result<T.Response>.failure(error)
              DispatchQueue.main.async { completion(result) }
            }
          }
        }
    }
    
    task.resume()
  }
}
