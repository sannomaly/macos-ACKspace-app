//
//  Model.swift
//  ACKspace
//
//  Created by sannomaly on 11/04/2025.
//

struct ApiResponse: Codable {
    let state: State
}

struct State: Codable {
    let open: Bool
    let lastchange: Int
}
