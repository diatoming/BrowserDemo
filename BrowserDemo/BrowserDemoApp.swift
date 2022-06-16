//
//  BrowserDemoApp.swift
//  BrowserDemo
//
//  Created by Diatoming on 6/14/22.
//

import SwiftUI

@main
struct BrowserDemoApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 800, maxHeight: .infinity)
        }
        .windowToolbarStyle(.unified)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        let win = NSApp.mainWindow
        win?.tabbingMode = .preferred
        
        TopSitesManager.shared.load()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        TopSitesManager.shared.save()
    }
    
}

/// NSWindow accessor for SwiftUI View
struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
