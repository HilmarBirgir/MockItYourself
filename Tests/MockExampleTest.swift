//
//  MockExampleTest.swift
//  QuizUp
//
//  Created by Alex Verein on 09/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

@testable import QuizUp

protocol ExampleProtocol1 {
    
    var property: String { get }
    
    func buildAdView(withTarget target: AnyObject, action: Selector) -> String
    
    func didDisappear()
    
    func didAppear()
}

class MockExampleProtocolImplementation: ExampleProtocol1, Mock {
    
    var property: String {
        return callHandler.registerCall("default return value") as! String
    }
    
    let callHandler = MockCallHandler()
    
    func buildAdView(withTarget target: AnyObject, action: Selector) -> String {
        return callHandler.registerCall("default return value", args: [target, action] as [Any?]) as! String
    }
    
    func didDisappear() {
        callHandler.registerCall()
    }
    
    func didAppear() {
        callHandler.registerCall()
    }
    
    func onUserDidSeeAd(conf: String?, adInfo: Int?, impressionIndex: UInt) {
        callHandler.registerCall(nil, args: [conf, adInfo, impressionIndex])
    }
}

func verify(mock: Mock, message: String = "", file: String = __FILE__, line: UInt = __LINE__, verify: () -> ())
{
    do {
        try mock.verify(verify)
    } catch {
        XCTFail(message, file:  file, line: line)
    }
}

class MockExampleTests: XCTestCase {
    
    var mockExample: MockExampleProtocolImplementation!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleProtocolImplementation()
    }
    
    /*
    func test_can_verify_method_with_no_arguments() {
        mockExample.didAppear()
        
        mockExample.verify() { self.mockExample.didAppear() }
    }
    */
    func test_can_verify_method_call_ignoring_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
  //      mockExample.buildAdView(withTarget: arg1, action: arg2)
        
         verify(mockExample) { self.mockExample.buildAdView(withTarget: Anything(), action: nil) }
    }
    
    func test_verify_asserts_if_method_is_not_called() {
        var flag = false
        
        do {
            try mockExample.verify() { self.mockExample.buildAdView(withTarget: Anything(), action: nil) }
        }
        catch {
            flag = true
        }
        
        XCTAssertTrue(flag)
    }
     /*
    func test_can_verify_method_call_not_ignoring_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = "didAppear"
        
        mockExample.buildAdView(withTarget: arg1, action: arg2)
        
        mockExample.verifyArguments() { self.mockExample.buildAdView(withTarget: arg1, action: arg2) }
    }

    func test_can_reject_method_with_any_arguments() {
        mockExample.reject() { self.mockExample.onUserDidSeeAd(nil, adInfo: nil, impressionIndex: 0) }
    }
    
    func test_can_stub_method_to_return_value() {
        let expectedReturn = "expected return"
        
        mockExample.stubMethod({ self.mockExample.buildAdView(withTarget: Anything(), action: nil) }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.buildAdView(withTarget: "", action: nil)
        
        XCTAssertEqual(expectedReturn, actualReturn)
    }
    
    func test_can_stub_property() {
        let expectedReturn = "expected return"
        
        mockExample.stubMethod({ self.mockExample.property }, andReturnValue: expectedReturn)
        let actualReturn = mockExample.property
        
        XCTAssertEqual(expectedReturn, actualReturn)
    } */

}

