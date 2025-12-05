//
//  SelectionIndicator.swift
//  ModernMagazineLayout
//
//  Created by Claude on 05/12/2025.
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

/// Visual indicator showing the selection state of a magazine item
///
/// The indicator can be displayed in different styles:
/// - `.checkmark`: A circular checkmark indicator (default)
/// - `.overlay`: A colored overlay over the entire item
/// - `.border`: A border around the item
@available(iOS 18.0, macOS 15.0, *)
struct SelectionIndicator: View {
  /// Whether the item is currently selected
  let isSelected: Bool

  /// Visual style of the selection indicator
  var style: SelectionStyle = .checkmark

  /// Visual styles for selection indicators
  enum SelectionStyle: Sendable {
    /// Circular checkmark in the corner
    case checkmark
    /// Colored overlay over the item
    case overlay
    /// Border around the item
    case border
  }

  var body: some View {
    switch style {
    case .checkmark:
      checkmarkStyle
    case .overlay:
      overlayStyle
    case .border:
      borderStyle
    }
  }

  // MARK: - Style Implementations

  private var checkmarkStyle: some View {
    Circle()
      .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.3))
      .frame(width: 28, height: 28)
      .overlay {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(.white)
          .font(.system(size: 20, weight: .semibold))
          .symbolRenderingMode(.hierarchical)
      }
      .padding(8)
      .transition(.scale.combined(with: .opacity))
  }

  private var overlayStyle: some View {
    Color.accentColor
      .opacity(isSelected ? 0.2 : 0)
      .allowsHitTesting(false)
      .animation(.easeInOut(duration: 0.2), value: isSelected)
  }

  private var borderStyle: some View {
    RoundedRectangle(cornerRadius: 8)
      .strokeBorder(Color.accentColor, lineWidth: isSelected ? 3 : 0)
      .allowsHitTesting(false)
      .animation(.easeInOut(duration: 0.2), value: isSelected)
  }
}

// MARK: - Previews

#if DEBUG
  @available(iOS 18.0, macOS 15.0, *)
  #Preview("Checkmark Style") {
    VStack(spacing: 20) {
      ZStack(alignment: .topTrailing) {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: false, style: .checkmark)
      }

      ZStack(alignment: .topTrailing) {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: true, style: .checkmark)
      }
    }
    .padding()
  }

  @available(iOS 18.0, macOS 15.0, *)
  #Preview("Overlay Style") {
    VStack(spacing: 20) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: false, style: .overlay)
      }

      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: true, style: .overlay)
      }
    }
    .padding()
  }

  @available(iOS 18.0, macOS 15.0, *)
  #Preview("Border Style") {
    VStack(spacing: 20) {
      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: false, style: .border)
      }

      ZStack {
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.blue.opacity(0.2))
          .frame(width: 200, height: 150)

        SelectionIndicator(isSelected: true, style: .border)
      }
    }
    .padding()
  }
#endif
