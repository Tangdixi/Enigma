//
//  Result.swift
//  Whee
//
//  Created by 汤迪希 on 26/02/2018.
//  Copyright © 2018 Meitu. All rights reserved.
//

import Foundation

public protocol Resultable {
  associatedtype Value
  
  init(value: Value)
  init(error: Swift.Error)
  
  var result: Result<Value> { get }
}

public enum Result<Value>: Resultable {
  case success(Value)
  case failure(Swift.Error)
  
  public init(value: Value) {
    self = .success(value)
  }
  
  public init(error: Swift.Error) {
    self = .failure(error)
  }
  
  public var result: Result<Value> {
    return self
  }
}

public extension Result {
  
  public var value: Value? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }
  
  public var error: Swift.Error? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
  
  public func flatMap<U>(_ transform: (Value) -> Result<U>) -> Result<U> {
    switch self {
    case .success(let value):
      return transform(value)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  public func map<U>(_ transform: (Value) -> U) -> Result<U> {
    return flatMap { .success(transform($0)) }
  }
  
}
