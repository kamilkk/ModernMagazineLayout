//
//  MagazineView.swift
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
public struct MagazineView<Content: View>: View {
  private let configuration: ModernMagazineLayout.Configuration
  private let selection: MagazineSelection<UUID>?
  private let layoutCache: MagazineLayoutCache?
  private let dragDropConfiguration: MagazineDragDropConfiguration?
  private let dragState: MagazineDragState?
  private let content: Content

  public init(
    configuration: ModernMagazineLayout.Configuration = ModernMagazineLayout.Configuration(),
    selection: MagazineSelection<UUID>? = nil,
    layoutCache: MagazineLayoutCache? = nil,
    dragDropConfiguration: MagazineDragDropConfiguration? = nil,
    dragState: MagazineDragState? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.configuration = configuration
    self.selection = selection
    self.layoutCache = layoutCache
    self.dragDropConfiguration = dragDropConfiguration
    self.dragState = dragState
    self.content = content()
  }

  public var body: some View {
    ScrollView {
      ModernMagazineLayout(configuration: configuration) {
        content
      }
    }
    .environment(\.magazineSelection, selection)
    .environment(\.magazineLayoutCache, layoutCache)
    .environment(\.magazineDragDropConfiguration, dragDropConfiguration)
    .environment(\.magazineDragState, dragState)
  }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MagazineItem<Content: View>: View {
  private let widthMode: MagazineWidthMode
  private let section: Int?
  private let itemId: UUID?
  private let index: Int?
  private let accessibilityLabel: String?
  private let totalItemsInSection: Int?
  private let content: Content

  @Environment(\.magazineSelection) private var selection
  @Environment(\.magazineDragDropConfiguration) private var dragDropConfig
  @Environment(\.magazineDragState) private var dragState

  public init(
    widthMode: MagazineWidthMode = .fullWidth,
    section: Int? = nil,
    itemId: UUID? = nil,
    index: Int? = nil,
    accessibilityLabel: String? = nil,
    totalItemsInSection: Int? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.widthMode = widthMode
    self.section = section
    self.itemId = itemId
    self.index = index
    self.accessibilityLabel = accessibilityLabel
    self.totalItemsInSection = totalItemsInSection
    self.content = content()
  }

  public var body: some View {
    content
      .magazineWidthMode(widthMode)
      .if(section != nil) { view in
        view.magazineSection(section!)
      }
      .overlay(alignment: .topTrailing) {
        if let itemId, let selection, selection.isSelectionMode {
          SelectionIndicator(isSelected: selection.isSelected(itemId))
        }
      }
      .contentShape(Rectangle())
      .onTapGesture {
        handleTap()
      }
      .if(shouldEnableDragging) { view in
        view.draggable(draggableItem)
      }
      .if(shouldEnableDropping) { view in
        view.onDrop(
          of: dragDropConfig?.acceptedTypes ?? [],
          isTargeted: nil
        ) { providers, _ in
          handleDrop(providers: providers)
        }
      }
      .if(shouldApplyAccessibility) { view in
        view.magazineAccessibility(accessibilityConfiguration)
      }
  }

  private var shouldApplyAccessibility: Bool {
    accessibilityLabel != nil || selection?.isSelectionMode == true || shouldEnableDragging
  }

  private var accessibilityConfiguration: MagazineAccessibility.ItemConfiguration {
    let position: MagazineAccessibility.ItemConfiguration.ItemPosition?
    if let index, let total = totalItemsInSection {
      position = .init(index: index, total: total, section: section)
    } else {
      position = nil
    }

    let selectionState: MagazineAccessibility.ItemConfiguration.SelectionState?
    if let selection, let itemId {
      selectionState = .init(
        isSelected: selection.isSelected(itemId),
        isSelectionMode: selection.isSelectionMode,
        selectedCount: selection.selectedItems.count
      )
    } else {
      selectionState = nil
    }

    let dragDropState: MagazineAccessibility.ItemConfiguration.DragDropState?
    if shouldEnableDragging || shouldEnableDropping {
      let isDragging = dragState?.draggingItemId == itemId
      dragDropState = .init(
        isDraggable: shouldEnableDragging,
        isDropTarget: shouldEnableDropping,
        isDragging: isDragging
      )
    } else {
      dragDropState = nil
    }

    return MagazineAccessibility.ItemConfiguration(
      label: accessibilityLabel ?? "Magazine item",
      position: position,
      selectionState: selectionState,
      dragDropState: dragDropState
    )
  }

  private var shouldEnableDragging: Bool {
    guard let dragDropConfig, itemId != nil else { return false }
    return dragDropConfig.allowsExport
  }

  private var shouldEnableDropping: Bool {
    guard let dragDropConfig else { return false }
    return dragDropConfig.allowsReordering || dragDropConfig.allowsImport
  }

  private var draggableItem: String {
    guard let itemId else { return "" }
    return itemId.uuidString
  }

  private func handleTap() {
    guard let itemId, let selection, selection.isSelectionMode else { return }
    selection.toggle(itemId)
  }

  private func handleDragStart() {
    guard let itemId, let section, let index, let dragState else { return }
    dragState.startDragging(itemId, section: section, index: index)
    dragDropConfig?.onDragStarted?(itemId)
  }

  private func handleDrop(providers: [NSItemProvider]) -> Bool {
    guard let dragDropConfig else { return false }

    // Handle import from external sources
    if dragDropConfig.allowsImport && !providers.isEmpty {
      dragDropConfig.onImport?(providers)
      return true
    }

    // Handle internal reordering
    if dragDropConfig.allowsReordering,
       let toSection = section,
       let toIndex = index,
       let dragState,
       let result = dragState.endDragging(success: true) {
      if result.movedBetweenSections {
        if dragDropConfig.allowsCrossSectionMovement {
          dragDropConfig.onMoveBetweenSections?(result.itemId, result.fromSection, toSection)
          return true
        }
        return false
      } else {
        dragDropConfig.onReorder?(result.itemId, result.fromIndex, toIndex)
        return true
      }
    }

    return false
  }
}

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
