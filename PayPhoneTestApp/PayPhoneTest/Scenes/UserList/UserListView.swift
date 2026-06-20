//
//  UserListView.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import SwiftUI

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel(
        networkService: NetworkService(),
        storageService: StorageService()
    )

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.users.isEmpty {
                ProgressView()
            } else if viewModel.users.isEmpty {
                Text(getTranslation(key: "No users"))
                    .appDetailStyle()
            } else {
                List(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(user.username)
                                .appTitleStyle()
                                .lineLimit(1)
                                .truncationMode(.tail)

                            Text(user.name)
                                .appSubtitleStyle()
                                .lineLimit(1)
                                .truncationMode(.tail)

                            VStack(alignment: .leading, spacing: 4) {
                                infoRow(systemImage: "phone.fill", text: user.phone)
                                infoRow(systemImage: "envelope.fill", text: user.email)
                                infoRow(systemImage: "mappin.and.ellipse", text: user.address.city)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: UserCreateView()) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(getTranslation(key: "Add User"))
            }
        }
        .navigationTitle(getTranslation(key: "User List"))
        .task {
            await viewModel.loadUsers()
        }
    }

    private func infoRow(systemImage: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.caption)
                .foregroundStyle(AppTheme.Colors.accent)
            Text(text)
                .appDetailStyle()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .truncationMode(.tail)
        }
    }
}
