//
//  ChangesView.swift
//  nfd2c
//
//  Created by KWS on 12/5/24.
//

import SwiftUI

struct ChangesView: View {
    @ObservedObject var viewModel: DirectoryViewModel
    @State private var showButtonIsHovered: Bool = false
    @State private var showAll: Bool = false
    @State private var height: CGFloat = 0
    var numberOfShowingChanges = 3
    var trackingRecentFiles: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.changeDetected {
                // TODO: `recentChanges` must be a Queue type for tracking recent changes
                let recentChanges = viewModel.recentChanges

                let isScrollView = showAll && recentChanges.count > numberOfShowingChanges
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Recent Change(s)")
                            .fixedSize()
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 3)
                        
                        Spacer()
                        
                        if recentChanges.count > 3 {
                            Button(action: {
                                showAll.toggle()
                            }) {
                                Text(showAll ? "Show Less" : "Show More")
                                    .font(.footnote)
                                    .foregroundStyle(showButtonIsHovered ? .blue : .primary)
                            }
                            .buttonStyle(.plain)
                            .onHover { hovering in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showButtonIsHovered = hovering
                                }
                            }
                        }
                    }
                    
                    let displayingChanges = isScrollView ? recentChanges : Array(recentChanges.prefix(3))
                    
                    if !isScrollView {
                        ForEach(displayingChanges, id: \.self) { change in
                            DirectoryItemView(viewModel: viewModel, path: change, isFile: true)
                        }
                        .animation(.easeInOut, value: displayingChanges)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(displayingChanges, id: \.self) { change in
                                    DirectoryItemView(viewModel: viewModel, path: change, isFile: true)
                                }
                                .animation(.easeInOut, value: displayingChanges)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        if viewModel.changeDetected {
            Divider()
                .overlay(.separator)
                .padding(.vertical, 5)
        }
    }
}
