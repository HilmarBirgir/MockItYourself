//
//  CallHandler.swift
//  QuizUp
//
//  Created by Alex Verein on 03/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

class MockCallHandler {
    
    var functionCallsCounts = [String: Int]()
    var functionCallsArguments = [String: [[Any?]]]()
    var stubbedReturns = [String: Any]()

    var expectingFunctionCall = false

    private var lastCalledFunctionName = ""
    
    private var lastCalledFunction: (functionName: String, calledArguments: [Any?]) {
        unregisterLastCall()
        let callArguments = lastCallArguments(lastCalledFunctionName)
        
        defer {
            lastCalledFunctionName = ""
        }
        
        return (functionName: lastCalledFunctionName, calledArguments: callArguments)
    }
    
    private func getFunctionDescription(fun: () -> ()) throws -> (functionName: String, calledArguments: [Any?]) {
        expectingFunctionCall = true
        fun()
        if (expectingFunctionCall) {
            throw MockVerificationError.MethodNotMocked
        }

        return lastCalledFunction
    }
    
    func registerCall(returnValue: Any? = nil, args: [Any?] = [], callName: String = __FUNCTION__) -> Any? {
        expectingFunctionCall = false
        
        lastCalledFunctionName = callName
        
        if let prevArgs = functionCallsArguments[callName] {
            functionCallsArguments.updateValue(prevArgs + [args], forKey: callName)
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
    
    private func lastCallArguments(funcName: String) -> [Any?] {
        if let prevFuncArguments = functionCallsArguments[lastCalledFunctionName] {
            if prevFuncArguments.count > 0 {
                if let arguments = functionCallsArguments[lastCalledFunctionName]?.removeLast() {
                    if functionCallsArguments[lastCalledFunctionName]?.count == 0 {
                        functionCallsArguments.removeValueForKey(lastCalledFunctionName)
                    }
                    return arguments
                }
            }
        }
        return []
    }
    
    func verify(expectedCallCount: Int, fun: () -> ()) throws {
        let callName = try getFunctionDescription(fun).functionName
        
        let actualCallCount = functionCallsCounts[callName] ?? 0
        
        if expectedCallCount != actualCallCount {
            throw MockVerificationError.MethodCallCountMismatch(actualCallCount, expectedCallCount)
        }
    }
    
    func verify(fun: () -> ()) throws  {
        let functionName = try getFunctionDescription(fun).functionName
        if functionCallsCounts[functionName] == nil {
            throw MockVerificationError.MethodNotCalled
        }
    }
    
    func verifyArguments(comparator: (Any, Any) -> Bool, fun: () -> ()) throws {
        let function = try getFunctionDescription(fun)
        
        if let prevFuncArguments = functionCallsArguments[function.functionName] {
            var matchFound = false
            let matcher = MockMatcher(comparator: comparator)
            for args in prevFuncArguments {
                matchFound = matcher.matchArrays(args, function.calledArguments)
            }
            
            if !matchFound {
                throw MockVerificationError.ArgumentsMismatch(prevFuncArguments, function.calledArguments)
            }
        }
        else
        {
            throw MockVerificationError.MethodNotCalled
        }
    }
    
    func reject(fun: () -> ()) throws {
        var success = false
        
        do {
            try verify(fun)
        } catch {
            success = true
        }
        
        if !success {
            throw MockVerificationError.MethodWasCalled
        }
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) {
        method()
        let callName = lastCalledFunction.functionName
        
        stubbedReturns[callName] = returnValue == nil ? ExpectedNil() : returnValue
    }
}

enum MockVerificationError: ErrorType {
    case MethodNotCalled
    case MethodWasCalled
    case MethodCallCountMismatch(Int, Int)
    case ArgumentsMismatch([[Any?]], [Any?])
    case MethodNotMocked
}