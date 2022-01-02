//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

public extension EnvironmentValues {
	/**
	 This closure can be used when an `Action` that can't be handled by the
	 current view is generated. The `Action` will be sent up the view hierarchy
	 until it is handled by another view.
	 
	 Views can register a closure to handle these `Actions` using the
	 `receiveAction` and `handleAction` view modifiers.
	 
	 If no view has registered an action that handles the `Action`, an
	 `assertionFailure` will be triggered.
	 */
	var triggerAction: (Action) -> Void {
		{ _ = actionClosure($0) }
	}
}

struct ActionClosureEnvironmentKey: EnvironmentKey {
	static var defaultValue: (Action) -> Action? = { action in
		assertionFailure("Failed to handle action \(action)")
		return nil
	}
}

extension EnvironmentValues {
	var actionClosure: (Action) -> Action? {
		get { self[ActionClosureEnvironmentKey.self] }
		set { self[ActionClosureEnvironmentKey.self] = newValue }
	}
}
