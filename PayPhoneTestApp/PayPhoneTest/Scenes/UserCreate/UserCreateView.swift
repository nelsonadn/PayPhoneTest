//
//  UserCreateView.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import SwiftUI

struct UserCreateView: View {
    enum Field {
        case name
        case email
        case phone
    }

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @StateObject private var viewModel = UserCreateViewModel()

    var body: some View {
        Form {
            Section(header: Text(getTranslation(key: "User Data"))) {
                TextField(getTranslation(key: "Name"), text: $viewModel.name)
                    .focused($focusedField, equals: .name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.name) { newValue in
                        viewModel.name = String(newValue.prefix(ValidationRules.nameMaxLength))
                    }

                TextField(getTranslation(key: "Email"), text: $viewModel.email)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.email) { newValue in
                        viewModel.email = String(newValue.prefix(ValidationRules.emailMaxLength))
                    }

                TextField(getTranslation(key: "Phone"), text: $viewModel.phone)
                    .focused($focusedField, equals: .phone)
                    .keyboardType(.phonePad)
                    .onChange(of: viewModel.phone) { newValue in
                        viewModel.phone = String(newValue.prefix(ValidationRules.phoneMaxLength))
                    }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(getTranslation(key: errorMessage))
                        .foregroundColor(.red)
                }
            }

            Section {
                Button {
                    Task {
                        if await viewModel.saveUser() {
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(getTranslation(key: "Save"))
                        Spacer()
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .navigationTitle(getTranslation(key: "User Create"))
        .contentShape(Rectangle())
        .onTapGesture {
            guard focusedField != nil else { return }
            focusedField = nil
        }
    }
}
