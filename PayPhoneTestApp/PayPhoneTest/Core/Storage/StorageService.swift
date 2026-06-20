//
//  StorageService.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation
import RealmSwift

extension Notification.Name {
    static let userStorageDidChange = Notification.Name("userStorageDidChange")
}

protocol StorageServicing {
    func saveNewUser(_ user: UserDTO) throws
    func saveNewUsers(_ users: [UserDTO]) throws
    func deleteUser(email: String) throws
    func loadUsers() throws -> [UserDTO]
}

final class StorageService: StorageServicing {
    init() {}

    func saveNewUser(_ user: UserDTO) throws {
        let realm = try Realm()
        guard realm.objects(UserRecord.self).first(where: { $0.email == user.email }) == nil else {
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
        let existingEmails = Set(realm.objects(UserRecord.self).map(\.email))
        let newUsers = users.filter { !existingEmails.contains($0.email) }

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
        guard let record = realm.objects(UserRecord.self).first(where: { $0.email == email }) else {
            print(":: StorageService User not found for delete: \(email)")
            return
        }

        try realm.write {
            realm.delete(record)
        }

        print(":: StorageService Deleted user: \(email)")
        NotificationCenter.default.post(name: .userStorageDidChange, object: nil)
    }

    func loadUsers() throws -> [UserDTO] {
        let realm = try Realm()
        return realm.objects(UserRecord.self).map(\.dto)
    }
}
