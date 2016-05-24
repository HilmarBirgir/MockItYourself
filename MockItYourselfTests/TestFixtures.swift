//
//  TestFixtures.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//
//

import Foundation
import MockItYourself

class ReturnValueClass {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
}

protocol ExampleProtocol {
    
    var property: String { get }
    var propertyImplicitlyUnwrapped: String! { get }
    
    func methodThatIsNotMocked()
    
    func methodWithOptionalArgument(arg1: String?)
    
    func methodWithArgs0()
    func methodWithArgs0ReturnsOptional() -> String?
    func methodWithArgs0Returns() -> String
    
    func methodWithArgs1(arg1: String)
    func methodWithArgs1ReturnsOptional(arg1: String) -> String?
    func methodWithArgs1Returns(arg1: String) -> String
    
    func methodWithArgs2(arg1: AnyObject, arg2: Selector) -> String
}

class MockExampleClass: ExampleProtocol, MockItYourself {
    let callHandler = MockCallHandler()
    
    static let defaultReturnValue = "default return value"
    
    var property: String {
        return callHandler.registerCall(defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    var propertyOptional: String? {
        return callHandler.registerCall(defaultReturnValue: nil)
    }
    
    var propertyImplicitlyUnwrapped: String! {
        return callHandler.registerCall(defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodThatIsNotMocked() {
        //Not mocked method
    }
    
    func methodWithOptionalArgument(arg1: String?) {
        callHandler.registerCall(args: Args1(arg(arg1)))
    }
    
    func methodWithArgs0() {
        callHandler.registerCall()
    }
    
    func methodWithArgs0ReturnsOptional() -> String? {
        return callHandler.registerCall(defaultReturnValue: nil)
    }
    
    func methodWithArgs0Returns() -> String {
        return callHandler.registerCall(defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodWithArgs1(arg1: String) {
        callHandler.registerCall(args: Args1(arg(arg1)))
    }
    
    func methodWithArgs1ReturnsOptional(arg1: String) -> String? {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: nil)
    }
    
    func methodWithArgs1ReturnsClass(arg1: String) -> ReturnValueClass {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: ReturnValueClass(value: 1))
    }
    
    func methodWithArgs1Returns(arg1: String) -> String {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodWithArgs2(arg1: AnyObject, arg2: Selector) -> String {
        return callHandler.registerCall(args: Args2(arg(arg1), arg(arg2)), defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
}
