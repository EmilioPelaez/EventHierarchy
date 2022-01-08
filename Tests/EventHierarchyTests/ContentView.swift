//
//  ContentView.swift
//  EventHierarchyTests
//
//  Created by Emilio Peláez on 8/1/22.
//

import SwiftUI

struct FirstEvent: Event {}
struct SecondEvent: Event {}
struct ThirdEvent: Event {}
struct FourthEvent: Event {}

struct ContentView: View {
	@State var alertTitle = ""
	@State var handled = false
	
	var body: some View {
		TriggerView()
			.receiveEvent { _ in .notHandled }
			.transformEvent(FirstEvent.self) { SecondEvent() }
			.receiveEvent(SecondEvent.self) { .notHandled }
			.handleEvent(SecondEvent.self) {
				alertTitle = "Test 1"
				handled = true
			}
			.transformEvent { _ in FourthEvent() }
			.handleEvent { _ in
				alertTitle = "Test 2"
				handled = true
			}
			.alert(alertTitle, isPresented: $handled) {
				Button("Close") {
					handled = false
				}
			}
	}
}

struct TriggerView: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		Button("Test 1") {
			triggerEvent(FirstEvent())
		}
		Button("Test 2") {
			triggerEvent(ThirdEvent())
		}
	}
}
