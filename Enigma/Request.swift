//
//  File.swift
//  Whee
//
//  Created by 汤迪希 on 01/03/2018.
//  Copyright © 2018 Hobi. All rights reserved.
//

import Foundation

protocol Signable { }

extension Requestable {
  
  var appID: String { return "xxx" }
  
  var signedParameters: [String: Any] {
    guard var parameters = parameters else { return [:] }
    
    let values = parameters.map{ $0.value }
    let signatures = MTSigManager.generateSig(path, parameters: values, appId: appID)
    
    signatures?.forEach { parameters[$0.key as! String] = $0.value }
    
    return parameters
  }
}
