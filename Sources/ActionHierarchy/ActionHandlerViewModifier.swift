//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct ActionHandlerViewModifier: ViewModifier {
	@Environment(\.actionClosure) var actionClosure
	
	let handler: (Action) -> Action?
	
	func body(content: Content) -> some View {
		content
			.environment(\.actionClosure) {
				if let result = handler($0) {
					_ = actionClosure(result)
				}
				return nil
			}
	}
}
