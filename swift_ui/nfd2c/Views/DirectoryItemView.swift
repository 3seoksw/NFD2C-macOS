//
//  DirectoryItemView.swift
//  nfd2c
//
//  Created by KWS on 12/8/24.
//

import SwiftUI

struct DirectoryItemView: View {
    @ObservedObject var viewModel: DirectoryViewModel
    @State private var isHovered: Bool = false
    let path: String
    let isFile: Bool
    
    var body: some View {
        Button(action: {
            openInFinder()
        }) {
            HStack(spacing: 12) {
                let icon = getPathIcon(for: path)
                Image(nsImage: icon)
                
                if isFile {
                    let shortenedPath = shortenPath(viewModel.urlPath, path)
                    Text("\(shortenedPath)")
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .foregroundStyle(isHovered ? .blue : .white)
                } else {
                    let shortenedPath = shortenUserPath(path)
                    Text("\(shortenedPath)")
                        .foregroundStyle(isHovered ? .blue : .white)
                }
            }
            .transition(.move(edge: .top))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
    
    private func openInFinder() {
        if isFile {
            let directory = (path as NSString).deletingLastPathComponent
            NSWorkspace.shared.open(URL(fileURLWithPath: directory))
        } else {
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    }
}
