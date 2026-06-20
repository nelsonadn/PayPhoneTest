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
    private let storageService: StorageServicing
    private var didLoadOnce = false

    init(
        networkService: NetworkService,
        storageService: StorageServicing
    ) {
        self.networkService = networkService
        self.storageService = storageService
    }



    func loadUsers() async {
        guard !didLoadOnce else { return }
        didLoadOnce = true
        isLoading = true
        errorMessage = nil

        do {
            let remoteUsers = try await networkService.fetchUsers()
            try storageService.saveNewUsers(remoteUsers)
            users = try storageService.loadUsers()
        } catch {
            do {
                users = try storageService.loadUsers()
            } catch {
                errorMessage = error.localizedDescription
                print(":: UserListViewModel Error: \(error.localizedDescription)")
            }
        }

        isLoading = false
    }
}
