//
//  MockExampleTest.swift
//  QuizUp
//
//  Created by Alex Verein on 09/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

import XCTest

protocol ExampleProtocol {
    
    var property: String { get }
    
    func buildAdView(withTarget target: AnyObject, action: Selector) -> String
    
    func didDisappear()
    
    func didAppear()
}

class MockExampleProtocolImplementation: ExampleProtocol, MockItYourself {
    
    static let defaultReturnValue = "default return value"
    
    var property: String {
        return callHandler.registerCall(returnValue: MockExampleProtocolImplementation.defaultReturnValue) as! String
    }
    
    let callHandler = MockCallHandler()
    
    func buildAdView(withTarget target: AnyObject, action: Selector) -> String {
        return callHandler.registerCall(returnValue: MockExampleProtocolImplementation.defaultReturnValue, args: [target, action] as [Any?]) as! String
    }
    
    func didDisappear() {
        //Not mocked method
    }
    
    func didAppear() {
        callHandler.registerCall()
    }
    
    func onUserDidSeeAd(conf: String?, adInfo: Int?, impressionIndex: UInt) {
        callHandler.registerCall(returnValue: nil, args: [conf, adInfo, impressionIndex])
    }
}

class MockExampleTests: XCTestCase {
    
    var mockExample: MockExampleProtocolImplementation!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleProtocolImplementation()
    }
    
    func test_can_verify_one_call_of_method_with_no_arguments() {
        mockExample.didAppear()
        
        verify(mockExample, expectedCallCount: 1) { self.mockExample.didAppear() }
    }

    func test_can_verify_many_calls_of_method_with_no_arguments() {
        mockExample.didAppear()
        mockExample.didAppear()
        
        verify(mockExample, expectedCallCount: 2) { self.mockExample.didAppear() }
    }

    func test_verify_asserts_when_not_enough_calls_of_method_with_no_arguments() {
        var success = false
        
        mockExample.didAppear()
        
        do {
            try mockExample.verify(2) { self.mockExample.didAppear() }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }

    func test_can_verify_method_with_no_arguments() {
        mockExample.didAppear()
        
        verify(mockExample) { self.mockExample.didAppear() }
    }
    
    func test_can_verify_method_call_ignoring_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
        mockExample.buildAdView(withTarget: arg1, action: arg2)
        
        verify(mockExample) { self.mockExample.buildAdView(withTarget: Anything(), action: nil) }
    }
    
    func test_verify_asserts_if_method_is_not_called() {
        var success = false
        
        do {
            try mockExample.verify() { self.mockExample.buildAdView(withTarget: Anything(), action: nil) }
        }
        catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_can_verify_method_call_not_ignoring_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
        mockExample.buildAdView(withTarget: arg1, action: arg2)
        
        verifyArguments(mockExample) { self.mockExample.buildAdView(withTarget: arg1, action: arg2) }
    }
    
    func test_verify_arguments_asserts_if_method_is_not_called() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
        var success = false
        
        do {
            try mockExample.verifyArguments() { self.mockExample.buildAdView(withTarget: arg1, action: arg2) }
        }
        catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_verify_arguments_asserts_if_arguments_does_not_match() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
        mockExample.buildAdView(withTarget: "", action: arg2)
        
        var success = false
        
        do {
            try mockExample.verifyArguments() { self.mockExample.buildAdView(withTarget: arg1, action: arg2) }
        }
        catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }

    func test_can_reject_method_with_any_arguments() {
        reject(mockExample) { self.mockExample.onUserDidSeeAd(nil, adInfo: nil, impressionIndex: 0) }
    }
    
    func test_reject_asserts_if_method_is_called() {
        mockExample.onUserDidSeeAd("", adInfo: 3, impressionIndex: 2)
        
        var success = false
        
        do {
            try mockExample.reject() { self.mockExample.onUserDidSeeAd(nil, adInfo: nil, impressionIndex: 0) }
        } catch {
            success = true
        }
        
         XCTAssertTrue(success)
    }
    
    func test_verifying_not_mocked_method_asserts() {
        var success = false
        
        do {
            try mockExample.verify() { self.mockExample.didDisappear() }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    // MARK: Stubbing
    
    func test_not_stubbed_method_returns_default_value() {
        let actualReturn = mockExample.buildAdView(withTarget: "", action: nil)
        
        XCTAssertEqual(actualReturn, MockExampleProtocolImplementation.defaultReturnValue)
    }
    
    func test_can_stub_method_to_return_value() {
        let expectedReturn = "expected return"
        
        mockExample.stubMethod({ self.mockExample.buildAdView(withTarget: Anything(), action: nil) }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.buildAdView(withTarget: "", action: nil)
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }
    
    func test_can_stub_property() {
        let expectedReturn = "expected return"
        
        mockExample.stubMethod({ self.mockExample.property }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.property
        
        XCTAssertEqual(actualReturn, expectedReturn)
    }

}

