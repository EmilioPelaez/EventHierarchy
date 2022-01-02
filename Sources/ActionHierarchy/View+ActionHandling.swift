//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

/**
 When a `View` registers a closure using the `receiveAction` modifier, the
 closure should return `.handled` when the `Action` has been handled, and
 should no longer be propagated up the view hierarchy, and `.notHandled` when
 the `Action` has not been completely handled.
 */
public enum ReceiveActionResult {
	case handled
	case notHandled
}

public extension View {
	
	/**
	 Registers a closure to receive all `Actions` triggered using the
	 `triggerAction` Environment closure.
	 
	 The registered closure should return `.handled` when the `Action` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Action` has not been completely handled.
	 */
	func receiveAction(_ closure: @escaping (Action) -> ReceiveActionResult) -> some View {
		let handlerModifier = ActionHandlerViewModifier {
			switch closure($0) {
			case .handled: return nil
			case .notHandled: return $0
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Actions` of the supplied type triggered using
	 the `triggerAction` Environment closure.
	 
	 The registered closure should return `.handled` when the `Action` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Action` has not been completely handled.
	 */
	func receiveAction<Received: Action>(_: Received.Type, closure: @escaping (Received) -> ReceiveActionResult) -> some View {
		let handlerModifier = ActionHandlerViewModifier {
			guard let action = $0 as? Received else { return $0 }
			switch closure(action) {
			case .handled: return nil
			case .notHandled: return $0
			}
		}
		return modifier(handlerModifier)
	}
	
	/**
	 Registers a closure to receive `Actions` of the supplied type triggered using
	 the `triggerAction` Environment closure.
	 
	 The registered closure should return `.handled` when the `Action` has been
	 handled, and should no longer be propagated up the view hierarchy, and
	 `.notHandled` when the `Action` has not been completely handled.
	 */
	func receiveAction<Received: Action>(_ type: Received.Type, closure: @escaping () -> ReceiveActionResult) -> some View {
		receiveAction(type) { _ in closure() }
	}
	
	/**
	 Registers a closure to handle all `Actions` triggered using the
	 `triggerAction` Environment closure.
	 
	 Using this modifier will effectively **stop the propagation of all actions
	 up the view hierarchy.**
	 */
	func handleAction(_ handler: @escaping (Action) -> Void) -> some View {
		receiveAction {
			handler($0)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Actions` of the supplied type triggered using
	 the `triggerAction` Environment closure.
	 
	 `Actions` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Actions` will be ignored and propagated up the view hierarchy.
	 */
	func handleAction<Handled: Action>(_ type: Handled.Type, handler: @escaping (Handled) -> Void) -> some View {
		receiveAction(type) {
			handler($0)
			return .handled
		}
	}
	
	/**
	 Registers a closure to handle `Actions` of the supplied type triggered using
	 the `triggerAction` Environment closure.
	 
	 `Actions` of the supplied type will be passed to the handling closure and no
	 longer propagated up the view hierarhcy.
	 
	 Any other `Actions` will be ignored and propagated up the view hierarchy.
	 */
	func handleAction<Handled: Action>(_ type: Handled.Type, handler: @escaping () -> Void) -> some View {
		handleAction(type) { _ in handler() }
	}
	
	/**
	 Registers a closure to transform all `Actions` triggered using the
	 `triggerAction` Environment closure.
	 
	 The closure should return an `Action` that can be a new `Action` or the same
	 `Action` that was supplied as a parameter.
	 */
	func transformAction(_ transform: @escaping (Action) -> Action) -> some View {
		modifier(ActionHandlerViewModifier(handler: transform))
	}
	
	/**
	 Registers a closure to transform `Actions` of the supplied type triggered
	 using the `triggerAction` Environment closure.
	 
	 The closure should return an `Action` that can be a new `Action` or the same
	 `Action` that was supplied as a parameter.
	 */
	func transformAction<Transformed: Action>(_: Transformed.Type, transform: @escaping (Transformed) -> Action) -> some View {
		let transformModifier = ActionHandlerViewModifier {
			guard let action = $0 as? Transformed else { return $0 }
			return transform(action)
		}
		return modifier(transformModifier)
	}
	
	/**
	 Registers a closure to transform `Actions` of the supplied type triggered
	 using the `triggerAction` Environment closure.
	 
	 The closure should return a new `Action` that will be propagated up the view
	 hierarchy.
	 */
	func transformAction<Transformed: Action>(_ type: Transformed.Type, transform: @escaping () -> Action) -> some View {
		transformAction(type) { _ in transform() }
	}
	
}
