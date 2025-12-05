//
//  DSColors.swift
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

enum DSColors {
  static let primary = Color.blue
  static let secondary = Color.gray
  static let accent = Color.blue

  static let backgroundPrimary = Color(.systemBackground)
  static let backgroundSecondary = Color(.secondarySystemBackground)
  static let backgroundTertiary = Color(.tertiarySystemBackground)

  static let textPrimary = Color(.label)
  static let textSecondary = Color(.secondaryLabel)
  static let textTertiary = Color(.tertiaryLabel)

  static let success = Color.green
  static let warning = Color.orange
  static let error = Color.red
  static let info = Color.blue

  static let cardBackground = Color(.systemBackground)
  static let cardBorder = Color(.separator)
  static let cardShadow = Color.black.opacity(0.1)

  static let gradient = LinearGradient(
    colors: [primary, accent],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let categoryGradients = [
    "tech": LinearGradient(
      colors: [Color.blue, Color.cyan],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    "lifestyle": LinearGradient(
      colors: [Color.pink, Color.orange],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    "business": LinearGradient(
      colors: [Color.green, Color.mint],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
    "sports": LinearGradient(
      colors: [Color.red, Color.orange],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    ),
  ]
}
