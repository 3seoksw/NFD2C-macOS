//
//  nfd2cApp.swift
//  nfd2c
//
//  Created by KWS on 12/3/24.
//

import SwiftUI

@main
struct nfd2cApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
