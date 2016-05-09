//
//  StubTests.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//
//

import XCTest
@testable import MockItYourself

class StubTests: XCTestCase {
    
    var mockExample: MockExampleClass!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleClass()
    }
    
    func test_not_stubbed_method_returns_default_value() {
        let actualReturn = mockExample.methodWithArgs1("")
        
        XCTAssertEqual(actualReturn, MockExampleClass.defaultReturnValue)
    }
    
    func test_can_stub_method_to_return_value() throws {
        let expectedReturn = "expected return"
        
        try mockExample.stubMethod({ self.mockExample.methodWithArgs1("") }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.methodWithArgs1("")
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_property() throws {
        let expectedReturn = "expected return"
        
        try mockExample.stubMethod({ self.mockExample.property }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.property
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
}
