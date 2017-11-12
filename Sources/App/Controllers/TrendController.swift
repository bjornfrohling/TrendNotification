//
//  TrendController.swift
//  App
//
//  Created by Björn Fröhling on 12/11/2017.
//

import Foundation
import Vapor

class TrendController {

  /*
   * Generates and sends a push notification for a change in the specified topic
   */
  func checkTrend(request: Request) -> ResponseRepresentable {
    guard let topic = request.data["topic"]?.string,
      let inputString = request.data["inputString"]?.string else {
        return "Parameter error"
    }
    let topicCount = countTopic(topic: topic, inputString: inputString)
    // Compare topic with previous topic
    return compareTrend(topic: topic, topicCount: topicCount)
  }

  /*
   * Count frequancy of topic in the porvided String
   */
  func countTopic(topic: String, inputString: String) -> Int {
    let nolettersSet = CharacterSet.letters.inverted
    // Get array containing only words
    let words = inputString.components(separatedBy: nolettersSet)
    let countedWords = NSCountedSet(array: words)
    return countedWords.count(for: topic)
  }

  /*
   * Composes and sends a push notification
   */
  func sendPushMessage(trendTopic: TrendTopic) {
    let trendMsg = "Topic '\(trendTopic.topic)' was found \(trendTopic.topicCount) times.\n"
    let notificationController = NotificationController()
    _ = notificationController.sendPush(message: trendMsg)
  }

  /*
   * Compares provided topic data with stored data
   * and generates a notification in case of change
   */
  func compareTrend(topic: String, topicCount: Int) -> String {
    print("compareTrend \(topic) c \(topicCount)")
    do {
      let topicArray = try TrendTopic.all().filter { $0.topic == topic }
      if let storedTopic = topicArray.first {
        print(">> topic already exists")
        // Check previous stored values
        if (storedTopic.topicCount != topicCount) {
          // Topic count has changed
          storedTopic.topicCount = topicCount
          try storedTopic.save()
          // Topic count has changed
          sendPushMessage(trendTopic: storedTopic)
          return "Frequancy of topic \(topic) changed"

        } else {
          return "Frequancy topic \(topic) did not change"
        }
      } else {
        // Store new topic
        print("Topic did not exist")
        let newTopic = TrendTopic(topic: topic, topicCount: topicCount)
        try newTopic.save()
        if topicCount > 0 {
          sendPushMessage(trendTopic: newTopic)
        }
        return "New topic stored"
      }

    } catch {
      return "Error in compareTrend()"
    }
  }

}
