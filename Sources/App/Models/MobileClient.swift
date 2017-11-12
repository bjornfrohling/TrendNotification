//
//  MobileClient.swift
//  App
//
//  Created by Björn Fröhling on 10/11/2017.
//

import Foundation
import Vapor
import FluentProvider

final class MobileClient: Model {
  
  var storage = Storage()
  let deviceToken: String
  let bundleId = "com.test.app.notification"
  let teamId = "some Apple team Id"
  let keyId = "some Apple APNS-key-id"
  let keyPath = "path APNS-key"

  
  init(request: Request) throws {
    guard let deviceToken = request.data["deviceToken"]?.string
      else { throw Abort.badRequest }
    
    self.deviceToken = deviceToken
  }
  
  required init(row: Row) throws {
    self.deviceToken = try row.get("deviceToken")
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("deviceToken", deviceToken)
    return row
  }
}

extension MobileClient: JSONRepresentable {
  func makeJSON() throws -> JSON {
    let row = try makeRow()
    return try JSON(node: row.object)
  }
}

extension MobileClient: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self, closure: { (mc) in
      mc.id()
      mc.string("deviceToken")
    })
  }

  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

