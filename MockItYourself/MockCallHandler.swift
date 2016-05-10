//
//  CallHandler.swift
//  QuizUp
//
//  Created by Alex Verein on 03/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

public class MockCallHandler {
    
    private var recordedCalls = [String: CallHistory]()
    private var stubbedReturns = [String: Any]()
    private var expectingFunctionCall = false

    private var lastCalledFunctionName = ""

    public init() {}
    
    private func captureMethodName(method: () -> ()) throws -> String {
        expectingFunctionCall = true
        method()
        if expectingFunctionCall {
            throw MockVerificationError.MethodNotMocked
        }
        
        let methodName = lastCalledFunctionName
        lastCalledFunctionName = ""

        return methodName
    }
    
    public func registerCall(returnValue returnValue: Any? = nil, callName: String = #function) -> Any? {
        return registerCall(args: Args0(), returnValue: returnValue, callName: callName)
    }
    
    public func registerCall<A: Equatable>(args args: A, returnValue: Any? = nil, callName: String = #function) -> Any? {
        lastCalledFunctionName = callName
        
        if let callHistory = recordedCalls[callName] as? CallHistoryRecorder<A> {
            callHistory.record(args, verificationCall: expectingFunctionCall)
        } else if expectingFunctionCall == false {
            recordedCalls[callName] = CallHistoryRecorder(firstArgs: args)
        }
        
        expectingFunctionCall = false
        
        let stubbedReturn = stubbedReturns[callName]
        return stubbedReturn == nil ? returnValue : stubbedReturn is ExpectedNil ? nil : stubbedReturn
    }
    
    func verify(method: () -> ()) throws {
        let methodName = try captureMethodName(method)
        if recordedCalls[methodName] == nil {
            throw MockVerificationError.MethodNotCalled
        }
    }

    func verify(expectedCallCount: Int, method: () -> ()) throws {
        let methodName = try captureMethodName(method)
        
        let actualCallCount = recordedCalls[methodName]?.count ?? 0
        if expectedCallCount != actualCallCount {
            throw MockVerificationError.MethodCallCountMismatch(actualCallCount, expectedCallCount)
        }
    }
    
    func verifyArguments(method: () -> ()) throws {
        let methodName = try captureMethodName(method)
        
        if let callHistory = recordedCalls[methodName] {
            let matchFound = callHistory.match()
            if matchFound == false {
                throw MockVerificationError.ArgumentsMismatch()
            }
        } else {
            throw MockVerificationError.MethodNotCalled
        }
    }
    
    func reject(method: () -> ()) throws {
        var success = false
        
        do {
            try verify(method)
        } catch MockVerificationError.MethodNotMocked {
            throw MockVerificationError.MethodNotMocked
        } catch {
            success = true
        }
        
        if success == false {
            throw MockVerificationError.MethodWasCalled
        }
    }
    
    func stubMethod(method: () -> (), andReturnValue returnValue: Any?) throws {
        let methodName = try captureMethodName(method)
        
        stubbedReturns[methodName] = returnValue == nil ? ExpectedNil() : returnValue
    }
}

protocol CallHistory {
    var count: Int { get }
    func match() -> Bool
}

func any(list: [Bool]) -> Bool {
    for x in list {
        if x {
            return true
        }
    }
    return false
}

class CallHistoryRecorder<A: Equatable> : CallHistory {
    var verificationCall: A?
    var history: [A]
    
    var count: Int {
        return history.count
    }
    
    init(firstArgs: A) {
        history = [firstArgs]
    }
    
    func record(args: A, verificationCall: Bool) {
        if verificationCall {
            self.verificationCall = args
        } else {
            history.append(args)
        }
    }
    
    func match() -> Bool {
        if let callToLookFor = verificationCall {
            return any(history.map({ $0 == callToLookFor }))
        } else {
            return false
        }
    }
}

enum MockVerificationError: ErrorType {
    case MethodNotCalled
    case MethodWasCalled
    case MethodCallCountMismatch(Int, Int)
    case ArgumentsMismatch()
    case MethodNotMocked
}
