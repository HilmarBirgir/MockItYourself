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
    class ReturnValueSubClass: ReturnValueClass {}
    
    var mockExample: MockExampleClass!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleClass()
    }
    
    func test_not_stubbed_method_returns_default_value() {
        let actualReturn = mockExample.methodWithArgs1Returns("")
        
        XCTAssertEqual(actualReturn, MockExampleClass.defaultReturnValue)
    }
    
    func test_can_stub_method_to_return_value() {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn) { self.mockExample.methodWithArgs1Returns("") }
        let actualReturn = mockExample.methodWithArgs1Returns("")
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_twice_when_no_arguments_and_later_stub_is_used() {
        stub(mockExample, andReturnValue: "1") { self.mockExample.methodWithArgs0Returns() }
        stub(mockExample, andReturnValue: "2") { self.mockExample.methodWithArgs0Returns() }
        let actualReturn = mockExample.methodWithArgs0Returns()
        
        XCTAssertEqual(actualReturn, "2")
    }
    
    func test_can_stub_method_to_return_value_when_subclass() {
        let expectedReturn = ReturnValueSubClass(value: 2)
        stub(mockExample, andReturnValue: expectedReturn) { return self.mockExample.methodWithArgs1ReturnsClass("") }
        let actualReturn = mockExample.methodWithArgs1ReturnsClass("")
        
        XCTAssertEqual(actualReturn.value, expectedReturn.value)
    }
    
    func test_can_stub_method_to_return_value_ignoring_arguments() {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn, checkArguments: false) { self.mockExample.methodWithArgs1Returns(any()) }
        let actualReturn = mockExample.methodWithArgs1Returns("A")
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_cannot_stub_method_to_return_value_after_stubbing_once_to_ignore_arguments() {
        stub(mockExample, andReturnValue: "Return any", checkArguments: false) { self.mockExample.methodWithArgs1Returns(any()) }
        
        var success = false
        do {
            try mockExample.callHandler.stub({ _ = self.mockExample.methodWithArgs1Returns("B") }, andReturnValue: "Return B", checkArguments: true)
        } catch MockVerificationError.MethodHasBeenStubbedForAllArguments {
            success = true
        } catch {
            XCTFail("Threw wrong type of error")
        }
        
        XCTAssert(success)
        
        let actualReturn = mockExample.methodWithArgs1Returns("B")
        
        XCTAssertEqual(actualReturn, "Return any")
    }
    
    func test_can_stub_method_to_return_different_values_based_on_arguments() {
        stub(mockExample, andReturnValue: "Return A") { self.mockExample.methodWithArgs1Returns("A") }
        stub(mockExample, andReturnValue: "Return B") { self.mockExample.methodWithArgs1Returns("B") }
        
        let returnWhenCalledWithA = mockExample.methodWithArgs1Returns("A")
        XCTAssertEqual(returnWhenCalledWithA, "Return A")
        
        let returnWhenCalledWithB = mockExample.methodWithArgs1Returns("B")
        XCTAssertEqual(returnWhenCalledWithB, "Return B")
    }
    
    func test_can_stub_property() {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn) { self.mockExample.property }
        let actualReturn = mockExample.property
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_implicitly_unwrapped_optional() {
        let expectedReturn = "expected return"
        
        stub(mockExample, andReturnValue: expectedReturn) { self.mockExample.propertyImplicitlyUnwrapped }
        let actualReturn = mockExample.propertyImplicitlyUnwrapped
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_optional_property() {
        stub(mockExample, andReturnValue: "expected return") { self.mockExample.propertyOptional }
        let actualReturn = mockExample.propertyOptional
        
        XCTAssertEqual(actualReturn, "expected return")
    }
    
    func test_can_stub_to_return_nil() {
        stub(mockExample, andReturnValue: nil) { self.mockExample.propertyImplicitlyUnwrapped }
        let actualReturn = mockExample.propertyImplicitlyUnwrapped
        
        XCTAssertEqual(actualReturn, nil)
    }
}
