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

    static func loadEmails() -> Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    static func contains(_ email: String) -> Bool {
        loadEmails().contains(email)
    }

    static func add(_ email: String) {
        var emails = loadEmails()
        guard emails.insert(email).inserted else { return }
        UserDefaults.standard.set(Array(emails), forKey: key)
    }
}
