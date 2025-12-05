//
//  MagazineDragState.swift
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

/// Manages the state of drag and drop operations
///
/// `MagazineDragState` tracks the current drag operation, including which item
/// is being dragged, potential drop targets, and operation outcomes.
///
/// Example:
/// ```swift
/// @State private var dragState = MagazineDragState()
///
/// var body: some View {
///     MagazineView(dragState: dragState) {
///         // content
///     }
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
@Observable
@MainActor
public final class MagazineDragState: Sendable {
  /// The ID of the item currently being dragged
  public private(set) var draggingItemId: UUID?

  /// The section of the item being dragged
  public private(set) var draggingFromSection: Int?

  /// The index of the item being dragged within its section
  public private(set) var draggingFromIndex: Int?

  /// The potential drop target section
  public private(set) var dropTargetSection: Int?

  /// The potential drop target index
  public private(set) var dropTargetIndex: Int?

  /// Whether a drag operation is currently active
  public var isDragging: Bool {
    draggingItemId != nil
  }

  /// Whether there is a valid drop target
  public var hasDropTarget: Bool {
    dropTargetSection != nil && dropTargetIndex != nil
  }

  /// Initialize a new drag state
  public init() {}

  // MARK: - Drag Operations

  /// Start dragging an item
  ///
  /// - Parameters:
  ///   - itemId: The ID of the item being dragged
  ///   - section: The section index of the item
  ///   - index: The index of the item within the section
  public func startDragging(_ itemId: UUID, section: Int, index: Int) {
    draggingItemId = itemId
    draggingFromSection = section
    draggingFromIndex = index
  }

  /// Update the drop target position
  ///
  /// - Parameters:
  ///   - section: The target section index
  ///   - index: The target index within the section
  public func updateDropTarget(section: Int, index: Int) {
    dropTargetSection = section
    dropTargetIndex = index
  }

  /// Clear the drop target
  public func clearDropTarget() {
    dropTargetSection = nil
    dropTargetIndex = nil
  }

  /// End the drag operation
  ///
  /// - Parameter success: Whether the drop was successful
  /// - Returns: A tuple containing the drag source and drop target info, or nil if unsuccessful
  public func endDragging(success: Bool) -> DragDropResult? {
    defer {
      draggingItemId = nil
      draggingFromSection = nil
      draggingFromIndex = nil
      dropTargetSection = nil
      dropTargetIndex = nil
    }

    guard success,
          let itemId = draggingItemId,
          let fromSection = draggingFromSection,
          let fromIndex = draggingFromIndex,
          let toSection = dropTargetSection,
          let toIndex = dropTargetIndex else {
      return nil
    }

    return DragDropResult(
      itemId: itemId,
      fromSection: fromSection,
      fromIndex: fromIndex,
      toSection: toSection,
      toIndex: toIndex
    )
  }

  /// Check if a drop at the given location would result in a valid move
  ///
  /// - Parameters:
  ///   - section: The target section
  ///   - index: The target index
  /// - Returns: True if the move would actually change the item's position
  public func isValidMove(toSection section: Int, toIndex index: Int) -> Bool {
    guard let fromSection = draggingFromSection,
          let fromIndex = draggingFromIndex else {
      return false
    }

    // Check if the target is different from the source
    if fromSection != section {
      return true
    }

    // Same section - check if index is different
    return fromIndex != index
  }

  /// Result of a completed drag and drop operation
  public struct DragDropResult: Sendable {
    /// The ID of the item that was moved
    public let itemId: UUID

    /// The original section index
    public let fromSection: Int

    /// The original index within the section
    public let fromIndex: Int

    /// The destination section index
    public let toSection: Int

    /// The destination index within the section
    public let toIndex: Int

    /// Whether the item moved to a different section
    public var movedBetweenSections: Bool {
      fromSection != toSection
    }
  }
}

// MARK: - Environment Key

/// Environment key for magazine drag state
@available(iOS 18.0, macOS 15.0, *)
private struct MagazineDragStateKey: EnvironmentKey {
  static var defaultValue: MagazineDragState? { nil }
}

@available(iOS 18.0, macOS 15.0, *)
public extension EnvironmentValues {
  /// The drag state for magazine items
  ///
  /// Use this environment value to access the drag state within magazine items:
  /// ```swift
  /// @Environment(\.magazineDragState) var dragState
  /// ```
  var magazineDragState: MagazineDragState? {
    get { self[MagazineDragStateKey.self] }
    set { self[MagazineDragStateKey.self] = newValue }
  }
}
