//
//  StorageService.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation
import RealmSwift

enum StorageError: LocalizedError {
    case userNotFound
    case duplicateEmail

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User Not Found"
        case .duplicateEmail:
            return "Duplicate Email"
        }
    }
}

extension Notification.Name {
    static let userStorageDidChange = Notification.Name("userStorageDidChange")
}

protocol StorageServicing {
    func saveNewUser(_ user: UserDTO) throws
    func saveNewUsers(_ users: [UserDTO]) throws
    func deleteUser(email: String) throws
    func updateUser(originalEmail: String, user: UserDTO) throws
    func loadUsers() throws -> [UserDTO]
}

final class StorageService: StorageServicing {
    init() {}

    private func normalizedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    func saveNewUser(_ user: UserDTO) throws {
        let email = normalizedEmail(user.email)
        guard !DeletedUsersStore.contains(email) else {
            print(":: StorageService Skipping deleted user: \(user.email)")
            return
        }

        let realm = try Realm()
        guard realm.objects(UserRecord.self).first(where: { normalizedEmail($0.email) == email }) == nil else {
            print(":: StorageService User already exists: \(user.email)")
            return
        }

        try realm.write {
            realm.add(UserRecord(dto: user), update: .modified)
        }

        print(":: StorageService Saved user: \(user.email)")
        NotificationCenter.default.post(name: .userStorageDidChange, object: nil)
    }

    func saveNewUsers(_ users: [UserDTO]) throws {
        let realm = try Realm()
        let existingEmails = Set(realm.objects(UserRecord.self).map { normalizedEmail($0.email) })
        let deletedEmails = DeletedUsersStore.loadEmails()
        let newUsers = users.filter {
            let email = normalizedEmail($0.email)
            return !existingEmails.contains(email) && !deletedEmails.contains(email)
        }

        guard !newUsers.isEmpty else {
            print(":: StorageService No new users to save")
            return
        }

        try realm.write {
            newUsers.forEach { realm.add(UserRecord(dto: $0), update: .modified) }
        }

        print(":: StorageService Saved \(newUsers.count) new users")
        NotificationCenter.default.post(name: .userStorageDidChange, object: nil)
    }

    func deleteUser(email: String) throws {
        let realm = try Realm()
        let normalized = normalizedEmail(email)
        guard let record = realm.objects(UserRecord.self).first(where: { normalizedEmail($0.email) == normalized }) else {
            print(":: StorageService User not found for delete: \(email)")
            return
        }

        try realm.write {
            realm.delete(record)
        }

        print(":: StorageService Deleted user: \(email)")
        DeletedUsersStore.add(normalized)
        NotificationCenter.default.post(name: .userStorageDidChange, object: nil)
    }

    func updateUser(originalEmail: String, user: UserDTO) throws {
        let realm = try Realm()
        let normalizedOriginal = normalizedEmail(originalEmail)
        let normalizedNew = normalizedEmail(user.email)
        guard let record = realm.objects(UserRecord.self).first(where: { normalizedEmail($0.email) == normalizedOriginal }) else {
            print(":: StorageService User not found for update: \(originalEmail)")
            throw StorageError.userNotFound
        }

        let emailExists = realm.objects(UserRecord.self).first(where: { normalizedEmail($0.email) == normalizedNew && normalizedEmail($0.email) != normalizedOriginal }) != nil
        guard !emailExists else {
            print(":: StorageService Email already exists: \(user.email)")
            throw StorageError.duplicateEmail
        }

        try realm.write {
            record.name = user.name
            record.username = user.username
            record.email = user.email
            record.phone = user.phone
            record.website = user.website
            record.street = user.address.street
            record.suite = user.address.suite
            record.city = user.address.city
            record.zipcode = user.address.zipcode
            record.geoLat = user.address.geo.lat
            record.geoLng = user.address.geo.lng
            record.companyName = user.company.name
            record.companyCatchPhrase = user.company.catchPhrase
            record.companyBs = user.company.bs
        }

        print(":: StorageService Updated user: \(originalEmail)")
        NotificationCenter.default.post(name: .userStorageDidChange, object: nil)
    }

    func loadUsers() throws -> [UserDTO] {
        let realm = try Realm()
        let deletedEmails = DeletedUsersStore.loadEmails()
        return realm.objects(UserRecord.self).map(\.dto).filter { !deletedEmails.contains(normalizedEmail($0.email)) }
    }
}
