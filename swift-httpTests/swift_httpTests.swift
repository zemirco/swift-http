
import UIKit
import XCTest
import swift_http

class swift_httpTests: XCTestCase {
    
    private var url = "http://httpbin.org"
    private let timeout: NSTimeInterval = 1
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGET() {
        let expectation = expectationWithDescription("GET")
        HTTP.get("\(url)/get") { result in
            switch result {
            case .Success(let json, let response):
                XCTAssertEqual(response.statusCode, 200)
            case .Error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testPOST() {
        let expectation = expectationWithDescription("POST")
        HTTP.post("\(url)/post") { result in
            switch result {
            case .Success(let json, let response):
                XCTAssertEqual(response.statusCode, 200)
            case .Error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testPOSTData() {
        let expectation = expectationWithDescription("POST data")
        var data = ["username": "john"]
        HTTP.post("\(url)/post", data: data) { result in
            switch result {
            case .Success(let json, let response):
                if let d = json as? [String: AnyObject] {
                    if let j = d["json"] as? [String: String] {
                        XCTAssertEqual(j["username"]!, "john")
                    }
                }
                XCTAssertEqual(response.statusCode, 200)
            case .Error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testPUTData() {
        let expectation = expectationWithDescription("PUT data")
        var data = ["username": "john"]
        HTTP.put("\(url)/put", data: data) { result in
            switch result {
            case .Success(let json, let response):
                if let d = json as? [String: AnyObject] {
                    if let j = d["json"] as? [String: String] {
                        XCTAssertEqual(j["username"]!, "john")
                    }
                }
                XCTAssertEqual(response.statusCode, 200)
            case .Error(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
}
