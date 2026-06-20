//
//  UserCreateView.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Combine
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
    @StateObject private var locationService = LocationService()
    @State private var showLocationAlert = false
    @State private var locationAlertMessage = ""
    @State private var isLocationRequestActive = false

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

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(getTranslation(key: "Latitude"))
                            .foregroundColor(.secondary)
                            .appCaptionStyle()
                        Text(viewModel.latitude.isEmpty ? "-" : viewModel.latitude)
                            .appDetailStyle()
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(getTranslation(key: "Longitude"))
                            .foregroundColor(.secondary)
                            .appCaptionStyle()
                        Text(viewModel.longitude.isEmpty ? "-" : viewModel.longitude)
                            .appDetailStyle()
                    }
                }
            }

            Section {
                Button {
                    isLocationRequestActive = true
                    showLocationAlert = false
                    locationAlertMessage = ""
                    locationService.alertMessage = nil
                    locationService.requestCurrentLocation()
                } label: {
                    HStack {
                        Spacer()
                        Text(getTranslation(key: "Get Location"))
                        Spacer()
                    }
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
        .onAppear {
            viewModel.latitude = ""
            viewModel.longitude = ""
            locationService.alertMessage = nil
            locationService.latitude = ""
            locationService.longitude = ""
            showLocationAlert = false
            locationAlertMessage = ""
            isLocationRequestActive = false
        }
        .onReceive(locationService.$latitude) { latitude in
            guard isLocationRequestActive else { return }
            viewModel.latitude = latitude
            guard !latitude.isEmpty, !viewModel.longitude.isEmpty else { return }
            locationAlertMessage = "\(getTranslation(key: "Latitude")): \(latitude)\n\(getTranslation(key: "Longitude")): \(viewModel.longitude)"
            showLocationAlert = true
            isLocationRequestActive = false
        }
        .onReceive(locationService.$longitude) { longitude in
            guard isLocationRequestActive else { return }
            viewModel.longitude = longitude
            guard !viewModel.latitude.isEmpty, !longitude.isEmpty else { return }
            locationAlertMessage = "\(getTranslation(key: "Latitude")): \(viewModel.latitude)\n\(getTranslation(key: "Longitude")): \(longitude)"
            showLocationAlert = true
            isLocationRequestActive = false
        }
        .onReceive(locationService.$alertMessage) { message in
            guard let message else { return }
            guard isLocationRequestActive else { return }
            locationAlertMessage = getTranslation(key: message)
            showLocationAlert = true
            isLocationRequestActive = false
        }
        .alert(getTranslation(key: "Location"), isPresented: $showLocationAlert) {
            Button(getTranslation(key: "OK"), role: .cancel) {}
        } message: {
            Text(locationAlertMessage)
        }
    }
}
