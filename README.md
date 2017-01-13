# MockItYourself

[![CI Status](http://img.shields.io/travis/plain-vanilla-games/MockItYourself.svg?style=flat)](https://travis-ci.org/plain-vanilla-games/MockItYourself)
[![Version](https://img.shields.io/cocoapods/v/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)
[![License](https://img.shields.io/cocoapods/l/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)
[![Platform](https://img.shields.io/cocoapods/p/MockItYourself.svg?style=flat)](http://cocoapods.org/pods/MockItYourself)


Note: Be aware is the readme for Swift 3.0. See the branch `swift-2.3` for Swift 2.3 documentation.

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

## Usage

`MockItYourself` helps reduce boilerplate when manually creating mocks. Let's imagine that we have the following class:

```swift
class Dependency {
    func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        return 40.0
    }
}
```

Creating the mock is simple:

1. Create a subclass of `Dependency`.
2. Implement the `MockItYourself` protocol by adding a `callHandler` property.
3. Register the methods that you want to mock or stub.

```swift
import MockItYourself

class MockDependency: Dependency, MockItYourself {
    let callHandler = MockCallHandler()
    
    override func slowAndExpensiveMethod(arg1: String, arg2: Int) -> Double {
        return callHandler.registerCall(args: Args2(arg(arg1), arg(arg2)), defaultReturnValue: 50)
    }
}
```

### Verify

`MockItYourself` allows you to verify if methods on your mocks are called with the

To verify a method was called:

```swift
func test_verify() {
    mock.slowAndExpensiveMethod("A", arg2: 1)
    
    verify(mock) { self.mock.slowAndExpensiveMethod(any(), arg2: any()) }
}
```

To verify a method was called n number of times:

```swift
func test_verify_number_of_calls() {
    mock.slowAndExpensiveMethod("A", arg2: 1)
    mock.slowAndExpensiveMethod("A", arg2: 1)

    verify(mock, expectedCallCount: 2) { self.mock.slowAndExpensiveMethod(any(), arg2: any()) }
}
```

To verify a method was called with the specific arguments:

```swift
func test_verify_with_arguments() {
    mock.slowAndExpensiveMethod("A", arg2: 1)

    verify(mock, checkArguments: true) { self.mock.slowAndExpensiveMethod("A", arg2: 1) }
}
```

### Reject

To verify a method was not called:

```swift
func test_reject() {
    reject(mock) { self.mock.slowAndExpensiveMethod("A", arg2: 1) }
}
```

### Stubbing

To stub out the return value of a method or property:

```swift
func test_stubbing() {
    stub(mock, andReturnValue: 30) { self.mock.slowAndExpensiveMethod("A", arg2: 1) }

    let returnValue = mock.slowAndExpensiveMethod("A", arg2: 1)
    XCTAssertEqual(returnValue, 30)
}
```

## Authors

+ Alexey Verein, alexey@plainvanillagames.com
+ Jóhann Þ. Bergþórsson, johann@plainvanillagames.com
+ Magnus Ó. Magnússon, magnus@plainvanillagames.com
+ Alexander A. Helgason, alliannas@plainvanillagames.com

## License

MockItYourself is available under the MIT license. See the LICENSE file for more info.
