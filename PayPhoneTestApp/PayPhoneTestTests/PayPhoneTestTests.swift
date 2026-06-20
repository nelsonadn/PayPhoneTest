//
//  PayPhoneTestTests.swift
//  PayPhoneTestTests
//
//  Created by Nelson Cruz Mora on 20/6/26.
//

import XCTest
@testable import PayPhoneTest

final class PayPhoneTestTests: XCTestCase {
    func testValidationRules_requiredRejectsEmptyValue() {
        XCTAssertEqual(ValidationRules.required(""), "Field Required")
        XCTAssertEqual(ValidationRules.required("   "), "Field Required")
        XCTAssertNil(ValidationRules.required("Nelson"))
    }

    func testValidationRules_emailValidatesFormat() {
        XCTAssertNil(ValidationRules.email("test@example.com"))
        XCTAssertEqual(ValidationRules.email("invalid-email"), "Invalid Email")
        XCTAssertEqual(ValidationRules.email(""), "Field Required")
    }

    func testValidationRules_maxLengthRejectsLongValues() {
        XCTAssertEqual(ValidationRules.maxLength(String(repeating: "a", count: 51), limit: ValidationRules.nameMaxLength, messageKey: "Name Too Long"), "Name Too Long")
        XCTAssertNil(ValidationRules.maxLength("Name", limit: ValidationRules.nameMaxLength, messageKey: "Name Too Long"))
    }

    func testUserDetailViewModel_saveChangesCallsUpdate() async {
        let user = makeUser(email: "original@example.com")
        let storage = StorageServiceSpy()
        let viewModel = UserDetailViewModel(user: user, storageService: storage)
        viewModel.name = "Updated Name"
        viewModel.email = "updated@example.com"

        let result = await viewModel.saveChanges()

        XCTAssertTrue(result)
        XCTAssertEqual(storage.updatedUser?.email, "updated@example.com")
        XCTAssertEqual(storage.updatedUser?.name, "Updated Name")
        XCTAssertEqual(storage.originalEmail, "original@example.com")
    }

    func testUserDetailViewModel_deleteCallsDelete() async {
        let user = makeUser(email: "delete@example.com")
        let storage = StorageServiceSpy()
        let viewModel = UserDetailViewModel(user: user, storageService: storage)

        let result = await viewModel.deleteUser()

        XCTAssertTrue(result)
        XCTAssertEqual(storage.deletedEmail, "delete@example.com")
    }

    private func makeUser(email: String) -> UserDTO {
        UserDTO(
            id: 1,
            name: "Nelson Cruz Mora",
            username: "nelson",
            email: email,
            address: AddressDTO(
                street: "Street",
                suite: "Suite",
                city: "Quito",
                zipcode: "170150",
                geo: GeoDTO(lat: "-0.180653", lng: "-78.467838")
            ),
            phone: "0999999999",
            website: "example.com",
            company: CompanyDTO(name: "Company", catchPhrase: "Catch", bs: "BS")
        )
    }
}

final class StorageServiceSpy: StorageServicing {
    private(set) var savedUsers: [UserDTO] = []
    private(set) var deletedEmail: String?
    private(set) var originalEmail: String?
    private(set) var updatedUser: UserDTO?

    func saveNewUser(_ user: UserDTO) throws {
        savedUsers.append(user)
    }

    func saveNewUsers(_ users: [UserDTO]) throws {
        savedUsers.append(contentsOf: users)
    }

    func deleteUser(email: String) throws {
        deletedEmail = email
    }

    func updateUser(originalEmail: String, user: UserDTO) throws {
        self.originalEmail = originalEmail
        updatedUser = user
    }

    func loadUsers() throws -> [UserDTO] {
        savedUsers
    }
}
