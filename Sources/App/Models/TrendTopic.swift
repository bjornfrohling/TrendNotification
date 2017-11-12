//
//  TrendTopic.swift
//  App
//
//  Created by Björn Fröhling on 12/11/2017.
//

import Foundation
import Vapor
import FluentProvider

final class TrendTopic: Model {
  
  let storage = Storage()
  let topic: String
  var topicCount: Int
  
  init(row: Row) throws {
    topic = try row.get("topic")
    topicCount = try row.get("topicCount")
  }
  
  init(topic: String, topicCount: Int) {
    self.topic = topic
    self.topicCount = topicCount
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("topic", topic)
    try row.set("topicCount", topicCount)
    return row
  }
}

extension TrendTopic: JSONRepresentable {
  func makeJSON() throws -> JSON {
    let row = try makeRow()
    return try JSON(node: row.object)
  }
}

extension TrendTopic: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { trendTopic in
      trendTopic.id()
      trendTopic.string("topic")
      trendTopic.int("topicCount")
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}
