//
//  ContentView.swift
//  EventHierarchyExample
//
//  Created by Emilio Peláez on 6/1/22.
//

import EventHierarchy
import SwiftUI

struct ContentView: View {
	var body: some View {
		ZStack {
			ZStack {
				ZStack {
					TriggerView()
				}
				.receiveEvent(FirstEvent.self) {
					print("Ignoring event", $0)
					return .notHandled
				}
			}
			.transformEvent(FirstEvent.self) {
				print("Transforming event", $0, "to", SecondEvent.second)
				return SecondEvent.second
			}
		}
		.handleEvent(SecondEvent.self) {
			print("Handled Event", $0)
		}
	}
}

enum FirstEvent: Event {
	case first
}

enum SecondEvent: Event {
	case second
}

enum UnhandledEvent: Event {
	case unhandled
}

struct TriggerView: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		VStack(spacing: 20) {
			Button("Trigger First Console Event") {
				triggerEvent(FirstEvent.first)
			}
			EventButton("Trigger Second Console Event", event: SecondEvent.second)
			EventButton("Trigger Unhandled Event" as LocalizedStringKey, event: UnhandledEvent.unhandled)
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
