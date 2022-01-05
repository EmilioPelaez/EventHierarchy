# ActionHierarchy

`ActionHierarchy` is a small framework designed to use the SwiftUI view hierarchy as a responder chain.

`View` objects that are lower in the hierarchy send `Action` objects up the view hierarchy, while views that are higher in the hierarchy use one of the modifiers to register themselves as a responder to receive, transform, or handle the `Action` objects.

## Actions

`Action` is requirement-less protocol that identifies a type as an action that can be sent up the SwiftUI view hierarchy.

It can be of any type and contain any kind of additional information. It exists to avoid annotating the types used by methods in this framework as `Any`.

## Triggering an `Action`

Actions are triggered using the `triggerAction` closure added to `EnvironmentValues`.

Example:

```swift
enum MyAction: Action {}

struct TriggerView: View {
	@Environment(\.triggerAction) var triggerAction
	
	var body: some View {
		Button("Trigger") {
			triggerAction(MyAction())
		}
	}
}
```

## Receiving, Handling and Transforming an `Action`

There are three kinds of operations that can be applied to an `Action` that has been triggered. All of these are executed by registering a closure the same way you would apply a view modifier to a `View`.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.receiveAction { .notHandled }
			.transformAction { MyAction() }
			.handleAction {}
	}
}
```

All of these functions have a generic version that receives the type of an `Action` as the first parameter, only actions matching the provided type will be acted on, any other action will be propagated up the view hierarchy.

```swift
struct ContentView: View {
	var body: some View {
		TriggerView()
			.handleAction(MyAction.self) {}
	}
}
```

### Receiving an `Action`

When receiving an `Action`, it's up to the registered closure to determine whether the `Action` has been fully handled or not.

If the registered closure returns `.handled`, the `Action` will no longer be propagated up the view hierarchy.
If it returns `.unhandled` instead, the `Action` will continue to be propagated.

### Handling an `Action`

Any action that is handled will no longer be propagated up the view hierarchy. This is equivalent to using a `receiveAction` closure that always returns `.handled`.

### Transforming an `Action`

Transforming functions can be used to replace the received `Action`. It could be an `Action` of a different type, or an `Action` of the same type but with different values.
