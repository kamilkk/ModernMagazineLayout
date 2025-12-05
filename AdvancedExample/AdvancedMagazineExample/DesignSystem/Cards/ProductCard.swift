//
//  ProductCard.swift
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

struct ProductCard: View {
  let product: Product

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      AsyncImageView(url: product.imageURL)
        .frame(height: 120)
        .clipped()
        .overlay(
          VStack {
            HStack {
              Spacer()
              if product.isOnSale {
                SaleBadge(discount: product.discountPercentage)
              }
            }
            .padding(8)
            Spacer()
          }
        )

      VStack(alignment: .leading, spacing: 6) {
        Text(product.name)
          .font(DSTypography.callout)
          .foregroundColor(DSColors.textPrimary)
          .lineLimit(2)
          .multilineTextAlignment(.leading)

        if let brand = product.brand {
          Text(brand)
            .font(DSTypography.caption1)
            .foregroundColor(DSColors.textSecondary)
            .lineLimit(1)
        }

        HStack {
          if product.isOnSale, let originalPrice = product.originalPrice {
            Text("$\(originalPrice, specifier: "%.2f")")
              .font(DSTypography.caption1)
              .foregroundColor(DSColors.textTertiary)
              .strikethrough()
          }

          Text("$\(product.price, specifier: "%.2f")")
            .font(DSTypography.callout)
            .foregroundColor(product.isOnSale ? DSColors.error : DSColors.textPrimary)
            .fontWeight(.semibold)

          Spacer()
        }

        HStack {
          RatingView(rating: product.rating, reviewCount: product.reviewCount)
          Spacer()
        }
      }
      .padding(.horizontal, 8)
      .padding(.vertical, 6)
    }
    .background(DSColors.cardBackground)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(
      color: DSColors.cardShadow.opacity(0.08),
      radius: 3,
      x: 0,
      y: 1
    )
    .onTapGesture {
      // Handle product tap
    }
  }
}

struct SaleBadge: View {
  let discount: Int?

  var body: some View {
    if let discount = discount {
      Text("-\(discount)%")
        .font(DSTypography.caption2)
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(DSColors.error)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
  }
}

struct RatingView: View {
  let rating: Double
  let reviewCount: Int

  var body: some View {
    HStack(spacing: 2) {
      HStack(spacing: 1) {
        ForEach(0 ..< 5, id: \.self) { index in
          Image(systemName: index < Int(rating) ? "star.fill" : "star")
            .font(.caption2)
            .foregroundColor(.yellow)
        }
      }

      Text("(\(reviewCount))")
        .font(DSTypography.caption2)
        .foregroundColor(DSColors.textTertiary)
    }
  }
}
