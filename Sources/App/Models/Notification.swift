//
//  Notification.swift
//  App
//
//  Created by Björn Fröhling on 10/11/2017.
//

import Foundation
import HTTP
import VaporAPNS

final class Notification {
  
  let message: String
  let mobileClient: MobileClient
  
  init(mobileClient: MobileClient?, message: String?) throws {
    guard let message = message,
      let mobileClient = mobileClient
      else { throw Abort.badRequest }
    
    self.message = message
    self.mobileClient = mobileClient
  }
  
  func send() throws {
    var options = try Options(topic: mobileClient.bundleId,
                              teamId: mobileClient.teamId,
                              keyId: mobileClient.keyId,
                              keyPath: mobileClient.keyPath)
    options.disableCurlCheck = true
    let vaporApns = try VaporAPNS(options: options)
    
    let payload = Payload(message: message)
    payload.sound = "default"
    
    let pushMessage = ApplePushMessage(priority: .immediately, payload: payload)
    
    vaporApns.send(pushMessage, to: [mobileClient.deviceToken]) { push in
      print(push)
    }
  }
}

