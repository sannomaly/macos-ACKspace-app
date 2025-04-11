//
//  StateViewModel.swift
//  ACKspace
//
//  Created by sannomaly on 11/04/2025.
//

import Foundation

class StateViewModel: ObservableObject {
    @Published var isOpen: Bool = false
    @Published var lastChange: String = "Laden..."

    var onTooltipUpdate: ((String) -> Void)?
    var onStateUpdate: ((Bool) -> Void)? // 🔹 Callback voor icoon

    private var timer: Timer?

    init() {
        fetchState()
        startAutoRefresh()
    }

    func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            self.fetchState()
        }
    }

    func fetchState() {
        guard let url = URL(string: "https://ackspace.nl/spaceAPI/") else {
            self.lastChange = "Ongeldige URL"
            self.onTooltipUpdate?(self.lastChange)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.lastChange = "Fout: \(error.localizedDescription)"
                    self.onTooltipUpdate?(self.lastChange)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.lastChange = "Geen data"
                    self.onTooltipUpdate?(self.lastChange)
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                let timestamp = TimeInterval(apiResponse.state.lastchange)
                let date = Date(timeIntervalSince1970: timestamp)

                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                let dateString = formatter.string(from: date)

                DispatchQueue.main.async {
                    self.isOpen = apiResponse.state.open
                    self.lastChange = dateString
                    self.onTooltipUpdate?("Laatst gewijzigd op \(dateString)")
                    self.onStateUpdate?(self.isOpen)
                }
            } catch {
                DispatchQueue.main.async {
                    self.lastChange = "Decodeerfout"
                    self.onTooltipUpdate?(self.lastChange)
                }
            }
        }.resume()
    }
}
