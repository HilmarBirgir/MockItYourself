//
//  MockItYourself.swift
//  QuizUp
//
//  Created by Alex Verein on 07/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

protocol Mock {
    var callHandler: MockCallHandler { get }
    
    func verify(callsCount: Int, fun: () -> ())
    
    func verify(fun: () -> ()) throws
    
    func verifyArguments(fun: () -> ())
    
    func verifyArguments(fun: () -> (), comparator: (Any, Any) -> Bool)
    
    func reject(fun: () -> ())
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?)
}

extension Mock {
    func verify(callsCount: Int, fun: () -> ()) {
        callHandler.verify(callsCount, fun: fun)
    }
    
    func verify(fun: () -> ()) throws {
        try callHandler.verify(fun)
    }
    
    func verifyArguments(fun: () -> ()) {
        self.verifyArguments(fun, comparator: { first, second in
            if let f = first as? AnyObject, let s = second as? AnyObject {
                return f === s
            } else {
                return false
            }
        })
    }
    
    func verifyArguments(fun: () -> (), comparator: (Any, Any) -> Bool) {
        callHandler.verifyArguments(fun, comparator: comparator)
    }
    
    func reject(fun: () -> ()) {
        callHandler.reject(fun)
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) {
        callHandler.stubMethod(method, andReturnValue: returnValue)
    }
}
