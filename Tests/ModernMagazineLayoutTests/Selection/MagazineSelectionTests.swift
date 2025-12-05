//
//  MagazineSelectionTests.swift
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
import XCTest

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class MagazineSelectionTests: XCTestCase {
  // MARK: - Toggle Tests

  func testToggleSelection() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    // Initially not selected
    XCTAssertFalse(selection.isSelected(id))

    // Toggle to select
    let result1 = selection.toggle(id)
    XCTAssertTrue(result1, "Toggle should return true when selecting")
    XCTAssertTrue(selection.isSelected(id))
    XCTAssertEqual(selection.selectedItems.count, 1)

    // Toggle to deselect
    let result2 = selection.toggle(id)
    XCTAssertFalse(result2, "Toggle should return false when deselecting")
    XCTAssertFalse(selection.isSelected(id))
    XCTAssertEqual(selection.selectedItems.count, 0)
  }

  func testToggleMultipleItems() {
    let selection = MagazineSelection<UUID>()
    let id1 = UUID()
    let id2 = UUID()
    let id3 = UUID()

    selection.toggle(id1)
    selection.toggle(id2)
    selection.toggle(id3)

    XCTAssertEqual(selection.selectedItems.count, 3)
    XCTAssertTrue(selection.isSelected(id1))
    XCTAssertTrue(selection.isSelected(id2))
    XCTAssertTrue(selection.isSelected(id3))

    // Toggle one off
    selection.toggle(id2)
    XCTAssertEqual(selection.selectedItems.count, 2)
    XCTAssertTrue(selection.isSelected(id1))
    XCTAssertFalse(selection.isSelected(id2))
    XCTAssertTrue(selection.isSelected(id3))
  }

  // MARK: - Select/Deselect Tests

  func testSelect() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    let result = selection.select(id)
    XCTAssertTrue(result, "Select should return true on success")
    XCTAssertTrue(selection.isSelected(id))
    XCTAssertEqual(selection.selectedItems.count, 1)
  }

  func testSelectMultipleTimes() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    selection.select(id)
    selection.select(id) // Select again

    // Should still only have one item
    XCTAssertEqual(selection.selectedItems.count, 1)
    XCTAssertTrue(selection.isSelected(id))
  }

  func testDeselect() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    selection.select(id)
    XCTAssertTrue(selection.isSelected(id))

    selection.deselect(id)
    XCTAssertFalse(selection.isSelected(id))
    XCTAssertEqual(selection.selectedItems.count, 0)
  }

  func testDeselectNonExistent() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    // Should not crash when deselecting non-existent item
    selection.deselect(id)
    XCTAssertFalse(selection.isSelected(id))
  }

  // MARK: - Single Selection Policy Tests

  func testSingleSelectionPolicy() {
    let selection = MagazineSelection<UUID>(selectionPolicy: .single)
    let id1 = UUID()
    let id2 = UUID()

    selection.select(id1)
    XCTAssertTrue(selection.isSelected(id1))
    XCTAssertEqual(selection.selectedItems.count, 1)

    // Selecting another item should replace the first
    selection.select(id2)
    XCTAssertFalse(selection.isSelected(id1), "First item should be deselected")
    XCTAssertTrue(selection.isSelected(id2), "Second item should be selected")
    XCTAssertEqual(selection.selectedItems.count, 1, "Only one item should be selected")
  }

  func testSingleSelectionPolicyWithToggle() {
    let selection = MagazineSelection<UUID>(selectionPolicy: .single)
    let id1 = UUID()
    let id2 = UUID()

    selection.toggle(id1)
    XCTAssertTrue(selection.isSelected(id1))

    selection.toggle(id2)
    XCTAssertFalse(selection.isSelected(id1))
    XCTAssertTrue(selection.isSelected(id2))
    XCTAssertEqual(selection.selectedItems.count, 1)
  }

  // MARK: - Multiple Selection Policy Tests

  func testMultipleSelectionPolicy() {
    let selection = MagazineSelection<UUID>(selectionPolicy: .multiple)
    let id1 = UUID()
    let id2 = UUID()
    let id3 = UUID()

    selection.select(id1)
    selection.select(id2)
    selection.select(id3)

    XCTAssertEqual(selection.selectedItems.count, 3)
    XCTAssertTrue(selection.isSelected(id1))
    XCTAssertTrue(selection.isSelected(id2))
    XCTAssertTrue(selection.isSelected(id3))
  }

  // MARK: - Selection Limit Tests

  func testSelectionLimit() {
    let selection = MagazineSelection<UUID>(selectionLimit: 2)
    let id1 = UUID()
    let id2 = UUID()
    let id3 = UUID()

    let result1 = selection.select(id1)
    XCTAssertTrue(result1)

    let result2 = selection.select(id2)
    XCTAssertTrue(result2)

    // Third selection should fail
    let result3 = selection.select(id3)
    XCTAssertFalse(result3, "Selection should fail when limit is reached")
    XCTAssertEqual(selection.selectedItems.count, 2)
    XCTAssertFalse(selection.isSelected(id3))
  }

  func testSelectionLimitWithToggle() {
    let selection = MagazineSelection<UUID>(selectionLimit: 2)
    let ids = [UUID(), UUID(), UUID()]

    selection.toggle(ids[0])
    selection.toggle(ids[1])

    XCTAssertEqual(selection.selectedItems.count, 2)

    // Third toggle should fail
    let result = selection.toggle(ids[2])
    XCTAssertFalse(result, "Toggle should return false when limit is reached")
    XCTAssertEqual(selection.selectedItems.count, 2)
  }

  func testSelectionLimitAfterDeselection() {
    let selection = MagazineSelection<UUID>(selectionLimit: 2)
    let ids = [UUID(), UUID(), UUID()]

    selection.select(ids[0])
    selection.select(ids[1])

    // Deselect one
    selection.deselect(ids[0])
    XCTAssertEqual(selection.selectedItems.count, 1)

    // Now we can select again
    let result = selection.select(ids[2])
    XCTAssertTrue(result)
    XCTAssertEqual(selection.selectedItems.count, 2)
  }

  // MARK: - Select All Tests

  func testSelectAll() {
    let selection = MagazineSelection<UUID>()
    let ids = [UUID(), UUID(), UUID()]

    selection.selectAll(ids)

    XCTAssertEqual(selection.selectedItems.count, 3)
    for id in ids {
      XCTAssertTrue(selection.isSelected(id))
    }
  }

  func testSelectAllWithSinglePolicy() {
    let selection = MagazineSelection<UUID>(selectionPolicy: .single)
    let ids = [UUID(), UUID(), UUID()]

    selection.selectAll(ids)

    // Only first item should be selected
    XCTAssertEqual(selection.selectedItems.count, 1)
    XCTAssertTrue(selection.isSelected(ids[0]))
    XCTAssertFalse(selection.isSelected(ids[1]))
    XCTAssertFalse(selection.isSelected(ids[2]))
  }

  func testSelectAllWithLimit() {
    let selection = MagazineSelection<UUID>(selectionLimit: 2)
    let ids = [UUID(), UUID(), UUID(), UUID()]

    selection.selectAll(ids)

    // Only first 2 items should be selected
    XCTAssertEqual(selection.selectedItems.count, 2)
  }

  func testSelectAllEmptyArray() {
    let selection = MagazineSelection<UUID>()

    selection.selectAll([])

    XCTAssertEqual(selection.selectedItems.count, 0)
  }

  // MARK: - Deselect All Tests

  func testDeselectAll() {
    let selection = MagazineSelection<UUID>()
    let ids = [UUID(), UUID(), UUID()]

    selection.selectAll(ids)
    XCTAssertEqual(selection.selectedItems.count, 3)

    selection.deselectAll()
    XCTAssertEqual(selection.selectedItems.count, 0)
    for id in ids {
      XCTAssertFalse(selection.isSelected(id))
    }
  }

  func testDeselectAllWhenEmpty() {
    let selection = MagazineSelection<UUID>()

    // Should not crash
    selection.deselectAll()
    XCTAssertEqual(selection.selectedItems.count, 0)
  }

  // MARK: - Selection Mode Tests

  func testSelectionModeToggle() {
    let selection = MagazineSelection<UUID>()

    XCTAssertFalse(selection.isSelectionMode)

    selection.isSelectionMode = true
    XCTAssertTrue(selection.isSelectionMode)

    selection.isSelectionMode = false
    XCTAssertFalse(selection.isSelectionMode)
  }

  func testExitSelectionMode() {
    let selection = MagazineSelection<UUID>()
    let ids = [UUID(), UUID()]

    selection.isSelectionMode = true
    selection.selectAll(ids)

    XCTAssertTrue(selection.isSelectionMode)
    XCTAssertEqual(selection.selectedItems.count, 2)

    selection.exitSelectionMode()

    XCTAssertFalse(selection.isSelectionMode)
    XCTAssertEqual(selection.selectedItems.count, 0, "All items should be deselected")
  }

  // MARK: - Is Selected Tests

  func testIsSelected() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    XCTAssertFalse(selection.isSelected(id))

    selection.select(id)
    XCTAssertTrue(selection.isSelected(id))

    selection.deselect(id)
    XCTAssertFalse(selection.isSelected(id))
  }

  func testIsSelectedForNonExistent() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    XCTAssertFalse(selection.isSelected(id))
  }

  // MARK: - Sendable Conformance Tests

  func testSendableConformance() async {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    // Test that we can use selection in async context
    await MainActor.run {
      selection.select(id)
      XCTAssertTrue(selection.isSelected(id))
    }
  }

  func testSendableInTask() {
    let expectation = self.expectation(description: "Sendable test")
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    Task { @MainActor in
      selection.select(id)
      XCTAssertTrue(selection.isSelected(id))
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - Edge Cases

  func testLargeNumberOfSelections() {
    let selection = MagazineSelection<UUID>()
    let ids = (0 ..< 1000).map { _ in UUID() }

    selection.selectAll(ids)

    XCTAssertEqual(selection.selectedItems.count, 1000)
  }

  func testSelectionPersistence() {
    let selection = MagazineSelection<UUID>()
    let id = UUID()

    selection.select(id)

    // Exit and re-enter selection mode
    selection.exitSelectionMode()
    selection.isSelectionMode = true

    // Selection should be cleared
    XCTAssertFalse(selection.isSelected(id))
  }
}
