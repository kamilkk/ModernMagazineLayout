//
//  MagazineSelection.swift
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

import Observation
import SwiftUI

/// Thread-safe selection state manager for magazine layout items
///
/// `MagazineSelection` manages the selection state of items in a magazine layout,
/// supporting both single and multiple selection modes with optional selection limits.
///
/// Example usage:
/// ```swift
/// @State private var selection = MagazineSelection<UUID>()
///
/// MagazineView(selection: selection) {
///     ForEach(items) { item in
///         MagazineItem(itemId: item.id) {
///             ItemCard(item: item)
///         }
///     }
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
@Observable
@MainActor
public final class MagazineSelection<ItemID: Hashable & Sendable>: Sendable {
  /// Currently selected item IDs
  public private(set) var selectedItems: Set<ItemID> = []

  /// Whether selection mode is active
  ///
  /// When `true`, tapping items will toggle their selection state.
  /// When `false`, items behave normally without selection UI.
  public var isSelectionMode: Bool = false

  /// Maximum number of items that can be selected
  ///
  /// If `nil`, there is no limit on the number of selected items.
  /// If set, attempting to select more items will fail.
  public var selectionLimit: Int?

  /// Selection policy determining how selection behaves
  public var selectionPolicy: SelectionPolicy = .multiple

  /// Policy for how items can be selected
  public enum SelectionPolicy: Sendable {
    /// Only one item can be selected at a time
    case single
    /// Multiple items can be selected (subject to `selectionLimit`)
    case multiple
  }

  /// Creates a new selection manager
  /// - Parameters:
  ///   - selectionPolicy: The selection policy to use (default: `.multiple`)
  ///   - selectionLimit: Maximum number of items that can be selected (default: `nil`)
  public init(selectionPolicy: SelectionPolicy = .multiple, selectionLimit: Int? = nil) {
    self.selectionPolicy = selectionPolicy
    self.selectionLimit = selectionLimit
  }

  /// Toggle selection state of an item
  ///
  /// If the item is currently selected, it will be deselected.
  /// If the item is not selected, it will be selected (if allowed by policy and limit).
  ///
  /// - Parameter itemId: The ID of the item to toggle
  /// - Returns: `true` if the item is now selected, `false` if deselected or selection failed
  @discardableResult
  public func toggle(_ itemId: ItemID) -> Bool {
    if selectedItems.contains(itemId) {
      selectedItems.remove(itemId)
      return false
    } else {
      return select(itemId)
    }
  }

  /// Select an item
  ///
  /// Attempts to select the specified item according to the current policy and limit.
  ///
  /// - Parameter itemId: The ID of the item to select
  /// - Returns: `true` if the item was successfully selected, `false` if selection failed
  @discardableResult
  public func select(_ itemId: ItemID) -> Bool {
    switch selectionPolicy {
    case .single:
      selectedItems = [itemId]
      return true
    case .multiple:
      if let limit = selectionLimit, selectedItems.count >= limit {
        return false
      }
      selectedItems.insert(itemId)
      return true
    }
  }

  /// Deselect an item
  /// - Parameter itemId: The ID of the item to deselect
  public func deselect(_ itemId: ItemID) {
    selectedItems.remove(itemId)
  }

  /// Select multiple items
  ///
  /// Behavior depends on the current policy:
  /// - `.single`: Only the first item will be selected
  /// - `.multiple`: All items will be selected (up to `selectionLimit`)
  ///
  /// - Parameter itemIds: Array of item IDs to select
  public func selectAll(_ itemIds: [ItemID]) {
    if selectionPolicy == .single, let first = itemIds.first {
      selectedItems = [first]
    } else if let limit = selectionLimit {
      selectedItems = Set(itemIds.prefix(limit))
    } else {
      selectedItems = Set(itemIds)
    }
  }

  /// Clear all selections
  public func deselectAll() {
    selectedItems.removeAll()
  }

  /// Check if an item is selected
  /// - Parameter itemId: The ID of the item to check
  /// - Returns: `true` if the item is currently selected
  public func isSelected(_ itemId: ItemID) -> Bool {
    selectedItems.contains(itemId)
  }

  /// Exit selection mode and clear all selections
  ///
  /// This is a convenience method that both disables selection mode
  /// and clears the current selection.
  public func exitSelectionMode() {
    isSelectionMode = false
    deselectAll()
  }
}
