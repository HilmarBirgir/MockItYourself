//
//  TestFixtures.swift
//  MockItYourself
//
//  Created by Jóhann Þorvaldur Bergþórsson on 09/05/16.
//
//

import Foundation
import MockItYourself

protocol ExampleProtocol {
    
    var property: String { get }
    
    func methodThatIsNotMocked()
    
    func methodWithOptionalArgument(arg1: String?)
    
    func methodWithArgs0()
    func methodWithArgs1(arg1: String) -> String
    func methodWithArgs2(arg1: AnyObject, arg2: Selector) -> String
}

class ExampleClass: ExampleProtocol {
    var property: String {
        return "hardcoded value"
    }
    
    func methodThatIsNotMocked() {
        print("methodThatIsNotMocked")
    }
    
    func methodWithOptionalArgument(arg1: String?) {
        print("methodWithOptionalArgument(\(arg1))")
    }
    
    func methodWithArgs0() {
        print("methodWithArgs0")
    }
    
    func methodWithArgs1(arg1: String) -> String {
        print("methodWithArgs1(arg1: \(arg1))")
        return "return value"
    }
    
    func methodWithArgs2(arg1: AnyObject, arg2: Selector) -> String {
        print("methodWithArgs1(arg1: \(arg1), arg2: \(arg2))")
        return "return value"
    }
}

class MockExampleClass: ExampleClass, MockItYourself {
    let callHandler = MockCallHandler()
    
    static let defaultReturnValue = "default return value"
    
    override var property: String {
        return callHandler.registerCall(returnValue: MockExampleClass.defaultReturnValue) as! String
    }
    
    override func methodThatIsNotMocked() {
        //Not mocked method
    }
    
    override func methodWithOptionalArgument(arg1: String?) {
        callHandler.registerCall(args: Args1(arg(arg1)))
    }
    
    override func methodWithArgs0() {
        callHandler.registerCall()
    }
    
    override func methodWithArgs1(arg1: String) -> String {
        return callHandler.registerCall(args: Args1(arg(arg1)), returnValue: MockExampleClass.defaultReturnValue) as! String
    }
    
    override func methodWithArgs2(arg1: AnyObject, arg2: Selector) -> String {
        return callHandler.registerCall(args: Args2(arg(arg1), arg(arg2)), returnValue: MockExampleClass.defaultReturnValue) as! String
    }
}
