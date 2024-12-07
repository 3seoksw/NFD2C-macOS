//
//  ContentView.swift
//  nfd2c
//
//  Created by KWS on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DirectoryViewModel(maxCount: 3)
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(viewModel: viewModel)
            
            MonitorView(viewModel: viewModel)
            
            ChangesView(viewModel: viewModel)
            
            FooterView(viewModel: viewModel)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
