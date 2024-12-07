//
//  MonitorView.swift
//  nfd2c
//
//  Created by KWS on 12/5/24.
//

import SwiftUI

struct MonitorView: View {
    @ObservedObject var viewModel: DirectoryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Monitoring Directory")
                .fixedSize()
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                .padding(.bottom, 3)
            
            
            if viewModel.urlPath == "" {
                Text("No Directory Specified")
            } else {
                DirectoryItemView(viewModel: viewModel, path: viewModel.urlPath, isFile: false)
                // let shortenedPath = shortenUserPath(viewModel.urlPath)
                // HStack(spacing: 12) {
                    // let icon = getPathIcon(for: viewModel.urlPath)
                    // Image(nsImage: icon)
                    // Text("\(shortenedPath)")
                // }
            }
            
            Divider()
                .overlay(.separator)
                .padding(.vertical, 5)
        }
        // .frame(maxWidth: .infinity, alignment: .leading)
    }
}

