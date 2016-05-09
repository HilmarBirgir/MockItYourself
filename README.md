# MockItYourself

[![CI Status](http://img.shields.io/travis/plain-vanilla-games/MockItYourself.svg?style=flat)](https://travis-ci.org/Jóhann Þ. Bergþórsson/MockItYourself)
[![Version](https://img.shields.io/cocoapods/v/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)
[![License](https://img.shields.io/cocoapods/l/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)
[![Platform](https://img.shields.io/cocoapods/p/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)

`MockItYourself` is an attempt to create a mocking framework for Swift. Currently, you can't dynamically create classes in Swift and it is therefore impossible to create a powerful mocking framework like [OCMock](http://ocmock.org/). `MockItYourself` is an attempt to reduce the boilerplate needed to manually create mocks.

`MockItYourself` is heavily inspired by [SwiftMock](https://github.com/mflint/SwiftMock) and could in some ways be considered a fork of that project.

## Installation

MockItYourself is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

target 'MyApp' do

end

target 'MyApp_Tests', :exclusive => true do
    pod 'MockItYourself', '1.0.0'
end

```

## Motivation

The standard way of mocking out dependencies in Swift is to manually create your own mocks: 

```swift
class Dependency {
    func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        print("Do something really slow and expensive with arguments")
        return 40.0
    }
}

class MockDependency: Dependency {
    var didCallSlowAndExpensiveMethod: Bool = false
    var lastCalledArg1: String?
    var lastCalledArg2: Int?
    
    override func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        didCallSlowAndExpensiveMethod = true
        lastCalledArg1 = arg1
        lastCalledArg2 = arg2
        
        return 50.0
    }
}

struct ObjectUnderTests {
    let dependency: Dependency
    
    func method() -> Double {
        let result = dependency.slowAndExpensiveMethod("A", arg2: 1)
        return result / 2
    }
}

class MockExampleTests: XCTestCase {
    var mockDependency: MockDependency!
    var objectUnderTest: ObjectUnderTests!
    
    override func setUp() {
        mockDependency = MockDependency()
        objectUnderTest = ObjectUnderTests(dependency: mockDependency)
    }
    
    func test_did_call_method_on_dependency_with_correct_arguments() {
        let _ = objectUnderTest.method()
        
        XCTAssert(mockDependency.didCallSlowAndExpensiveMethod)
        XCTAssertEqual(mockDependency.lastCalledArg1, "A")
        XCTAssertEqual(mockDependency.lastCalledArg2, 1)
    }
    
    func test_method_returns_correct_result_given_dependency_returns_50() {
        let result = objectUnderTest.method()
        
        XCTAssertEqual(result, 25.0)
    }
}
```

This quickly becomes tedious and `MockItYourself` is an attempt to reduce the boilerplate.


```swift
class Dependency {
    func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        print("Do something really slow and expensive with arguments")
        return 40.0
    }
}

class MockDependency: Dependency, MockItYourself {
    let callHandler = MockCallHandler()
    
    override func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        return callHandler.registerCall(args: Args2(arg(arg1), arg(arg2)), defaultReturnValue: 50) as! Double
    }
}

struct ObjectUnderTests {
    let dependency: Dependency
    
    func method() -> Double {
        let result = dependency.slowAndExpensiveMethod("A", arg2: 1)
        return result / 2
    }
}

class MockExampleTests: XCTestCase {
    var mockDependency: MockDependency!
    var objectUnderTest: ObjectUnderTests!
    
    override func setUp() {
        mockDependency = MockDependency()
        objectUnderTest = ObjectUnderTests(dependency: mockDependency)
    }
    
    func test_did_call_method_on_dependency_with_correct_arguments() {
        let _ = objectUnderTest.method()
        
        verify(mockDependency) { self.mockDependency.slowAndExpensiveMethod("A", arg2: 1) }
    }
    
    func test_method_returns_correct_result_given_dependency_returns_50() {
        stub(mockDependency, andReturnValue: 50) { mockDependency.slowAndExpensiveMethod("A", arg2: 1) }

        let result = objectUnderTest.method()
        
        XCTAssertEqual(result, 25.0)
    }
}

```

## Authors

+ Alexey Verein, alexey@plainvanillagames.com
+ Jóhann Þ. Bergþórsson, johann@plainvanillagames.com
+ Magnus Ó. Magnússon, magnus@plainvanillagames.com

## License

MockItYourself is available under the MIT license. See the LICENSE file for more info.
