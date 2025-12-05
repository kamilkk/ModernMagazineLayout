//
//  MagazineAccessibilityModifiers.swift
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

/// Accessibility modifiers and helpers for magazine layouts
///
/// Provides VoiceOver support, accessibility labels, hints, and traits
/// for magazine items, selection states, and drag-drop operations.
@available(iOS 18.0, macOS 15.0, *)
public struct MagazineAccessibility {
  /// Configuration for magazine item accessibility
  public struct ItemConfiguration: Sendable {
    /// The base label for the item
    public let label: String

    /// The item's position in the section
    public let position: ItemPosition?

    /// Selection state information
    public let selectionState: SelectionState?

    /// Drag-drop state information
    public let dragDropState: DragDropState?

    /// Custom hint text
    public let customHint: String?

    /// Additional traits to apply
    public let additionalTraits: AccessibilityTraits

    public init(
      label: String,
      position: ItemPosition? = nil,
      selectionState: SelectionState? = nil,
      dragDropState: DragDropState? = nil,
      customHint: String? = nil,
      additionalTraits: AccessibilityTraits = []
    ) {
      self.label = label
      self.position = position
      self.selectionState = selectionState
      self.dragDropState = dragDropState
      self.customHint = customHint
      self.additionalTraits = additionalTraits
    }

    /// Position information for an item
    public struct ItemPosition: Sendable {
      public let index: Int
      public let total: Int
      public let section: Int?

      public init(index: Int, total: Int, section: Int? = nil) {
        self.index = index
        self.total = total
        self.section = section
      }
    }

    /// Selection state for an item
    public struct SelectionState: Sendable {
      public let isSelected: Bool
      public let isSelectionMode: Bool
      public let selectedCount: Int

      public init(isSelected: Bool, isSelectionMode: Bool, selectedCount: Int = 0) {
        self.isSelected = isSelected
        self.isSelectionMode = isSelectionMode
        self.selectedCount = selectedCount
      }
    }

    /// Drag-drop state for an item
    public struct DragDropState: Sendable {
      public let isDraggable: Bool
      public let isDropTarget: Bool
      public let isDragging: Bool

      public init(isDraggable: Bool, isDropTarget: Bool, isDragging: Bool = false) {
        self.isDraggable = isDraggable
        self.isDropTarget = isDropTarget
        self.isDragging = isDragging
      }
    }
  }

  /// Generate accessibility label for a magazine item
  public static func itemLabel(for config: ItemConfiguration) -> String {
    var components: [String] = [config.label]

    // Add position information
    if let position = config.position {
      if let section = position.section {
        components.append("Section \(section + 1)")
      }
      components.append("Item \(position.index + 1) of \(position.total)")
    }

    // Add selection state
    if let selection = config.selectionState, selection.isSelectionMode {
      if selection.isSelected {
        components.append("Selected")
      } else {
        components.append("Not selected")
      }
    }

    return components.joined(separator: ", ")
  }

  /// Generate accessibility hint for a magazine item
  public static func itemHint(for config: ItemConfiguration) -> String? {
    if let customHint = config.customHint {
      return customHint
    }

    var hints: [String] = []

    // Selection hints
    if let selection = config.selectionState, selection.isSelectionMode {
      if selection.isSelected {
        hints.append("Double tap to deselect")
        if selection.selectedCount > 0 {
          hints.append("\(selection.selectedCount) items selected")
        }
      } else {
        hints.append("Double tap to select")
      }
    }

    // Drag-drop hints
    if let dragDrop = config.dragDropState {
      if dragDrop.isDraggable {
        hints.append("Draggable")
      }
      if dragDrop.isDropTarget {
        hints.append("Drop target")
      }
      if dragDrop.isDragging {
        hints.append("Currently being dragged")
      }
    }

    return hints.isEmpty ? nil : hints.joined(separator: ". ")
  }

  /// Generate accessibility traits for a magazine item
  public static func itemTraits(for config: ItemConfiguration) -> AccessibilityTraits {
    var traits = config.additionalTraits

    // Add button trait if selectable
    if let selection = config.selectionState, selection.isSelectionMode {
      traits.formUnion(.isButton)
      if selection.isSelected {
        traits.formUnion(.isSelected)
      }
    }

    return traits
  }

  /// Generate accessibility value for a magazine item
  public static func itemValue(for config: ItemConfiguration) -> String? {
    if let selection = config.selectionState, selection.isSelectionMode {
      return selection.isSelected ? "Selected" : "Not selected"
    }
    return nil
  }
}

// MARK: - View Extensions

@available(iOS 18.0, macOS 15.0, *)
public extension View {
  /// Apply magazine accessibility configuration to a view
  ///
  /// This modifier sets up comprehensive accessibility support including
  /// VoiceOver labels, hints, traits, and values for magazine items.
  ///
  /// Example:
  /// ```swift
  /// ItemCard(item: item)
  ///     .magazineAccessibility(
  ///         MagazineAccessibility.ItemConfiguration(
  ///             label: item.title,
  ///             position: .init(index: index, total: totalItems, section: sectionIndex),
  ///             selectionState: .init(
  ///                 isSelected: selection.isSelected(item.id),
  ///                 isSelectionMode: selection.isSelectionMode
  ///             )
  ///         )
  ///     )
  /// ```
  func magazineAccessibility(_ config: MagazineAccessibility.ItemConfiguration) -> some View {
    accessibilityLabel(MagazineAccessibility.itemLabel(for: config))
      .accessibilityHint(MagazineAccessibility.itemHint(for: config) ?? "")
      .accessibilityAddTraits(MagazineAccessibility.itemTraits(for: config))
      .if(MagazineAccessibility.itemValue(for: config) != nil) { view in
        view.accessibilityValue(MagazineAccessibility.itemValue(for: config)!)
      }
  }

  /// Mark a view as a magazine section header
  func magazineSectionHeader(_ title: String, index: Int) -> some View {
    accessibilityAddTraits(.isHeader)
      .accessibilityLabel("Section \(index + 1): \(title)")
  }

  /// Mark a view as the magazine container
  func magazineContainer(itemCount: Int, sectionCount: Int? = nil) -> some View {
    var label = "\(itemCount) items"
    if let sectionCount = sectionCount {
      label = "\(sectionCount) sections, \(itemCount) items"
    }

    return accessibilityElement(children: .contain)
      .accessibilityLabel("Magazine layout")
      .accessibilityHint(label)
  }
}

// MARK: - Private Helper

@available(iOS 18.0, macOS 15.0, *)
private extension View {
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
