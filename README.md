# Event Hierarchy

[![Tests](https://github.com/EmilioPelaez/EventHierarchy/actions/workflows/tests.yml/badge.svg)](https://github.com/EmilioPelaez/EventHierarchy/actions/workflows/tests.yml)
[![codecov](https://codecov.io/gh/EmilioPelaez/ErrorHierarchy/branch/main/graph/badge.svg?token=PTWX2D5ZVK)](https://codecov.io/gh/EmilioPelaez/ErrorHierarchy)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20Mac%20|%20tvOS%20-lightgray.svg)]()
[![Swift 5.5](https://img.shields.io/badge/swift-5.5-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)
[![Twitter](https://img.shields.io/badge/twitter-@emiliopelaez-blue.svg)](http://twitter.com/emiliopelaez)

`EventHierarchy` is a small framework designed to use the SwiftUI view hierarchy as a responder chain.

Using a closure contained in `EnvironmentValues`, `View` objects that are lower in the hierarchy send `Event` objects up the view hierarchy, while views that are higher in the hierarchy use one of the modifiers to register themselves as a responder to receive, transform, or handle the `Event` objects.

## Events

`Event` is requirement-less protocol that identifies a type as an event that can be sent up the SwiftUI view hierarchy.

It can be of any type and contain any kind of additional information. It exists to avoid annotating the types used by methods in this framework as `Any`.

## Triggering an `Event`

Events are triggered using the `triggerEvent` closure added to `EnvironmentValues`.

Example:

```swift
struct MyEvent: Event {}

struct TriggerView: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		Button("Trigger") {
			triggerEvent(MyEvent())
		}
	}
}
```

## Receiving, Handling and Transforming an `Event`

There are three kinds of operations that can be applied to an `Event` that has been triggered. All of these are executed by registering a closure the same way you would apply a view modifier to a `View`.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.receiveEvent { .notHandled }
			.transformEvent { MyEvent() }
			.handleEvent {}
	}
}
```

All of these functions have a generic version that receives the type of an `Event` as the first parameter, only events matching the provided type will be acted on, any other event will be propagated up the view hierarchy.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.handleEvent(MyEvent.self) {}
	}
}
```

### Receiving an `Event`

When receiving an `Event`, it's up to the registered closure to determine whether the `Event` has been fully handled or not.

If the registered closure returns `.handled`, the `Event` will no longer be propagated up the view hierarchy.
If it returns `.unhandled` instead, the `Event` will continue to be propagated.

### Handling an `Event`

Any event that is handled will no longer be propagated up the view hierarchy. This is equivalent to using a `receiveEvent` closure that always returns `.handled`.

### Transforming an `Event`

Transforming functions can be used to replace the received `Event`. It could be an `Event` of a different type, or an `Event` of the same type but with different values.
