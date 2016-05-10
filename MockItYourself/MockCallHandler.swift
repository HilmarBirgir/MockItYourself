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
    private var isCapturingMethodCall = false

    private var lastCalledMethodName = ""

    public init() {}
    
    private func captureMethodName(captureBlock: () -> ()) throws -> String {
        isCapturingMethodCall = true
        captureBlock()
        // The above block will contain a call to the method that is being mocked.
        // registerCall will set isCapturingMethodCall to false
        // and set lastCalledMethodName
        if isCapturingMethodCall {
            throw MockVerificationError.MethodNotMocked
        }
        
        let methodName = lastCalledMethodName
        lastCalledMethodName = ""

        return methodName
    }

    public func registerCall(callName: String = #function) {
        registerCall(args: Args0(), callName: callName)
    }
    
    public func registerCall<A: Equatable>(args args: A, callName: String = #function) {
        recordCall(args: args, callName: callName)
    }
    
    public func registerCall<R: Any>(defaultReturnValue defaultReturnValue: R?, callName: String = #function) -> R? {
        return registerCall(args: Args0(), defaultReturnValue: defaultReturnValue, callName: callName)
    }
    
    public func registerCall<A: Equatable, R: Any>(args args: A, defaultReturnValue: R?, callName: String = #function) -> R? {
        recordCall(args: args, callName: callName)
        
        if let stubbedReturn = stubbedReturns[callName] {
            return stubbedReturn as? R
        } else {
            return defaultReturnValue
        }
    }

    public func registerCall<R: Any>(defaultReturnValue defaultReturnValue: R, callName: String = #function) -> R {
        return registerCall(args: Args0(), defaultReturnValue: defaultReturnValue, callName: callName)
    }

    public func registerCall<A: Equatable, R: Any>(args args: A, defaultReturnValue: R, callName: String = #function) -> R {
        recordCall(args: args, callName: callName)
        
        if let stubbedReturn = stubbedReturns[callName] {
            return stubbedReturn as! R
        } else {
            return defaultReturnValue
        }
    }
    
    func recordCall<A: Equatable>(args args: A, callName: String) {
        lastCalledMethodName = callName
        
        if let callHistory = recordedCalls[callName] as? CallHistoryRecorder<A> {
            callHistory.record(args, verificationCall: isCapturingMethodCall)
        } else if isCapturingMethodCall == false {
            recordedCalls[callName] = CallHistoryRecorder(firstArgs: args)
        }
        
        isCapturingMethodCall = false
    }

    func verify(expectedCallCount expectedCallCount: Int? = nil, checkArguments: Bool = false, method: () -> ()) throws {
        let methodName = try captureMethodName(method)
        
        if let callHistory = recordedCalls[methodName] {
            if let expectedCallCount = expectedCallCount {
                let actualCallCount = callHistory.count ?? 0
                if expectedCallCount != actualCallCount {
                    throw MockVerificationError.MethodCallCountMismatch(actualCallCount, expectedCallCount)
                }
            }
            
            if checkArguments {
                let matchFound = callHistory.match(checkAll: expectedCallCount != nil)
                if matchFound == false {
                    throw MockVerificationError.ArgumentsMismatch()
                }
            }
        } else {
            throw MockVerificationError.MethodNotCalled
        }
    }
    
    func reject(method: () -> ()) throws {
        var success = false
        
        do {
            try verify(method: method)
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
    func match(checkAll checkAll: Bool) -> Bool
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
    
    func match(checkAll checkAll: Bool = false) -> Bool {
        if let callToLookFor = verificationCall {
            if checkAll {
                return history.map({ $0 == callToLookFor }).contains(false) == false
            } else {
                return history.contains { $0 == callToLookFor }
            }
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
