//
//  DeletedUsersStore.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation

private func normalizedDeletedEmail(_ email: String) -> String {
    email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

enum DeletedUsersStore {
    private static let key = "deleted_user_emails"

    static func loadEmails() -> Set<String> {
        Set((UserDefaults.standard.stringArray(forKey: key) ?? []).map(normalizedDeletedEmail))
    }

    static func contains(_ email: String) -> Bool {
        loadEmails().contains(normalizedDeletedEmail(email))
    }

    static func add(_ email: String) {
        var emails = loadEmails()
        guard emails.insert(normalizedDeletedEmail(email)).inserted else { return }
        UserDefaults.standard.set(Array(emails), forKey: key)
    }
}
