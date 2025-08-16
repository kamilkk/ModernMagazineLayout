//
//  SectionHeaderView.swift
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

struct SectionHeaderView: View {
    let title: String
    let style: MagazineSection.SectionConfiguration.HeaderStyle
    let onSeeAllTapped: (() -> Void)?
    
    init(
        title: String,
        style: MagazineSection.SectionConfiguration.HeaderStyle = .medium,
        onSeeAllTapped: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.onSeeAllTapped = onSeeAllTapped
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(title)
                .font(font)
                .foregroundColor(DSColors.textPrimary)
                .fontWeight(.bold)
            
            Spacer()
            
            if let onSeeAllTapped = onSeeAllTapped {
                Button(action: onSeeAllTapped) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(DSTypography.subheadline)
                            .foregroundColor(DSColors.accent)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(DSColors.accent)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var font: Font {
        switch style {
        case .large:
            return DSTypography.title1
        case .medium:
            return DSTypography.title2
        case .small:
            return DSTypography.title3
        }
    }
}

struct SectionFooterView: View {
    let onLoadMoreTapped: (() -> Void)?
    
    var body: some View {
        if let onLoadMoreTapped = onLoadMoreTapped {
            Button(action: onLoadMoreTapped) {
                HStack {
                    Spacer()
                    Text("Load More")
                        .font(DSTypography.buttonMedium)
                        .foregroundColor(DSColors.accent)
                    Spacer()
                }
                .padding(.vertical, 12)
                .background(DSColors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}