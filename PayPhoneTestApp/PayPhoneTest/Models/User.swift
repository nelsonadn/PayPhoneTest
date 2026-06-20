//
//  User.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation

struct UserDTO: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: AddressDTO
    let phone: String
    let website: String
    let company: CompanyDTO
}

struct AddressDTO: Codable, Hashable, Sendable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: GeoDTO
}

struct GeoDTO: Codable, Hashable, Sendable {
    let lat: String
    let lng: String
}

struct CompanyDTO: Codable, Hashable, Sendable {
    let name: String
    let catchPhrase: String
    let bs: String
}
