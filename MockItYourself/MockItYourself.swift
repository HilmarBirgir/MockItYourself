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
    func verify(expectedCallCount expectedCallCount: Int? = nil, checkArguments: Bool = false, method: () -> ()) throws {
        try callHandler.verify(expectedCallCount: expectedCallCount, checkArguments: checkArguments, method: method)
    }
    
    func reject(method: () -> ()) throws {
        try callHandler.reject(method)
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) throws {
        try callHandler.stubMethod(method, andReturnValue: returnValue)
    }
}

public func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, expectedCallCount: Int? = nil, checkArguments: Bool = false, verify: () -> ()) {
    do {
        try mock.verify(expectedCallCount: expectedCallCount, checkArguments: checkArguments, method: verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func reject(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, reject: () -> ()) {
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
