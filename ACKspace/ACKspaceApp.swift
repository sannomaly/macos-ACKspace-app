//
//  ACKspaceApp.swift
//  ACKspace
//
//  Created by sannomaly on 11/04/2025.
//

import SwiftUI

@main
struct MenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // verberg dock icoon
        NSApp.setActivationPolicy(.accessory)
        
        statusBarController = StatusBarController()
    }
}
