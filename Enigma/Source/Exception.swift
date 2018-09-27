//
//  Error.swift
//  Whee
//
//  Created by 汤迪希 on 27/02/2018.
//  Copyright © 2018 Meitu. All rights reserved.
//

import Foundation

public enum Exception: Swift.Error {
  case error(NSError)
  case info(code: Int32, message: String)
}
