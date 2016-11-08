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
    
    func methodWithOptionalArgument(_ arg1: String?)
    
    func methodWithArgs0()
    func methodWithArgs0ReturnsOptional() -> String?
    func methodWithArgs0Returns() -> String
    
    func methodWithArgs1(_ arg1: String)
    func methodWithArgs1ReturnsOptional(_ arg1: String) -> String?
    func methodWithArgs1Returns(_ arg1: String) -> String

    func methodWithArgs2(_ arg1: String, arg2: Selector?)
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
    
    func methodWithOptionalArgument(_ arg1: String?) {
        callHandler.registerCall(args: Args1(arg(arg1)))
    }

    func methodWithArgs0() {
        callHandler.registerMethodCall()
    }
    
    func methodWithArgs0ReturnsOptional() -> String? {
        return callHandler.registerCall(defaultReturnValue: nil)
    }
    
    func methodWithArgs0Returns() -> String {
        return callHandler.registerCall(defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodWithArgs1(_ arg1: String) {
        callHandler.registerCall(args: Args1(arg(arg1)))
    }
    
    func methodWithArgs1ReturnsOptional(_ arg1: String) -> String? {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: nil)
    }
    
    func methodWithArgs1ReturnsClass(arg1: String) -> ReturnValueClass {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: ReturnValueClass(value: 1))
    }
    
    func methodWithArgs1Returns(_ arg1: String) -> String {
        return callHandler.registerCall(args: Args1(arg(arg1)), defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodWithArgs2(_ arg1: String, arg2: Selector?) {
        return callHandler.registerCall(args: Args2(arg(arg1), arg(arg2)), defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
    
    func methodWithArgs3(arg1: AnyObject?, arg2: Selector, arg3: Int) -> String {
        return callHandler.registerCall(args: Args3(arg(arg1), arg(arg2), arg(arg3)), defaultReturnValue: MockExampleClass.defaultReturnValue)
    }
}
