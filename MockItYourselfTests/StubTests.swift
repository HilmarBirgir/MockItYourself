//
//  StubTests.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//
//

import XCTest
import MockItYourself

class StubTests: XCTestCase {
    
    var mockExample: MockExampleClass!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleClass()
    }
    
    func test_not_stubbed_method_returns_default_value() {
        let actualReturn = mockExample.methodWithArgs1Returns("")
        
        XCTAssertEqual(actualReturn, MockExampleClass.defaultReturnValue)
    }
    
    func test_can_stub_method_to_return_value() throws {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn) { self.mockExample.methodWithArgs1Returns("") }
        let actualReturn = mockExample.methodWithArgs1Returns("")
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_property() throws {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn) { self.mockExample.property }
        let actualReturn = mockExample.property
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
}
