//
//  UserRecord.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Foundation
import RealmSwift

final class UserRecord: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted(indexed: true) var email: String
    @Persisted var name: String
    @Persisted var username: String
    @Persisted var phone: String
    @Persisted var website: String
    @Persisted var street: String
    @Persisted var suite: String
    @Persisted var city: String
    @Persisted var zipcode: String
    @Persisted var geoLat: String
    @Persisted var geoLng: String
    @Persisted var companyName: String
    @Persisted var companyCatchPhrase: String
    @Persisted var companyBs: String

    convenience init(dto: UserDTO) {
        self.init()
        id = dto.id
        email = dto.email
        name = dto.name
        username = dto.username
        phone = dto.phone
        website = dto.website
        street = dto.address.street
        suite = dto.address.suite
        city = dto.address.city
        zipcode = dto.address.zipcode
        geoLat = dto.address.geo.lat
        geoLng = dto.address.geo.lng
        companyName = dto.company.name
        companyCatchPhrase = dto.company.catchPhrase
        companyBs = dto.company.bs
    }

    var dto: UserDTO {
        UserDTO(
            id: id,
            name: name,
            username: username,
            email: email,
            address: AddressDTO(
                street: street,
                suite: suite,
                city: city,
                zipcode: zipcode,
                geo: GeoDTO(lat: geoLat, lng: geoLng)
            ),
            phone: phone,
            website: website,
            company: CompanyDTO(name: companyName, catchPhrase: companyCatchPhrase, bs: companyBs)
        )
    }
}
