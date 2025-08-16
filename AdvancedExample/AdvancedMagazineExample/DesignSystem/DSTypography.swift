//
//  DSTypography.swift
//  AdvancedMagazineExample
//
//  Created by Kamil Kowalski on 16/08/2025.
//  Copyright © 2025 Kamil Kowalski. All rights reserved.
//
//  This file is part of ModernMagazineLayout.
//
//  ModernMagazineLayout is free software: you can redistribute it and/or modify
//  it under the terms of the MIT License as published in the LICENSE file.
//
//  ModernMagazineLayout is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  MIT License for more details.
//

import SwiftUI

struct DSTypography {
    
    static let largeTitle = Font.custom("", size: 34, relativeTo: .largeTitle).weight(.bold)
    static let title1 = Font.custom("", size: 28, relativeTo: .title).weight(.bold)
    static let title2 = Font.custom("", size: 22, relativeTo: .title2).weight(.bold)
    static let title3 = Font.custom("", size: 20, relativeTo: .title3).weight(.semibold)
    
    static let headline = Font.custom("", size: 17, relativeTo: .headline).weight(.semibold)
    static let body = Font.custom("", size: 17, relativeTo: .body).weight(.regular)
    static let callout = Font.custom("", size: 16, relativeTo: .callout).weight(.regular)
    static let subheadline = Font.custom("", size: 15, relativeTo: .subheadline).weight(.regular)
    static let footnote = Font.custom("", size: 13, relativeTo: .footnote).weight(.regular)
    static let caption1 = Font.custom("", size: 12, relativeTo: .caption).weight(.regular)
    static let caption2 = Font.custom("", size: 11, relativeTo: .caption2).weight(.regular)
    
    static let buttonLarge = Font.custom("", size: 17, relativeTo: .body).weight(.semibold)
    static let buttonMedium = Font.custom("", size: 15, relativeTo: .subheadline).weight(.semibold)
    static let buttonSmall = Font.custom("", size: 13, relativeTo: .footnote).weight(.semibold)
}

extension Font {
    init(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) {
        if let customFont = UIFont(name: name, size: size) {
            self = Font(customFont)
        } else {
            self = Font.system(size: size, design: .default).weight(.regular)
        }
    }
}

struct DSTextStyles {
    
    static func articleTitle() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.title2)
                .foregroundColor(DSColors.textPrimary)
                .multilineTextAlignment(.leading)
        )
    }
    
    static func articleSubtitle() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.subheadline)
                .foregroundColor(DSColors.textSecondary)
                .multilineTextAlignment(.leading)
        )
    }
    
    static func sectionHeader() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.title3)
                .foregroundColor(DSColors.textPrimary)
                .multilineTextAlignment(.leading)
        )
    }
    
    static func cardTitle() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.headline)
                .foregroundColor(DSColors.textPrimary)
                .multilineTextAlignment(.leading)
        )
    }
    
    static func cardSubtitle() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.caption1)
                .foregroundColor(DSColors.textSecondary)
                .multilineTextAlignment(.leading)
        )
    }
    
    static func tagText() -> some View {
        return AnyView(
            Text("")
                .font(DSTypography.caption2)
                .foregroundColor(DSColors.textTertiary)
                .multilineTextAlignment(.center)
        )
    }
}