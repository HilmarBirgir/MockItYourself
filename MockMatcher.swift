//
//  MockMatcher.swift
//  QuizUp
//
//  Created by Alex Verein on 07/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

public class MockMatcher {
    private let comparator: (Any, Any) -> Bool
    
    init(comparator: (Any, Any) -> Bool) {
        self.comparator = comparator
    }
    
    func matchArrays(firstArray: [Any?]?, _ secondArray: [Any?]?) -> Bool {
        
        let comparedOptionalability = compareOptionals(firstArray, secondArray)

        if (comparedOptionalability.matched) {
            return comparedOptionalability.result
        }
        
        var result = true

        if let arrayOne = firstArray, let arrayTwo = secondArray {
            if arrayOne.count != arrayOne.count {
                result = false
            }
            
            for i in (0..<arrayOne.count) {
                result = match(arrayOne[i], arrayTwo[i])
                if !result {
                    return false
                }
            }
        }
        
        return result
    }
    
    func match(firstAnyOptional: Any?, _ secondAnyOptional: Any?) -> Bool {
        
        let comparedOptionalability = compareOptionals(firstAnyOptional, secondAnyOptional)

        if (comparedOptionalability.matched) {
            return comparedOptionalability.result
        }

        switch (firstAnyOptional, secondAnyOptional) {
            case let (lhs as String, rhs as String):
                return lhs == rhs
            case let (lhs as Int, rhs as Int):
                return lhs == rhs
            case let (lhs as Double, rhs as Double):
                return lhs == rhs
            case let (lhs as Bool, rhs as Bool):
                return lhs == rhs
            case let (lhs as Selector, rhs as Selector):
                return lhs.description == rhs.description
            default:
                return comparator(firstAnyOptional!, secondAnyOptional!)
        }
    }

    private func compareOptionals(optionalOne: Any?, _ optionalTwo: Any?) -> (matched: Bool, result: Bool) {
        
        switch (optionalOne, optionalTwo) {
            case (nil, nil):
                return (true, true)
            case (nil, _):
                return (true, false)
            case (_, nil):
                return (true, false)
            default:
                return (false, false)
        }
    }
}

