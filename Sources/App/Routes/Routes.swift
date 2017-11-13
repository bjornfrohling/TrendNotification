import Vapor
import VaporAPNS

extension Droplet {
  func setupRoutes() throws {

    let trendController = TrendController()
    let notificationController = NotificationController()

    // Route for checking trends
    post("trends", handler: trendController.checkTrend)

    // Route for storing mobile device token
    post("registerDevice", handler: notificationController.registerDevice)

    // response to requests to /info domain
    // with a description of the request
    get("info") { req in
      return req.description
    }

    get("description") { req in return req.description }

  }
}

