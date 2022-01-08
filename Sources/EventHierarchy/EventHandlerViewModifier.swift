//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI

struct EventHandlerViewModifier: ViewModifier {
	@Environment(\.eventClosure) var eventClosure
	
	let handler: (Event) -> Event?
	
	func body(content: Content) -> some View {
		content
			.environment(\.eventClosure) {
				if let result = handler($0) {
					_ = eventClosure(result)
				}
			}
	}
}
