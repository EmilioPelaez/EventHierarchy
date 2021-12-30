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
				.receiveAction(FirstAction.self) {
					print("Ignoring action", $0)
					return .notHandled
				}
			}
			.transformAction(FirstAction.self) {
				print("Transforming action", $0, "to", SecondAction.second)
				return SecondAction.second
			}
		}
		.handleAction(SecondAction.self) {
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

enum UnhandledAction: Action {
	case unhandled
}

struct TriggerView: View {
	@Environment(\.triggerAction) var triggerAction
	
	var body: some View {
		VStack(spacing: 20) {
			Button("Trigger First Console Action") {
				triggerAction(FirstAction.first)
			}
			Button("Trigger Second Console Action") {
				triggerAction(SecondAction.second)
			}
			Button("Trigger Unhandled Action") {
				triggerAction(UnhandledAction.unhandled)
			}
			.tint(.red)
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
