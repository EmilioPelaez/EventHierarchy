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

#if canImport(ErrorHierarchy)
import ErrorHierarchy

struct FailableEventHandlerViewModifier: ViewModifier {
	@Environment(\.eventClosure) var eventClosure
	@Environment(\.reportError) var reportError
	
	let handler: (Event) throws -> Event?
	
	func body(content: Content) -> some View {
		content
			.environment(\.eventClosure) {
				do {
					if let result = try handler($0) {
						_ = eventClosure(result)
					}
				} catch {
					reportError(error)
				}
			}
	}
}

#endif
