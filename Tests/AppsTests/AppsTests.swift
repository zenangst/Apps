import Apps
import Combine
import Foundation
import XCTest

class AppsTests: XCTestCase {
  var subscriptions = [AnyCancellable]()

  func testLoadingApplications() {
    let applications = ApplicationController.loadApplications()
    XCTAssertNotNil( applications.first(where: { $0.bundleIdentifier == "com.apple.finder" }) )
  }

  func testAsyncLoadingApplications() {
    let expectation = self.expectation(description: "Wait for application parsing to complete")
    ApplicationController.asyncLoadApplications()
      .sink { applications in
        XCTAssertNotNil( applications.first(where: { $0.bundleIdentifier == "com.apple.finder" }) )
        expectation.fulfill()
      }.store(in: &subscriptions)
    wait(for: [expectation], timeout: 10)
  }
}
