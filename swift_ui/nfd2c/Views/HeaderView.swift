//
//  HeaderView.swift
//  nfd2c
//
//  Created by KWS on 12/5/24.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: DirectoryViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                
                HStack {
                    // Image(systemName: "globe")
                        // .foregroundStyle(.tint)
                    
                    Text("NFD2C")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.selectDirectory()
                }) {
                    Image(systemName: "folder.fill")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            
            Divider()
                .overlay(.separator)
                .padding(.vertical, 5)
        }
    }
}
