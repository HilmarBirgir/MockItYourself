//
//  MockItYourself.swift
//  QuizUp
//
//  Created by Alex Verein on 07/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

import Foundation
import XCTest

public protocol MockItYourself {
    var callHandler: MockCallHandler { get }
}

extension MockItYourself {
    func verify(expectedCallCount: Int, method: () -> ()) throws {
        try callHandler.verify(expectedCallCount, method: method)
    }
    
    func verify(method: () -> ()) throws {
        try callHandler.verify(method)
    }
    
    func verifyArguments(method: () -> ()) throws {
        try callHandler.verifyArguments(method)
    }
    
    func reject(method: () -> ()) throws {
        try callHandler.reject(method)
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) throws {
        try callHandler.stubMethod(method, andReturnValue: returnValue)
    }
}

public func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, verify: () -> ())
{
    do {
        try mock.verify(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, expectedCallCount: Int, verify: () -> ())
{
    do {
        try mock.verify(expectedCallCount, method: verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func verifyArguments(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, verify: () -> ())
{
    do {
        try mock.verifyArguments(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func reject(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, reject: () -> ())
{
    do {
        try mock.reject(reject)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func stub(mock: MockItYourself, andReturnValue returnValue: Any?, file: StaticString = #file, line: UInt = #line, method: () -> ()) {
     do {
        try mock.stubMethod(method, andReturnValue: returnValue)
     } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

// Mark: Any Matchers

public func any<T: NSObject>() -> T {
    return T()
}

public func any() -> String {
    return ""
}

public func any<A, B>() -> [A: B] {
    return [:]
}
