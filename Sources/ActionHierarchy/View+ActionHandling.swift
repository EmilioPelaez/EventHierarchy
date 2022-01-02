//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

public enum ReceiveActionResult {
	case handled
	case notHandled
}

public extension View {
	
	func receiveAction(_ closure: @escaping (Action) -> ReceiveActionResult) -> some View {
		let handlerModifier = ActionHandlerViewModifier {
			switch closure($0) {
			case .handled: return nil
			case .notHandled: return $0
			}
		}
		return modifier(handlerModifier)
	}
	
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
	
	func receiveAction<Received: Action>(_ type: Received.Type, closure: @escaping () -> ReceiveActionResult) -> some View {
		receiveAction(type) { _ in closure() }
	}
	
	func handleAction(_ handler: @escaping (Action) -> Void) -> some View {
		receiveAction {
			handler($0)
			return .handled
		}
	}
	
	func handleAction<Handled: Action>(_ type: Handled.Type, handler: @escaping (Handled) -> Void) -> some View {
		receiveAction(type) {
			handler($0)
			return .handled
		}
	}
	
	func handleAction<Handled: Action>(_ type: Handled.Type, handler: @escaping () -> Void) -> some View {
		handleAction(type) { _ in handler() }
	}
	
	func transformAction(_ transform: @escaping (Action) -> Action) -> some View {
		modifier(ActionHandlerViewModifier(handler: transform))
	}
	
	func transformAction<Transformed: Action>(_: Transformed.Type, transform: @escaping (Transformed) -> Action) -> some View {
		let transformModifier = ActionHandlerViewModifier {
			guard let action = $0 as? Transformed else { return $0 }
			return transform(action)
		}
		return modifier(transformModifier)
	}
	
	func transformAction<Transformed: Action>(_ type: Transformed.Type, transform: @escaping () -> Action) -> some View {
		transformAction(type) { _ in transform() }
	}
	
}
