import SwiftUI
import AppKit
import Foundation

@main
struct AppCloser: App {
	var body: some Scene {
		WindowGroup {
			AppCloserView()
		}
	}
}

struct AppInfo: Identifiable {
	let id = UUID()
	let name: String
	let icon: NSImage?
	var shouldClose: Bool
}

struct AppCloserView: View {
	@State private var apps: [AppInfo] = []
	@State private var isLoaded = false
	@State private var showAccessoryApps = false

	var body: some View {
		VStack(alignment: .leading) {
			Text("Select apps to close:")
			.font(.headline)

			Toggle("Include menu bar / accessory apps", isOn: $showAccessoryApps)
			.padding(.bottom, 8)
			.onChange(of: showAccessoryApps) { _ in
				loadApps()
			}

			List {
				ForEach($apps) { $app in
					HStack(alignment: .center, spacing: 12) {
						if let icon = app.icon {
							Image(nsImage: icon)
							.resizable()
							.frame(width: 48, height: 48)
						}
						Toggle(app.name, isOn: $app.shouldClose)
						.font(.system(size: 24))
					}
					.padding(.vertical, 6)
					.frame(maxWidth: .infinity, alignment: .leading)
				}
			}
			.frame(maxHeight: .infinity)

			HStack {
				Spacer()
				Button("Cancel") {
					NSApplication.shared.terminate(nil)
				}
				Button("Close Selected Apps") {
					closeSelectedApps()
					NSApplication.shared.terminate(nil)
				}
				.keyboardShortcut(.defaultAction)
			}
		}
		.padding()
		.frame(width: 800, height: 600)
		.onAppear(perform: loadApps)
	}

	func loadApps() {
		guard !isLoaded else { return }
		isLoaded = true

		let runningApps = NSWorkspace.shared.runningApplications

		let filtered = runningApps
		.filter {
			$0.activationPolicy == .regular || (showAccessoryApps && $0.activationPolicy == .accessory)
		}
		.compactMap { app -> AppInfo? in
			guard let name = app.localizedName else { return nil }
			let shouldClose = app.activationPolicy == .regular
			return AppInfo(name: name, icon: app.icon, shouldClose: shouldClose)
		}
		.filter { $0.name != "Finder" }
		.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }

		apps = filtered
		print("[Debug] Loaded apps: \(apps.map { "\($0.name): \($0.shouldClose ? "✅" : "⬜️")" })")
	}

	func closeSelectedApps() {
		let toClose = apps.filter { $0.shouldClose }.map { $0.name }
		for app in toClose {
			let quitScript = "tell application \"\(app)\" to quit"
			_ = runAppleScript(quitScript)
			usleep(10000) // 0.01 seconds
		}
	}

	func runAppleScript(_ script: String) -> String? {
		print("[AppleScript] Running:\n\(script)\n")

		var error: NSDictionary?
		if let appleScript = NSAppleScript(source: script) {
			let output = appleScript.executeAndReturnError(&error)
			if let error = error {
				if let code = error[NSAppleScript.errorNumber] as? Int, code == -128 {
					print("[AppleScript] User canceled quit for: \(script)")
				} else {
					print("[AppleScript] Error: \(error)")
				}
				return nil
			}
			print("[AppleScript] Output: \(output.stringValue ?? "<nil>")")
			return output.stringValue
		}
		print("[AppleScript] Failed to compile")
		return nil
	}
}
