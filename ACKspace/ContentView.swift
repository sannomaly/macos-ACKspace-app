//
//  StatusBarController.swift
//  ACKspace
//
//  Created by sannomaly on 11/04/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: StateViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.isOpen ? "🟢 Open" : "🔴 Gesloten")
                .font(.headline)
            Text("Laatste wijziging:")
            Text(viewModel.lastChange)
                .font(.caption)
                .foregroundColor(.gray)
            Divider()
            Button("Ververs") {
                viewModel.fetchState()
            }
            Button("Afsluiten") {
                NSApp.terminate(nil)
            }
        }
        .padding()
        .frame(width: 220)
    }
}

