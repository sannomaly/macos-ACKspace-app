//
//  StatusBarController.swift
//  ACKspace
//
//  Created by sannomaly on 11/04/2025.
//

import Cocoa
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private var popover = NSPopover()
    private var viewModel = StateViewModel()

    init() {
        let contentView = ContentView(viewModel: viewModel)

        popover.contentSize = NSSize(width: 260, height: 160)
        popover.behavior = .transient
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.target = self
            button.action = #selector(togglePopover(_:))
        }

        viewModel.onTooltipUpdate = { tooltipText in
            DispatchQueue.main.async {
                self.statusItem.button?.toolTip = tooltipText
            }
        }

        viewModel.onStateUpdate = { isOpen in
            DispatchQueue.main.async {
                self.updateStatusText(isOpen: isOpen)
            }
        }

        viewModel.fetchState()
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    private func updateStatusText(isOpen: Bool) {
        let symbol = isOpen ? "🟢" : "🔴"
        statusItem.button?.title = symbol
    }
}
