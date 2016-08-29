//
//  RejectTests.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//

import XCTest
@testable import MockItYourself

class RejectTests: XCTestCase {
    
    var mockExample: MockExampleClass!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleClass()
    }
    
    func test_rejecting_not_mocked_method_asserts() {
        var success = false
        
        do {
            try mockExample.callHandler.reject() { self.mockExample.methodThatIsNotMocked() }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }

    func test_can_reject_method_with_any_arguments() {
        reject(mockExample) { self.mockExample.methodWithArgs1("asdf") }
    }
    
    func test_reject_asserts_if_method_is_called() {
        mockExample.methodWithArgs1("")
        
        var success = false
        
        do {
            try mockExample.callHandler.reject() { self.mockExample.methodWithArgs1("") }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
}
