//
//  AccessibilityTests.swift
//  ModernMagazineLayoutTests
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

@testable import ModernMagazineLayout
import SwiftUI
import XCTest

@available(iOS 18.0, macOS 15.0, *)
final class AccessibilityTests: XCTestCase {
  // MARK: - Label Generation Tests

  func testBasicLabel() {
    let config = MagazineAccessibility.ItemConfiguration(label: "Test Item")
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Test Item")
  }

  func testLabelWithPosition() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      position: .init(index: 2, total: 10)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Test Item, Item 3 of 10")
  }

  func testLabelWithPositionAndSection() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      position: .init(index: 5, total: 20, section: 2)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Test Item, Section 3, Item 6 of 20")
  }

  func testLabelWithSelectedState() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: true)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Test Item, Selected")
  }

  func testLabelWithNotSelectedState() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: false, isSelectionMode: true)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Test Item, Not selected")
  }

  func testLabelWithSelectionNotInSelectionMode() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: false)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    // When not in selection mode, selection state should not appear
    XCTAssertEqual(label, "Test Item")
  }

  func testComplexLabel() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Article Title",
      position: .init(index: 3, total: 15, section: 1),
      selectionState: .init(isSelected: true, isSelectionMode: true)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Article Title, Section 2, Item 4 of 15, Selected")
  }

  // MARK: - Hint Generation Tests

  func testHintForSelection() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: false, isSelectionMode: true)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Double tap to select")
  }

  func testHintForDeselection() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: true, selectedCount: 3)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Double tap to deselect. 3 items selected")
  }

  func testHintForDraggable() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      dragDropState: .init(isDraggable: true, isDropTarget: false)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Draggable")
  }

  func testHintForDropTarget() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      dragDropState: .init(isDraggable: false, isDropTarget: true)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Drop target")
  }

  func testHintForDragging() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      dragDropState: .init(isDraggable: true, isDropTarget: true, isDragging: true)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Draggable. Drop target. Currently being dragged")
  }

  func testCustomHint() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      customHint: "Custom accessibility hint"
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Custom accessibility hint")
  }

  func testHintCombiningSelectionAndDragDrop() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: false, isSelectionMode: true),
      dragDropState: .init(isDraggable: true, isDropTarget: false)
    )
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertEqual(hint, "Double tap to select. Draggable")
  }

  func testNoHintWhenNotNeeded() {
    let config = MagazineAccessibility.ItemConfiguration(label: "Test Item")
    let hint = MagazineAccessibility.itemHint(for: config)

    XCTAssertNil(hint)
  }

  // MARK: - Trait Generation Tests

  func testBasicTraits() {
    let config = MagazineAccessibility.ItemConfiguration(label: "Test Item")
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertTrue(traits.isEmpty)
  }

  func testButtonTraitInSelectionMode() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: false, isSelectionMode: true)
    )
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertTrue(traits.contains(.isButton))
    XCTAssertFalse(traits.contains(.isSelected))
  }

  func testSelectedTrait() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: true)
    )
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertTrue(traits.contains(.isButton))
    XCTAssertTrue(traits.contains(.isSelected))
  }

  func testNoTraitsWhenNotInSelectionMode() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: false)
    )
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertFalse(traits.contains(.isButton))
    XCTAssertFalse(traits.contains(.isSelected))
  }

  func testAdditionalTraits() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      additionalTraits: [.isImage]
    )
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertTrue(traits.contains(.isImage))
  }

  func testCombinedTraits() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: true),
      additionalTraits: [.isImage]
    )
    let traits = MagazineAccessibility.itemTraits(for: config)

    XCTAssertTrue(traits.contains(.isButton))
    XCTAssertTrue(traits.contains(.isSelected))
    XCTAssertTrue(traits.contains(.isImage))
  }

  // MARK: - Value Generation Tests

  func testValueForSelected() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: true, isSelectionMode: true)
    )
    let value = MagazineAccessibility.itemValue(for: config)

    XCTAssertEqual(value, "Selected")
  }

  func testValueForNotSelected() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Test Item",
      selectionState: .init(isSelected: false, isSelectionMode: true)
    )
    let value = MagazineAccessibility.itemValue(for: config)

    XCTAssertEqual(value, "Not selected")
  }

  func testNoValueWhenNotInSelectionMode() {
    let config = MagazineAccessibility.ItemConfiguration(label: "Test Item")
    let value = MagazineAccessibility.itemValue(for: config)

    XCTAssertNil(value)
  }

  // MARK: - Position Tests

  func testPositionWithoutSection() {
    let position = MagazineAccessibility.ItemConfiguration.ItemPosition(
      index: 5,
      total: 20
    )

    XCTAssertEqual(position.index, 5)
    XCTAssertEqual(position.total, 20)
    XCTAssertNil(position.section)
  }

  func testPositionWithSection() {
    let position = MagazineAccessibility.ItemConfiguration.ItemPosition(
      index: 3,
      total: 10,
      section: 2
    )

    XCTAssertEqual(position.index, 3)
    XCTAssertEqual(position.total, 10)
    XCTAssertEqual(position.section, 2)
  }

  // MARK: - Selection State Tests

  func testSelectionStateNotSelected() {
    let state = MagazineAccessibility.ItemConfiguration.SelectionState(
      isSelected: false,
      isSelectionMode: true
    )

    XCTAssertFalse(state.isSelected)
    XCTAssertTrue(state.isSelectionMode)
    XCTAssertEqual(state.selectedCount, 0)
  }

  func testSelectionStateSelected() {
    let state = MagazineAccessibility.ItemConfiguration.SelectionState(
      isSelected: true,
      isSelectionMode: true,
      selectedCount: 5
    )

    XCTAssertTrue(state.isSelected)
    XCTAssertTrue(state.isSelectionMode)
    XCTAssertEqual(state.selectedCount, 5)
  }

  // MARK: - Drag-Drop State Tests

  func testDragDropStateBasic() {
    let state = MagazineAccessibility.ItemConfiguration.DragDropState(
      isDraggable: true,
      isDropTarget: false
    )

    XCTAssertTrue(state.isDraggable)
    XCTAssertFalse(state.isDropTarget)
    XCTAssertFalse(state.isDragging)
  }

  func testDragDropStateDragging() {
    let state = MagazineAccessibility.ItemConfiguration.DragDropState(
      isDraggable: true,
      isDropTarget: true,
      isDragging: true
    )

    XCTAssertTrue(state.isDraggable)
    XCTAssertTrue(state.isDropTarget)
    XCTAssertTrue(state.isDragging)
  }

  // MARK: - Sendable Conformance Tests

  func testConfigurationIsSendable() {
    let config = MagazineAccessibility.ItemConfiguration(label: "Test")

    Task {
      let _ = config
    }
  }

  func testPositionIsSendable() {
    let position = MagazineAccessibility.ItemConfiguration.ItemPosition(
      index: 0,
      total: 10
    )

    Task {
      let _ = position
    }
  }

  func testSelectionStateIsSendable() {
    let state = MagazineAccessibility.ItemConfiguration.SelectionState(
      isSelected: true,
      isSelectionMode: true
    )

    Task {
      let _ = state
    }
  }

  func testDragDropStateIsSendable() {
    let state = MagazineAccessibility.ItemConfiguration.DragDropState(
      isDraggable: true,
      isDropTarget: false
    )

    Task {
      let _ = state
    }
  }

  // MARK: - Edge Cases

  func testEmptyLabel() {
    let config = MagazineAccessibility.ItemConfiguration(label: "")
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "")
  }

  func testZeroIndexPosition() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "First Item",
      position: .init(index: 0, total: 10)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "First Item, Item 1 of 10")
  }

  func testSingleItemPosition() {
    let config = MagazineAccessibility.ItemConfiguration(
      label: "Only Item",
      position: .init(index: 0, total: 1)
    )
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, "Only Item, Item 1 of 1")
  }

  func testLongLabel() {
    let longText = String(repeating: "Long ", count: 50)
    let config = MagazineAccessibility.ItemConfiguration(label: longText)
    let label = MagazineAccessibility.itemLabel(for: config)

    XCTAssertEqual(label, longText)
  }
}
