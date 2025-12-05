//
//  MagazineLayoutKeys.swift
//  ModernMagazineLayout
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

@available(iOS 18.0, macOS 15.0, *)
public enum MagazineWidthMode: Equatable, Sendable {
  case fullWidth
  case halfWidth
  case thirdWidth
  case quarterWidth
  case twoThirds
  case fractional(CGFloat)

  /// Create a width mode for a specific number of columns
  /// - Parameter count: Number of columns (1 = full width, 2 = half width, etc.)
  /// - Returns: The appropriate MagazineWidthMode
  public static func columns(_ count: Int) -> MagazineWidthMode {
    switch count {
    case 1: return .fullWidth
    case 2: return .halfWidth
    case 3: return .thirdWidth
    case 4: return .quarterWidth
    default: return .fractional(1.0 / CGFloat(count))
    }
  }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MagazineWidthModeKey: LayoutValueKey {
  public static let defaultValue: MagazineWidthMode? = nil
}

@available(iOS 18.0, macOS 15.0, *)
public struct MagazineSectionKey: LayoutValueKey {
  public static let defaultValue: Int? = nil
}

@available(iOS 18.0, macOS 15.0, *)
public extension View {
  func magazineWidthMode(_ mode: MagazineWidthMode) -> some View {
    layoutValue(key: MagazineWidthModeKey.self, value: mode)
  }

  func magazineSection(_ section: Int) -> some View {
    layoutValue(key: MagazineSectionKey.self, value: section)
  }
}
