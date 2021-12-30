//
//  ContentView.swift
//  ActionHierarchyExample
//
//  Created by Emilio Peláez on 30/12/21.
//

import SwiftUI
import ActionHierarchy

struct ContentView: View {
	var body: some View {
		ZStack {
			ZStack {
				ZStack {
					TriggerView()
				}
				.receiveAction {
					print("Ignoring action", $0)
					return .notHandled
				}
			}
			.transformAction {
				print("Transforming action", $0, "to", SecondAction.second)
				return SecondAction.second
			}
		}
		.handleAction {
			print("Handled Action", $0)
		}
	}
}

enum FirstAction: Action {
	case first
}

enum SecondAction: Action {
	case second
}

struct TriggerView: View {
	@Environment(\.triggerAction) var triggerAction
	
	var body: some View {
		VStack(spacing: 20) {
			Button("Trigger First Console Action") {
				triggerAction(FirstAction.first)
			}
		}
		.buttonStyle(.borderedProminent)
		.tint(.blue)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
