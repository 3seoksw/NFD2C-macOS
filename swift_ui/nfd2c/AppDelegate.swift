//
//  AppDelegate.swift
//  nfd2c
//
//  Created by KWS on 12/1/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    let fixedPopoverWidth: CGFloat = 300

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = "NFD2C"
            button.action = #selector(togglePopover(_:))
        }

        let hostingController = NSHostingController(rootView: ContentView())
        popover.contentViewController = hostingController
        
        // popover.behavior = .transient
    }

    @objc func togglePopover(_ sender: Any?) {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
            }
        }
    }
}
