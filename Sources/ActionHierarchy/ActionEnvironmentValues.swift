//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

public extension EnvironmentValues {
	var triggerAction: (Action) -> Void {
		{  _ = actionClosure($0) }
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
