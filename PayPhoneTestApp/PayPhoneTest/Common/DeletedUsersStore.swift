//
//  DeletedUsersStore.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation

enum DeletedUsersStore {
    private static let key = "deleted_user_emails"

    private static func normalized(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    static func loadEmails() -> Set<String> {
        Set((UserDefaults.standard.stringArray(forKey: key) ?? []).map(normalized))
    }

    static func contains(_ email: String) -> Bool {
        loadEmails().contains(normalized(email))
    }

    static func add(_ email: String) {
        var emails = loadEmails()
        guard emails.insert(normalized(email)).inserted else { return }
        UserDefaults.standard.set(Array(emails), forKey: key)
    }
}
