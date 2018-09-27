//
//  VersionRequest.swift
//  Whee
//
//  Created by 汤迪希 on 01/03/2018.
//  Copyright © 2018 Hobi. All rights reserved.
//

import Foundation
import ObjectMapper

struct VersionRequest: Requestable {
  typealias Response = Version
  
  var path: String = "common/version.json"
  var method: HTTPMethod = .get
  var parameters: [String : Any]? = [:]
}

extension Version: Parsable {
  static func parse(json: [String : Any]) -> Result<Version> {
    guard let version = Version(JSON: json) else {
      return Result<Version>
        .failure(VVError(code: .parseFailed))
    }
    return Result<Version>(value: version)
  }
}

extension Version: Mappable {
  
  init?(map: Map) { }
  mutating func mapping(map: Map) {
    downloadURL <- map["download_url"]
  }
}
