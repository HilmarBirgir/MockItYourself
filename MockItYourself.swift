//
//  MockItYourself.swift
//  QuizUp
//
//  Created by Alex Verein on 07/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

protocol MockItYourself {
    var callHandler: MockCallHandler { get }
    
    func verify(expectedCallCount: Int, method: () -> ()) throws
    
    func verify(method: () -> ()) throws
    
    func verifyArguments(method: () -> ()) throws
    
    func reject(method: () -> ()) throws
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) throws
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

func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, verify: () -> ())
{
    do {
        try mock.verify(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func verify(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, expectedCallCount: Int, verify: () -> ())
{
    do {
        try mock.verify(expectedCallCount, method: verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func verifyArguments(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, verify: () -> ())
{
    do {
        try mock.verifyArguments(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func reject(mock: MockItYourself, message: String = "", file: StaticString = #file, line: UInt = #line, reject: () -> ())
{
    do {
        try mock.reject(reject)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

// Mark: Any Matchers

func any<T: NSObject>() -> T {
    return T()
}

func any() -> String {
    return ""
}

func any<A, B>() -> [A: B] {
    return [:]
}
