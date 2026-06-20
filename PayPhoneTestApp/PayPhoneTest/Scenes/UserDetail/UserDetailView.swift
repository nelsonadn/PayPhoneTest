//
//  UserDetailView.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    enum Field {
        case name
        case email
    }

    let user: UserDTO
    @FocusState private var focusedField: Field?
    @StateObject private var viewModel: UserDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false

    init(user: UserDTO) {
        self.user = user
        _viewModel = StateObject(wrappedValue: UserDetailViewModel(user: user))
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 16) {
                    Image("placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 84, height: 84)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.username)
                            .appTitleStyle()
                        Text(user.phone)
                            .appDetailStyle()
                        Text(user.address.city)
                            .appDetailStyle()
                    }
                }
                .padding(.vertical, 8)
            }

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
            }

            detailSection(titleKey: "Phone") {
                detailValue(user.phone)
            }

            detailSection(titleKey: "Website") {
                detailValue(user.website)
            }

            detailSection(titleKey: "Company") {
                detailValue(user.company.name)
                detailValue(user.company.catchPhrase)
                detailValue(user.company.bs)
            }

            detailSection(titleKey: "Address") {
                detailValue(user.address.street)
                detailValue(user.address.suite)
                detailValue(user.address.city)
                detailValue(user.address.zipcode)
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(getTranslation(key: errorMessage))
                        .foregroundColor(.red)
                }
            }

            HStack(spacing: 12) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text(getTranslation(key: "Delete User"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isSaving || viewModel.isDeleting)

                Button {
                    Task {
                        if await viewModel.saveChanges() {
                            print(":: UserDetailView user updated: \(viewModel.email)")
                        }
                    }
                } label: {
                    Text(getTranslation(key: "Save"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSaving)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
        }
        .navigationTitle(getTranslation(key: "User Detail"))
        .alert(getTranslation(key: "Delete User"), isPresented: $showDeleteAlert) {
            Button(getTranslation(key: "Cancel"), role: .cancel) {}
            Button(getTranslation(key: "Delete"), role: .destructive) {
                Task {
                    if await viewModel.deleteUser() {
                        dismiss()
                    }
                }
            }
        } message: {
            Text(getTranslation(key: "Delete Confirmation"))
        }
        .onAppear {
            print(":: UserDetailView user: \(user)")
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard focusedField != nil else { return }
            focusedField = nil
        }
    }

    @ViewBuilder
    private func detailSection(titleKey: String, @ViewBuilder content: () -> some View) -> some View {
        Section(header: Text(getTranslation(key: titleKey))) {
            content()
        }
    }

    @ViewBuilder
    private func detailValue(_ value: String) -> some View {
        if !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Text(value)
        }
    }
}
