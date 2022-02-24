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
struct FifthEvent: Event {}
struct SixthEvent: Event {}
struct SeventhEvent: Event {}
struct EigthEvent: Event {}
struct NinthEvent: Event {}
struct MyError: Error {}

struct ContentView: View {
	@State var alertTitle = ""
	@State var handled = false
	
	var body: some View {
		VStack {
			body0
			body1
			body2
		}
		.alert(alertTitle, isPresented: $handled) {
			Button("Close") {
				handled = false
			}
		}
	}
	
	@ViewBuilder
	var body1: some View {
		//	Non-Failable Modifiers
		TriggerView1()
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
	}
	
	@ViewBuilder
	var body2: some View {
		//	Failable Modifiers
		TriggerView2()
			.receiveEvent { _ in try failable(.notHandled) }
			.transformEvent(FifthEvent.self) { try failable(SixthEvent()) }
			.receiveEvent(SixthEvent.self) { try failable(.notHandled) }
			.handleEvent(SixthEvent.self) {
				alertTitle = "Test 4"
				handled = true
				try failable(())
			}
			.handleEvent(NinthEvent.self) { throw MyError() }
			.transformEvent { _ in try failable(EigthEvent()) }
			.handleEvent { _ in
				alertTitle = "Test 5"
				handled = true
				try failable(())
			}
			.handleError(MyError.self) {
				alertTitle = "Test 6"
				handled = true
			}
	}
	
	var body0: some View {
		TriggerView0()
	}
	
	@discardableResult
	func failable<T>(_ value: T) throws -> T {
		value
	}
}

struct TriggerView0: View {
	@Environment(\.triggerEvent) var triggerEvent

	var body: some View {
		EventButton(FirstEvent()) { Text("Test 0") }
	}
}

struct TriggerView1: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		VStack {
			EventButton(FirstEvent()) {
				Text("Test 1")
			}
			EventButton("Test 2", event: ThirdEvent())
		}
	}
}

struct TriggerView2: View {
	@Environment(\.triggerEvent) var triggerEvent
	
	var body: some View {
		VStack {
			EventButton(FifthEvent()) {
				Text("Test 4")
			}
			EventButton("Test 5", event: SeventhEvent())
			EventButton("Test 6" as LocalizedStringKey, event: NinthEvent())
		}
	}
}
