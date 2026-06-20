//
//  AppTheme.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import SwiftUI

enum AppTheme {
    enum Colors {
        static let title = Color.primary
        static let subtitle = Color.secondary
        static let detail = Color.secondary
        static let accent = Color.accentColor
        static let error = Color.red
    }

    enum Fonts {
        static let title = Font.system(size: 18, weight: .bold, design: .default)
        static let subtitle = Font.system(size: 16, weight: .regular, design: .default)
        static let detail = Font.system(size: 14, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
    }
}

extension View {
    func appTitleStyle() -> some View {
        font(AppTheme.Fonts.title)
            .foregroundStyle(AppTheme.Colors.title)
    }

    func appSubtitleStyle() -> some View {
        font(AppTheme.Fonts.subtitle)
            .foregroundStyle(AppTheme.Colors.subtitle)
    }

    func appDetailStyle() -> some View {
        font(AppTheme.Fonts.detail)
            .foregroundStyle(AppTheme.Colors.detail)
    }

    func appCaptionStyle() -> some View {
        font(AppTheme.Fonts.caption)
            .foregroundStyle(AppTheme.Colors.detail)
    }
}
