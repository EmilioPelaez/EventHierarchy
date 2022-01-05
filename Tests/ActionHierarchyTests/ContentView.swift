//
//  ContentView.swift
//  ActionHierarchyTests
//
//  Created by Emilio Peláez on 6/1/22.
//

import SwiftUI

struct FirstAction: Action {}
struct SecondAction: Action {}
struct ThirdAction: Action {}
struct FourthAction: Action {}

struct ContentView: View {
	@State var alertTitle = ""
	@State var handled = false
	
	var body: some View {
		TriggerView()
			.receiveAction { _ in .notHandled }
			.transformAction(FirstAction.self) { SecondAction() }
			.receiveAction(SecondAction.self) { .notHandled }
			.handleAction(SecondAction.self) {
				alertTitle = "Test 1"
				handled = true
			}
			.transformAction { _ in FourthAction() }
			.handleAction { _ in
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
	@Environment(\.triggerAction) var triggerAction
	
	var body: some View {
		Button("Test 1") {
			triggerAction(FirstAction())
		}
		Button("Test 2") {
			triggerAction(ThirdAction())
		}
	}
}
