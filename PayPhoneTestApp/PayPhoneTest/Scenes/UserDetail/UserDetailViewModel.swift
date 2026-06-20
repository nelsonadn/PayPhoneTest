//
//  UserDetailViewModel.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class UserDetailViewModel: ObservableObject {
    @Published var name: String
    @Published var email: String
    @Published var errorMessage: String?
    @Published var isSaving = false

    let user: UserDTO
    private let storageService: StorageServicing

    init(user: UserDTO, storageService: StorageServicing = StorageService()) {
        self.user = user
        self.storageService = storageService
        self.name = user.name
        self.email = user.email
    }

    func saveChanges() async -> Bool {
        errorMessage = validateForm()
        guard errorMessage == nil else { return false }

        isSaving = true
        defer { isSaving = false }

        let updatedUser = UserDTO(
            id: user.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            username: user.username,
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            address: user.address,
            phone: user.phone,
            website: user.website,
            company: user.company
        )

        do {
            try storageService.updateUser(originalEmail: user.email, user: updatedUser)
            return true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            print(":: UserDetailViewModel Error: \(error.localizedDescription)")
            return false
        }
    }

    private func validateForm() -> String? {
        if let error = ValidationRules.required(name) {
            return error
        }

        if let error = ValidationRules.maxLength(name, limit: ValidationRules.nameMaxLength, messageKey: "Name Too Long") {
            return error
        }

        if let error = ValidationRules.required(email) {
            return error
        }

        if let error = ValidationRules.maxLength(email, limit: ValidationRules.emailMaxLength, messageKey: "Email Too Long") {
            return error
        }

        if let error = ValidationRules.email(email) {
            return error
        }

        return nil
    }
}
