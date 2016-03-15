//
//  MockItYourself.swift
//  QuizUp
//
//  Created by Alex Verein on 07/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

import XCTest

protocol MockItYourself {
    var callHandler: MockCallHandler { get }
    
    func verify(expectedCallCount: Int, fun: () -> ()) throws
    
    func verify(fun: () -> ()) throws
    
    func verifyArguments(fun: () -> ()) throws
    
    func verifyArguments(comparator: (Any, Any) -> Bool, fun: () -> ()) throws
    
    func reject(fun: () -> ()) throws
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?)
}

extension MockItYourself {
    func verify(expectedCallCount: Int, fun: () -> ()) throws {
        try callHandler.verify(expectedCallCount, fun: fun)
    }
    
    func verify(fun: () -> ()) throws {
        try callHandler.verify(fun)
    }
    
    func verifyArguments(fun: () -> ()) throws {
        try self.verifyArguments({ first, second in
            if let f = first as? AnyObject, let s = second as? AnyObject {
                return f === s
            } else {
                return false
            }
        }, fun: fun)
    }
    
    func verifyArguments(comparator: (Any, Any) -> Bool, fun: () -> ()) throws {
        try callHandler.verifyArguments(comparator, fun: fun)
    }
    
    func reject(fun: () -> ()) throws {
        try callHandler.reject(fun)
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) {
        callHandler.stubMethod(method, andReturnValue: returnValue)
    }
}

func verify(mock: MockItYourself, message: String = "", file: String = __FILE__, line: UInt = __LINE__, verify: () -> ())
{
    do {
        try mock.verify(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func verify(mock: MockItYourself, message: String = "", file: String = __FILE__, line: UInt = __LINE__, expectedCallCount: Int, verify: () -> ())
{
    do {
        try mock.verify(expectedCallCount, fun: verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func verifyArguments(mock: MockItYourself, message: String = "", file: String = __FILE__, line: UInt = __LINE__, verify: () -> ())
{
    do {
        try mock.verifyArguments(verify)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func reject(mock: MockItYourself, message: String = "", file: String = __FILE__, line: UInt = __LINE__, reject: () -> ())
{
    do {
        try mock.reject(reject)
    } catch let error {
        XCTFail("\(error)", file:  file, line: line)
    }
}

func stub(mock: MockItYourself, method: () -> (), andReturnValue returnValue: Any?)
{
    mock.stubMethod(method, andReturnValue: returnValue)
}
