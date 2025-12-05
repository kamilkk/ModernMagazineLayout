//
//  MagazineEnvironmentKeys.swift
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

// MARK: - Selection Environment Key

/// Environment key for magazine selection state
@available(iOS 18.0, macOS 15.0, *)
private struct MagazineSelectionKey<ItemID: Hashable & Sendable>: EnvironmentKey {
  static var defaultValue: MagazineSelection<ItemID>? { nil }
}

@available(iOS 18.0, macOS 15.0, *)
public extension EnvironmentValues {
  /// The selection manager for magazine items
  ///
  /// Use this environment value to access the selection state within magazine items:
  /// ```swift
  /// @Environment(\.magazineSelection) var selection
  /// ```
  var magazineSelection: MagazineSelection<UUID>? {
    get { self[MagazineSelectionKey<UUID>.self] }
    set { self[MagazineSelectionKey<UUID>.self] = newValue }
  }
}

// MARK: - Layout Cache Environment Key

/// Environment key for magazine layout cache
@available(iOS 18.0, macOS 15.0, *)
private struct MagazineLayoutCacheKey: EnvironmentKey {
  static var defaultValue: MagazineLayoutCache? { nil }
}

@available(iOS 18.0, macOS 15.0, *)
public extension EnvironmentValues {
  /// The layout cache for magazine performance optimization
  ///
  /// Use this environment value to access the layout cache:
  /// ```swift
  /// @Environment(\.magazineLayoutCache) var cache
  /// ```
  var magazineLayoutCache: MagazineLayoutCache? {
    get { self[MagazineLayoutCacheKey.self] }
    set { self[MagazineLayoutCacheKey.self] = newValue }
  }
}
