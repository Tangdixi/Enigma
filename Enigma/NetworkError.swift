//
//  NetworkError.swift
//  Whee
//
//  Created by 汤迪希 on 02/03/2018.
//  Copyright © 2018 Hobi. All rights reserved.
//

import Foundation

/// 网络层错误码
struct VVError: Error {
  
  /// 错误码变量，方便于业务层有时需要根据不同 code 做对于操作
  var code: Code?
  
  /// 这里保留一个 NSError，可能后续方便 debug
  private var error: NSError?
  
  init(code: Code) {
    self.code = code
  }
  
  init(error: NSError) {
    self.error = error
    self.code = Code(rawValue: error.code)
  }
  
  init(rawCode: Int) {
    self.code = Code(rawValue: rawCode)
  }
  
  /// 网络层错误 error code
  enum Code: Int {
        
    case illegalRequest = 1000000
    case unsupportedSuffix = 1000001
    case illegalSignature = 1000002
    case missingParameters = 1000003
    case invalidParameters = 1000004
    case lowVersion = 1000005
    
    case missingToken = 2000000
    case expiredToken = 2000001
    case foreverExpiredToken = 2000002
    case invlidToken = 2000003
    case unregistered = 2000004
    
    case parseFailed = 8000000
  }

  var description: String {
    // 到时所有上层 UI 需要显示的错误通知都在此定义
    guard let code = self.code else { return "位置错误" }
    
    switch code {
    case .parseFailed:
      return NSLocalizedString("解析错误", comment: "")
    // TODO: - 临时代码，后续会 cover 所有 case，对应不上的 enum 都会在前面的 guard 语句那里被过滤掉
    default:
      return NSLocalizedString("位置错误", comment: "")
    }
  }
  
}
