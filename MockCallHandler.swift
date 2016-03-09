//
//  CallHandler.swift
//  QuizUp
//
//  Created by Alex Verein on 03/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

class MockCallHandler {
    
    var functionCallsCounts = [String: Int]()
    var functionCallsArguments = [String: [[Any?]?]]()
    var stubbedReturns = [String: Any]()

    var expectingFunctionCall = false

    private var lastCalledFunctionName = ""
    
    private var lastCalledFunction: (functionName: String, calledArguments: [Any?]?) {
        unregisterLastCall()
        let callArguments = lastCallArguments(lastCalledFunctionName)
        
        defer {
            lastCalledFunctionName = ""
        }
        
        return (functionName: lastCalledFunctionName, calledArguments: callArguments)
    }
    
    private func getFunctionDescription(fun: () -> ()) -> (functionName: String, calledArguments: [Any?]?) {
        expectingFunctionCall = true
        fun()
        if (expectingFunctionCall) {
            
        }

        return lastCalledFunction
    }
    
    func registerCall(returnValue: Any? = nil, args: [Any?]? = nil, callName: String = __FUNCTION__) -> Any? {
        lastCalledFunctionName = callName
        
        if let r = functionCallsArguments[callName] {
            functionCallsArguments.updateValue(r + [args], forKey: callName)
        } else {
            functionCallsArguments.updateValue([args], forKey: callName)
        }
        
        var callsCount = 1
        if let prevCallsCount = functionCallsCounts[callName] {
            callsCount += prevCallsCount
        }
        functionCallsCounts.updateValue(callsCount, forKey: callName)
        
        let stubbedReturn = stubbedReturns[callName]
        return stubbedReturn == nil ? returnValue : stubbedReturn is ExpectedNil ? nil : stubbedReturn
    }
    
    private func unregisterLastCall() {
        if let prevCallsCount = functionCallsCounts[lastCalledFunctionName] {
            let callsCount = prevCallsCount - 1
            if (callsCount != 0) {
                functionCallsCounts.updateValue(callsCount, forKey: lastCalledFunctionName)
            } else {
                functionCallsCounts.removeValueForKey(lastCalledFunctionName)
            }
        }
    }
    
    private func lastCallArguments(funcName: String) -> [Any?]? {
        if let prevFuncArguments = functionCallsArguments[lastCalledFunctionName] {
            if prevFuncArguments.count > 0 {
                let arguments = functionCallsArguments[lastCalledFunctionName]?.removeLast()
                if functionCallsArguments[lastCalledFunctionName]?.count == 0 {
                    functionCallsArguments.removeValueForKey(lastCalledFunctionName)
                }
                return arguments
            }
        }
        return nil
    }
    
    func verify(callsCount: Int, fun: () -> ()) {
        let callName = getFunctionDescription(fun).functionName
        
        verify(callName)
        
        if let calls = functionCallsCounts[callName] {
            XCTAssertEqual(calls, callsCount)
        }
    }
    
    func verify(fun: () -> ()) throws  {
        let functionName = getFunctionDescription(fun).functionName
        if functionCallsCounts[functionName] == nil {
            throw MockVerificationError.MethodNotCalled
        }
    }
    
    func verifyArguments(fun: () -> (), comparator: (Any, Any) -> Bool) {
        let function = getFunctionDescription(fun)
        
        if let prevFuncArguments = functionCallsArguments[function.functionName] {
            var matchFound = false
            let matcher = MockMatcher(comparator: comparator)
            for args in prevFuncArguments {
                matchFound = matcher.matchArrays(args, function.calledArguments)
            }
            XCTAssertTrue(matchFound)
        }
        else
        {
            XCTFail()
        }
    }
    
    private func verify(callName: String) {
        XCTAssertNotNil(functionCallsCounts[callName])
    }
    
    func reject(fun: () -> ()) {
        let callName = getFunctionDescription(fun).functionName
        XCTAssertNil(functionCallsCounts[callName])
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) {
        method()
        let callName = lastCalledFunction.functionName
        
        stubbedReturns[callName] = returnValue == nil ? ExpectedNil() : returnValue
    }
}

enum MockVerificationError: ErrorType {
    case MethodNotCalled
}