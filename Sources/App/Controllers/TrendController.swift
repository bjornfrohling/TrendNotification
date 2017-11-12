//
//  TrendController.swift
//  App
//
//  Created by Björn Fröhling on 12/11/2017.
//

import Foundation
import Vapor

class TrendController {

  // test data
  let testString = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Tesla. Eniram. Finland. Tesla. Eniram. Eniram."
  let testTopics = ["Tesla", "Eniram", "Finland", "iPhone"]

  /*
   * Generates and sends a push notification for specified trend topics
   */
  func getTrends(request: Request) -> ResponseRepresentable {
    let countedWords = countWords(inputString: testString)
    let tupleArray = extractAndSortTrends(countedWords: countedWords, topicsToCheck: testTopics)
    let pushMsg = composeTrendMessage(trends: tupleArray)
    let notificationController = NotificationController()

    return notificationController.sendPush(message: pushMsg)
  }

  /*
   * Count all existing words in the porvided String
   */
  func countWords(inputString: String) -> NSCountedSet {
    let nolettersSet = CharacterSet.letters.inverted
    // Get array containing only words
    let words = inputString.components(separatedBy: nolettersSet)

    return NSCountedSet(array: words)
  }

  /*
   * Extracts the provided topics from the countedWords and returns a sorrted Array containing tuples
   */
  func extractAndSortTrends(countedWords: NSCountedSet, topicsToCheck: [String]) -> [(key: String, value: Int)] {
    var trendsDict = [String: Int]()
    for topic in topicsToCheck {
      trendsDict[topic] = countedWords.count(for: topic)
    }
    // Sort topics by their count
    let trendTupleArray = trendsDict.sorted { $0.value > $1.value }

    return trendTupleArray
  }

  /*
   * Composes a String based on the passed tuples
   */
  func composeTrendMessage(trends: [(key: String, value: Int)]) -> String {
    var trendMsg = ""
    for topic in trends {
      trendMsg += "Topic '\(topic.key)' was found \(topic.value) times.\n"
    }

    return trendMsg
  }
}
