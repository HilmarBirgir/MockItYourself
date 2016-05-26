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
    func verify(expectedCallCount expectedCallCount: Int? = nil, checkArguments: Bool = true, method: () -> ()) throws {
        try callHandler.verify(expectedCallCount: expectedCallCount, checkArguments: checkArguments, method: method)
    }
    
    func reject(method: () -> ()) throws {
        try callHandler.reject(method)
    }
    
    func stub(method: () -> (), andReturnValue returnValue: Any?, checkArguments: Bool = true) throws {
        try callHandler.stub(method, andReturnValue: returnValue, checkArguments: checkArguments)
    }
}

public func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, expectedCallCount: Int? = nil, checkArguments: Bool = true, verify: () -> ()) {
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

public func stub(mock: MockItYourself, andReturnValue returnValue: Any?, checkArguments: Bool = true, file: StaticString = #file, line: UInt = #line, method: () -> ()) {
     do {
        try mock.stub(method, andReturnValue: returnValue, checkArguments: checkArguments)
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
