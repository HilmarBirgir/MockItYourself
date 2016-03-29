//
//  MockCallRecorder.swift
//  QuizUp
//
//  Created by Jóhann Þorvaldur Bergþórsson on 10/03/16.
//  Copyright © 2016 Plain Vanilla Games. All rights reserved.
//

// This type only exists to complete the generics for the Arg type
// in the AnyObject case
struct AnyObjectArgument : Equatable {}

func ==(lhs: AnyObjectArgument, rhs: AnyObjectArgument) -> Bool {
    return false
}

// Mark: Arg

enum Arg<A: AnyObject, B: Equatable> : Equatable {
    case AnyObject(A)
    case Equatable(B)
    case List([B])
    case Nil
}

func ==<A: AnyObject, B: Equatable>(lhs: Arg<A, B>, rhs: Arg<A, B>) -> Bool {
    switch (lhs, rhs) {
    case (.AnyObject(let x), .AnyObject(let y)):
        switch (x, y) {
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
        case let (lhs as NSObject, rhs as NSObject):
            return lhs.isEqual(rhs)
        default:
            return x === y
        }
    case (.Equatable(let x), .Equatable(let y)):
        return x == y
    case (.List(let x), .List(let y)):
        return x == y
    case (.Nil, .Nil):
        return true
    default:
        return false
    }
}

func arg(anyObject: AnyObject) -> Arg<AnyObject, AnyObjectArgument> {
    return Arg.AnyObject(anyObject)
}

func arg(anyClass: AnyClass) -> Arg<AnyObject, AnyObjectArgument> {
    return Arg.AnyObject(anyClass)
}

func arg<A: Equatable>(equatable: A) -> Arg<AnyObject, A> {
    return Arg.Equatable(equatable)
}

func arg<A: Equatable>(list: [A]) -> Arg<AnyObject, A> {
    return Arg.List(list)
}

func arg<A: Equatable, B: Equatable>(dict: [A: B]) -> Arg<AnyObject, String> {
    let flattened = dict.map({"\($0):\($1)"})
    return Arg.List(flattened)
}

func arg<A: Equatable>(equatable: A?) -> Arg<AnyObject, A> {
    if let equatable = equatable {
        return Arg.Equatable(equatable)
    } else {
        return Arg.Nil
    }
}

// MARK: Args0

class Args0 : Equatable {}

func ==(lhs: Args0, rhs: Args0) -> Bool {
    return true
}

// MARK: Args1

class Args1<A1: Equatable> : Equatable  {
    let arg1: Arg<AnyObject, A1>
    
    init(_ arg1: Arg<AnyObject, A1>) {
        self.arg1 = arg1
    }
}

func ==<A1>(lhs: Args1<A1>, rhs: Args1<A1>) -> Bool {
    return lhs.arg1 == rhs.arg1
}

// MARK: Args2

class Args2<A1: Equatable, A2: Equatable> : Equatable {
    let arg1: Arg<AnyObject, A1>
    let arg2: Arg<AnyObject, A2>
    
    init(_ arg1: Arg<AnyObject, A1>, _ arg2: Arg<AnyObject, A2>) {
        self.arg1 = arg1
        self.arg2 = arg2
    }
}

func ==<A1, A2>(lhs: Args2<A1, A2>, rhs: Args2<A1, A2>) -> Bool {
    return lhs.arg1 == rhs.arg1 && lhs.arg2 == rhs.arg2
}

// MARK: Args3

class Args3<A1: Equatable, A2: Equatable, A3: Equatable> : Equatable  {
    let arg1: Arg<AnyObject, A1>
    let arg2: Arg<AnyObject, A2>
    let arg3: Arg<AnyObject, A3>
    
    init(_ arg1: Arg<AnyObject, A1>, _ arg2: Arg<AnyObject, A2>, _ arg3: Arg<AnyObject, A3>) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.arg3 = arg3
    }
}

func ==<A1, A2, A3>(lhs: Args3<A1, A2, A3>, rhs: Args3<A1, A2, A3>) -> Bool {
    return lhs.arg1 == rhs.arg1 && lhs.arg2 == rhs.arg2 && lhs.arg3 == rhs.arg3
}
