//
//  ValidationRules.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation

enum ValidationRules {
    static let nameMaxLength = 50
    static let emailMaxLength = 100
    static let phoneMaxLength = 20

    static func required(_ value: String) -> String? {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Field Required" : nil
    }

    static func name(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return "Field Required"
        }

        return trimmed.count <= nameMaxLength ? nil : "Name Too Long"
    }

    static func email(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return "Field Required"
        }

        guard trimmed.count <= emailMaxLength else {
            return "Email Too Long"
        }

        let pattern = #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: trimmed) ? nil : "Invalid Email"
    }

    static func phone(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return "Field Required"
        }

        guard trimmed.count <= phoneMaxLength else {
            return "Phone Too Long"
        }

        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+-() "))
        return trimmed.unicodeScalars.allSatisfy { allowed.contains($0) } ? nil : "Invalid Phone"
    }
}
