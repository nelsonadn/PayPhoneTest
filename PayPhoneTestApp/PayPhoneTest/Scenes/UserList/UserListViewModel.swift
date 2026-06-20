//
//  UserListViewModel.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [UserDTO] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkService: NetworkService

    init(networkService: NetworkService? = nil) {
        self.networkService = networkService ?? NetworkService.shared
    }

    func loadUsers() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            users = try await networkService.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
            print(":: UserListViewModel Error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
