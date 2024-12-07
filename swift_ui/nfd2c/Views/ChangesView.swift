//
//  ChangesView.swift
//  nfd2c
//
//  Created by KWS on 12/5/24.
//

import SwiftUI

struct ChangesView: View {
    @ObservedObject var viewModel: DirectoryViewModel
    var numberOfTrackingChanges = 3
    var trackingRecentFiles: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.changeDetected {
                // let changes = viewModel.recentChanges
                let recentChanges = viewModel.recentChanges

                // let recentChanges = Array(changes.suffix(numberOfTrackingChanges))
                
                VStack(alignment: .leading) {
                    Text("Recently Changed File(s): \(recentChanges.count)")
                        .fixedSize()
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 3)
                    
                    ForEach(recentChanges, id: \.self) { change in
                        DirectoryItemView(viewModel: viewModel, path: change, isFile: true)
                        // .offset(x:0)
                        // .animation(.easeInOut, value: recentChanges)
                        // .transition(.move(edge: .top))
                    }
                    // .animation(.easeInOut(duration: 0.3), value: recentChanges)
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
