
import UIKit
import XCTest
import swift_http

class swift_httpTests: XCTestCase {
    
    fileprivate var url = "https://httpbin.org"
    fileprivate let timeout: TimeInterval = 1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGET() {
        let expectation = self.expectation(description: "GET")
        _ = HTTP.get("\(url)/get") { result in
            switch result {
            case .success(_, let response):
                XCTAssertEqual(response.statusCode, 200)
            case .error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPOST() {
        let expectation = self.expectation(description: "POST")
        _ = HTTP.post("\(url)/post") { result in
            switch result {
            case .success(_, let response):
                XCTAssertEqual(response.statusCode, 200)
            case .error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPOSTData() {
        let expectation = self.expectation(description: "POST data")
        let data = ["username": "john"]
        _ = HTTP.post("\(url)/post", data: data as AnyObject) { result in
            switch result {
            case .success(let json, let response):
                if let d = json as? [String: AnyObject] {
                    if let j = d["json"] as? [String: String] {
                        XCTAssertEqual(j["username"]!, "john")
                    }
                }
                XCTAssertEqual(response.statusCode, 200)
            case .error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPUTData() {
        let expectation = self.expectation(description: "PUT data")
        let data = ["username": "john"]
        _ = HTTP.put("\(url)/put", data: data as AnyObject) { result in
            switch result {
            case .success(let json, let response):
                if let d = json as? [String: AnyObject] {
                    if let j = d["json"] as? [String: String] {
                        XCTAssertEqual(j["username"]!, "john")
                    }
                }
                XCTAssertEqual(response.statusCode, 200)
            case .error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
}
