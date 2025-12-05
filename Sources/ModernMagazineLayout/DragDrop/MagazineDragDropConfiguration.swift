//
//  MagazineDragDropConfiguration.swift
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

import Foundation
import SwiftUI
import UniformTypeIdentifiers

/// Configuration for drag and drop behavior in magazine layouts
///
/// `MagazineDragDropConfiguration` controls how items can be dragged, dropped,
/// and reordered within magazine views. It provides callbacks for handling
/// reordering, cross-section movements, and data imports.
///
/// Example:
/// ```swift
/// let dragDropConfig = MagazineDragDropConfiguration(
///     allowsReordering: true,
///     allowsCrossSectionMovement: false,
///     onReorder: { itemId, fromIndex, toIndex in
///         // Handle reordering
///         dataService.moveItem(itemId, from: fromIndex, to: toIndex)
///     }
/// )
/// ```
@available(iOS 18.0, macOS 15.0, *)
public struct MagazineDragDropConfiguration: Sendable {
  /// Whether items can be reordered within the same section
  public var allowsReordering: Bool

  /// Whether items can be imported from external sources
  public var allowsImport: Bool

  /// Whether items can be exported to external destinations
  public var allowsExport: Bool

  /// Whether items can be moved between different sections
  public var allowsCrossSectionMovement: Bool

  /// The visual style for drag previews
  public var dragPreviewStyle: DragPreviewStyle

  /// Accepted UTTypes for import operations
  public var acceptedTypes: [UTType]

  /// Callback when an item is reordered within a section
  ///
  /// Parameters:
  /// - itemId: The ID of the item being moved
  /// - fromIndex: The original index position
  /// - toIndex: The new index position
  public var onReorder: (@Sendable (UUID, Int, Int) -> Void)?

  /// Callback when an item is moved between sections
  ///
  /// Parameters:
  /// - itemId: The ID of the item being moved
  /// - fromSection: The original section index
  /// - toSection: The destination section index
  public var onMoveBetweenSections: (@Sendable (UUID, Int, Int) -> Void)?

  /// Callback when external items are imported
  ///
  /// Parameter: The item providers for the imported items
  public var onImport: (@Sendable ([NSItemProvider]) -> Void)?

  /// Callback when an item starts being dragged
  ///
  /// Parameter: The ID of the item being dragged
  public var onDragStarted: (@Sendable (UUID) -> Void)?

  /// Callback when a drag operation ends
  ///
  /// Parameters:
  /// - itemId: The ID of the item that was dragged
  /// - success: Whether the drop was successful
  public var onDragEnded: (@Sendable (UUID, Bool) -> Void)?

  /// Initialize a drag and drop configuration
  ///
  /// - Parameters:
  ///   - allowsReordering: Whether items can be reordered (default: true)
  ///   - allowsImport: Whether external imports are allowed (default: true)
  ///   - allowsExport: Whether items can be exported (default: true)
  ///   - allowsCrossSectionMovement: Whether cross-section movement is allowed (default: true)
  ///   - dragPreviewStyle: The visual style for drag previews (default: .automatic)
  ///   - acceptedTypes: UTTypes accepted for imports (default: [.item])
  ///   - onReorder: Callback for reorder operations
  ///   - onMoveBetweenSections: Callback for cross-section moves
  ///   - onImport: Callback for import operations
  ///   - onDragStarted: Callback when drag starts
  ///   - onDragEnded: Callback when drag ends
  public init(
    allowsReordering: Bool = true,
    allowsImport: Bool = true,
    allowsExport: Bool = true,
    allowsCrossSectionMovement: Bool = true,
    dragPreviewStyle: DragPreviewStyle = .automatic,
    acceptedTypes: [UTType] = [.item],
    onReorder: (@Sendable (UUID, Int, Int) -> Void)? = nil,
    onMoveBetweenSections: (@Sendable (UUID, Int, Int) -> Void)? = nil,
    onImport: (@Sendable ([NSItemProvider]) -> Void)? = nil,
    onDragStarted: (@Sendable (UUID) -> Void)? = nil,
    onDragEnded: (@Sendable (UUID, Bool) -> Void)? = nil
  ) {
    self.allowsReordering = allowsReordering
    self.allowsImport = allowsImport
    self.allowsExport = allowsExport
    self.allowsCrossSectionMovement = allowsCrossSectionMovement
    self.dragPreviewStyle = dragPreviewStyle
    self.acceptedTypes = acceptedTypes
    self.onReorder = onReorder
    self.onMoveBetweenSections = onMoveBetweenSections
    self.onImport = onImport
    self.onDragStarted = onDragStarted
    self.onDragEnded = onDragEnded
  }

  /// Visual style for drag previews
  public enum DragPreviewStyle: Sendable {
    /// Use the system default preview style
    case automatic

    /// Use a custom shadow and scale effect
    case shadow(radius: CGFloat, opacity: Double)

    /// Use a custom border effect
    case border(color: String, width: CGFloat)

    /// No visual effect (just the content)
    case none
  }
}

// MARK: - Environment Key

/// Environment key for magazine drag-drop configuration
@available(iOS 18.0, macOS 15.0, *)
private struct MagazineDragDropConfigurationKey: EnvironmentKey {
  static var defaultValue: MagazineDragDropConfiguration? { nil }
}

@available(iOS 18.0, macOS 15.0, *)
public extension EnvironmentValues {
  /// The drag-drop configuration for magazine items
  ///
  /// Use this environment value to access the drag-drop configuration within magazine items:
  /// ```swift
  /// @Environment(\.magazineDragDropConfiguration) var dragDropConfig
  /// ```
  var magazineDragDropConfiguration: MagazineDragDropConfiguration? {
    get { self[MagazineDragDropConfigurationKey.self] }
    set { self[MagazineDragDropConfigurationKey.self] = newValue }
  }
}
