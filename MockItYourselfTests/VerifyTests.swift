//
//  VerifyTests.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//

import XCTest
@testable import MockItYourself

class VerifyTests: XCTestCase {
    
    var mockExample: MockExampleClass!
    
    override func setUp() {
        super.setUp()
        
        mockExample = MockExampleClass()
    }
    
    func test_verifying_not_mocked_method_throws_assert() {
        var success = false
        
        do {
            try mockExample.verify() { self.mockExample.methodThatIsNotMocked() }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_can_verify_exactly_1_call_of_method_with_no_arguments() {
        mockExample.methodWithArgs0()
        
        verify(mockExample, expectedCallCount: 1) { self.mockExample.methodWithArgs0() }
    }
    
    func test_can_verify_many_calls_of_method_with_no_arguments() {
        mockExample.methodWithArgs0()
        mockExample.methodWithArgs0()
        
        verify(mockExample, expectedCallCount: 2) { self.mockExample.methodWithArgs0() }
    }
    
    func test_verify_asserts_when_not_enough_calls_of_method_with_no_arguments() {
        var success = false
        
        mockExample.methodWithArgs0()
        
        do {
            try mockExample.verify(expectedCallCount: 2) { self.mockExample.methodWithArgs0() }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_can_verify_method_was_called_with_no_arguments() {
        mockExample.methodWithArgs0()
        
        verify(mockExample) { self.mockExample.methodWithArgs0() }
    }
    
    func test_can_verify_method_was_called_ignoring_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        
        verify(mockExample) { self.mockExample.methodWithArgs2(any(), arg2: nil) }
    }
    
    func test_verify_asserts_if_method_is_not_called() {
        var success = false
        
        do {
            try mockExample.verify() { self.mockExample.methodWithArgs2(any(), arg2: nil) }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_can_verify_method_call_and_check_if_correct_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        
        verify(mockExample, checkArguments: true) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
    }
    
    func test_can_verify_method_call_and_check_if_correct_arguments_with_expected_number_of_calls() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        
        verify(mockExample, checkArguments: true, expectedCallCount: 2) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
    }
    
    func test_asserts_if_checking_if_correct_arguments_with_expected_number_of_calls_if_call_number_mismatch() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        
        var success = false
        do {
            try mockExample.verify(checkArguments: true, expectedCallCount: 2) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_asserts_if_checking_if_correct_arguments_with_expected_number_of_calls_if_one_call_has_different_arguments() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2(arg1, arg2: arg2)
        mockExample.methodWithArgs2("different argument", arg2: arg2)
        
        var success = false
        do {
            try mockExample.verify(checkArguments: true, expectedCallCount: 2) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
    
    func test_can_verify_method_call_and_check_if_argument_is_optional() {
        let arg1 = "arg1"
        
        mockExample.methodWithArgs1(arg1)
        
        verify(mockExample, checkArguments: true) { self.mockExample.methodWithArgs1(arg1) }
    }
    
    func test_verify_arguments_assert_if_method_is_not_called_at_all() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        var success = false
        
        do {
            try mockExample.verify(checkArguments: true) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }

    func test_verify_arguments_asserts_if_arguments_does_not_match() {
        let arg1 = "arg1"
        let arg2: Selector = #selector(NSString.substringToIndex(_:))
        
        mockExample.methodWithArgs2("", arg2: arg2)
        
        var success = false
        
        do {
            try mockExample.verify(checkArguments: true) { self.mockExample.methodWithArgs2(arg1, arg2: arg2) }
        } catch {
            success = true
        }
        
        XCTAssertTrue(success)
    }
}
