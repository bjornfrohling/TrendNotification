import Vapor
import VaporAPNS

extension Droplet {
  func setupRoutes() throws {
    
    // Function for storing mobile device token
    post("registerPush") { request in
      let mc = try MobileClient(request: request)
      try mc.save()
      
      return try mc.makeJSON()
    }
    
    // Function for sending push notifications to all stored devices
    get("push") { _ in
      let apps = try MobileClient.all()
      for mc in apps {
        let notification = try Notification(mobileClient: mc, message: "A push message")
        try notification.send()
      }
      
      return "push sent"
    }
    
    // response to requests to /info domain
    // with a description of the request
    get("info") { req in
      return req.description
    }
    
    get("description") { req in return req.description }
    
    try resource("posts", PostController.self)
  }
}

