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
	
	func handleAction(_ handler: @escaping (Action) -> Void) -> some View {
		receiveAction {
			handler($0)
			return .handled
		}
	}
	
	func transformAction(_ transform: @escaping (Action) -> Action) -> some View {
		modifier(ActionHandlerViewModifier(handler: transform))
	}
	
}
