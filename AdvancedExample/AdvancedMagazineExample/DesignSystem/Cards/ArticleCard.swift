//
//  ArticleCard.swift
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

struct ArticleCard: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImageView(url: article.imageURL)
                .aspectRatio(16/9, contentMode: .fill)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.3)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            if let category = article.category {
                                CategoryTag(category: category)
                            }
                            Spacer()
                            if article.isPremium {
                                PremiumBadge()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 8)
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(DSTypography.headline)
                    .foregroundColor(DSColors.textPrimary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(article.subtitle)
                    .font(DSTypography.caption1)
                    .foregroundColor(DSColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(article.author)
                        .font(DSTypography.caption2)
                        .foregroundColor(DSColors.textTertiary)
                    
                    Spacer()
                    
                    Text(article.publishDate, style: .relative)
                        .font(DSTypography.caption2)
                        .foregroundColor(DSColors.textTertiary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(DSColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: DSColors.cardShadow.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
        .onTapGesture {
            // Handle article tap
        }
    }
}

struct CategoryTag: View {
    let category: String
    
    var body: some View {
        Text(category.uppercased())
            .font(DSTypography.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                DSColors.categoryGradients[category.lowercased()] ??
                DSColors.gradient
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct PremiumBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.caption2)
            Text("PREMIUM")
                .font(DSTypography.caption2)
        }
        .foregroundColor(.yellow)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.black.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct AsyncImageView: View {
    let url: URL?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(DSColors.backgroundSecondary)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(DSColors.textTertiary)
                            .font(.title2)
                    )
            }
        } else {
            Rectangle()
                .fill(DSColors.backgroundSecondary)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(DSColors.textTertiary)
                        .font(.title2)
                )
        }
    }
}