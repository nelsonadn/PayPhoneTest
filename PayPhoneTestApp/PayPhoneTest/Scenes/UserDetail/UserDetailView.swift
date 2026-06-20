//
//  UserDetailView.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    var body: some View {
        Text(getTranslation(key: "User Detail"))
            .navigationTitle(getTranslation(key: "User Detail"))
    }
}
