//
//  NotificationController.swift
//  App
//
//  Created by Björn Fröhling on 12/11/2017.
//

import Foundation
import Vapor


class NotificationController {

  /*
   * Register device for push notifications
   */
  func registerDevice(request: Request) -> ResponseRepresentable {
    do {
      let mobileClient = try MobileClient(request: request)
      try mobileClient.save()

      return try mobileClient.makeJSON()
    } catch {
      return "Register Device error"
    }
  }

  /*
   * Send push notifications to all registered devices
   */
  func sendPush(message: String) -> String {
    do {
      let apps = try MobileClient.all()
      for mobileClient in apps {
        let notification = try Notification(mobileClient: mobileClient, message: message)
        try notification.send()
      }
    } catch {
      return "Error sending Push msg"
    }
    return "Push msg sent"
  }
}
