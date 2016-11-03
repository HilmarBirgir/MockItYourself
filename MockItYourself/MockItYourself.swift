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

public func verify(_ mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, expectedCallCount: Int? = nil, checkArguments: Bool = true, verify: () -> ()) {
    do {
        try mock.callHandler.verify(expectedCallCount: expectedCallCount, checkArguments: checkArguments, method: verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func reject(_ mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, reject: () -> ()) {
    do {
        try mock.callHandler.reject(reject)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func stub<R>(_ mock: MockItYourself, andReturnValue returnValue: R, checkArguments: Bool = true, file: StaticString = #file, line: UInt = #line, method: () -> R) {
     do {
        try mock.callHandler.stub({ _ = method() }, andReturnValue: returnValue, checkArguments: checkArguments)
     } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

public func stub<R>(_ mock: MockItYourself, andReturnValue returnValue: R?, checkArguments: Bool = true, file: StaticString = #file, line: UInt = #line, method: () -> R?) {
    do {
        try mock.callHandler.stub({ _ = method() }, andReturnValue: returnValue, checkArguments: checkArguments)
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
