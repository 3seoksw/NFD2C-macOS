//
//  SettingsBarView.swift
//  nfd2c
//
//  Created by KWS on 12/4/24.
//

import SwiftUI

struct FooterView: View {
    @ObservedObject var viewModel: DirectoryViewModel
    @State private var isHovered: Bool = false

    var body: some View {
        HStack {
            Text("NFD2C v0.1.0-alpha")
                .fixedSize()
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "power")
                    .foregroundStyle(isHovered ? .blue : .primary)
            }
            .buttonStyle(BorderlessButtonStyle())
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
        }
        .padding(.top, 5)
        // .frame(maxWidth: .infinity)
    }
}
