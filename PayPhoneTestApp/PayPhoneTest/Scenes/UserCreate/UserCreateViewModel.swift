//
//  UserCreateViewModel.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

@MainActor
final class UserCreateViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var errorMessage: String?
    @Published var isSaving = false

    private let storageService: StorageServicing

    init(storageService: StorageServicing? = nil) {
        self.storageService = storageService ?? StorageService()
    }

    func saveUser() async -> Bool {
        errorMessage = validateForm()
        guard errorMessage == nil else { return false }

        isSaving = true
        defer { isSaving = false }

        let user = UserDTO(
            id: Int(Date().timeIntervalSince1970),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            username: name.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
            address: AddressDTO(
                street: "",
                suite: "",
                city: "",
                zipcode: "",
                geo: GeoDTO(lat: latitude.trimmingCharacters(in: .whitespacesAndNewlines), lng: longitude.trimmingCharacters(in: .whitespacesAndNewlines))
            ),
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
            website: "",
            company: CompanyDTO(name: "", catchPhrase: "", bs: "")
        )

        do {
            try storageService.saveNewUser(user)
            return true
        } catch {
            errorMessage = error.localizedDescription
            print(":: UserCreateViewModel Error: \(error.localizedDescription)")
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

        if let error = ValidationRules.required(phone) {
            return error
        }

        if let error = ValidationRules.maxLength(phone, limit: ValidationRules.phoneMaxLength, messageKey: "Phone Too Long") {
            return error
        }

        if let error = ValidationRules.phone(phone) {
            return error
        }

        return nil
    }
}
