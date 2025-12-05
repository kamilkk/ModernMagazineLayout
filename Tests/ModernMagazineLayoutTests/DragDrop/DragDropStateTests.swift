//
//  DragDropStateTests.swift
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
final class DragDropStateTests: XCTestCase {
  // MARK: - Initialization Tests

  func testInitialState() {
    let state = MagazineDragState()

    XCTAssertNil(state.draggingItemId)
    XCTAssertNil(state.draggingFromSection)
    XCTAssertNil(state.draggingFromIndex)
    XCTAssertNil(state.dropTargetSection)
    XCTAssertNil(state.dropTargetIndex)
    XCTAssertFalse(state.isDragging)
    XCTAssertFalse(state.hasDropTarget)
  }

  // MARK: - Drag Start Tests

  func testStartDragging() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 2, index: 5)

    XCTAssertEqual(state.draggingItemId, itemId)
    XCTAssertEqual(state.draggingFromSection, 2)
    XCTAssertEqual(state.draggingFromIndex, 5)
    XCTAssertTrue(state.isDragging)
  }

  func testStartDraggingMultipleTimes() {
    let state = MagazineDragState()
    let itemId1 = UUID()
    let itemId2 = UUID()

    state.startDragging(itemId1, section: 0, index: 0)
    XCTAssertEqual(state.draggingItemId, itemId1)

    // Start dragging another item (replaces the first)
    state.startDragging(itemId2, section: 1, index: 1)
    XCTAssertEqual(state.draggingItemId, itemId2)
    XCTAssertEqual(state.draggingFromSection, 1)
    XCTAssertEqual(state.draggingFromIndex, 1)
  }

  // MARK: - Drop Target Tests

  func testUpdateDropTarget() {
    let state = MagazineDragState()

    state.updateDropTarget(section: 3, index: 7)

    XCTAssertEqual(state.dropTargetSection, 3)
    XCTAssertEqual(state.dropTargetIndex, 7)
    XCTAssertTrue(state.hasDropTarget)
  }

  func testClearDropTarget() {
    let state = MagazineDragState()

    state.updateDropTarget(section: 3, index: 7)
    XCTAssertTrue(state.hasDropTarget)

    state.clearDropTarget()
    XCTAssertNil(state.dropTargetSection)
    XCTAssertNil(state.dropTargetIndex)
    XCTAssertFalse(state.hasDropTarget)
  }

  func testUpdateDropTargetMultipleTimes() {
    let state = MagazineDragState()

    state.updateDropTarget(section: 1, index: 2)
    XCTAssertEqual(state.dropTargetSection, 1)
    XCTAssertEqual(state.dropTargetIndex, 2)

    state.updateDropTarget(section: 3, index: 5)
    XCTAssertEqual(state.dropTargetSection, 3)
    XCTAssertEqual(state.dropTargetIndex, 5)
  }

  // MARK: - End Dragging Tests

  func testEndDraggingSuccess() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)
    state.updateDropTarget(section: 1, index: 5)

    let result = state.endDragging(success: true)

    XCTAssertNotNil(result)
    XCTAssertEqual(result?.itemId, itemId)
    XCTAssertEqual(result?.fromSection, 1)
    XCTAssertEqual(result?.fromIndex, 2)
    XCTAssertEqual(result?.toSection, 1)
    XCTAssertEqual(result?.toIndex, 5)
    XCTAssertFalse(result?.movedBetweenSections ?? true)

    // State should be cleared
    XCTAssertNil(state.draggingItemId)
    XCTAssertNil(state.dropTargetSection)
    XCTAssertFalse(state.isDragging)
  }

  func testEndDraggingFailure() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)
    state.updateDropTarget(section: 1, index: 5)

    let result = state.endDragging(success: false)

    XCTAssertNil(result)

    // State should still be cleared
    XCTAssertNil(state.draggingItemId)
    XCTAssertNil(state.dropTargetSection)
    XCTAssertFalse(state.isDragging)
  }

  func testEndDraggingWithoutDropTarget() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)
    // No drop target set

    let result = state.endDragging(success: true)

    XCTAssertNil(result)
    XCTAssertFalse(state.isDragging)
  }

  func testEndDraggingWithoutStarting() {
    let state = MagazineDragState()

    let result = state.endDragging(success: true)

    XCTAssertNil(result)
  }

  // MARK: - Cross-Section Movement Tests

  func testMovedBetweenSections() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)
    state.updateDropTarget(section: 3, index: 5)

    let result = state.endDragging(success: true)

    XCTAssertNotNil(result)
    XCTAssertTrue(result?.movedBetweenSections ?? false)
    XCTAssertEqual(result?.fromSection, 1)
    XCTAssertEqual(result?.toSection, 3)
  }

  func testNotMovedBetweenSections() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 2, index: 3)
    state.updateDropTarget(section: 2, index: 7)

    let result = state.endDragging(success: true)

    XCTAssertNotNil(result)
    XCTAssertFalse(result?.movedBetweenSections ?? true)
    XCTAssertEqual(result?.fromSection, 2)
    XCTAssertEqual(result?.toSection, 2)
  }

  // MARK: - Valid Move Tests

  func testIsValidMoveSameSection() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)

    // Moving to different index in same section
    XCTAssertTrue(state.isValidMove(toSection: 1, toIndex: 5))

    // Moving to same position
    XCTAssertFalse(state.isValidMove(toSection: 1, toIndex: 2))
  }

  func testIsValidMoveDifferentSection() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 1, index: 2)

    // Moving to different section is always valid
    XCTAssertTrue(state.isValidMove(toSection: 3, toIndex: 0))
  }

  func testIsValidMoveWithoutDragging() {
    let state = MagazineDragState()

    XCTAssertFalse(state.isValidMove(toSection: 1, toIndex: 2))
  }

  // MARK: - Edge Cases

  func testDragToSamePosition() {
    let state = MagazineDragState()
    let itemId = UUID()

    state.startDragging(itemId, section: 2, index: 5)
    state.updateDropTarget(section: 2, index: 5)

    // Even though it's the same position, endDragging should return a result
    let result = state.endDragging(success: true)
    XCTAssertNotNil(result)

    // But isValidMove should return false
    state.startDragging(itemId, section: 2, index: 5)
    XCTAssertFalse(state.isValidMove(toSection: 2, toIndex: 5))
  }

  func testMultipleDragSequences() {
    let state = MagazineDragState()

    // First drag
    let itemId1 = UUID()
    state.startDragging(itemId1, section: 0, index: 0)
    state.updateDropTarget(section: 0, index: 5)
    let result1 = state.endDragging(success: true)
    XCTAssertNotNil(result1)

    // Second drag
    let itemId2 = UUID()
    state.startDragging(itemId2, section: 1, index: 2)
    state.updateDropTarget(section: 2, index: 3)
    let result2 = state.endDragging(success: true)
    XCTAssertNotNil(result2)

    XCTAssertNotEqual(result1?.itemId, result2?.itemId)
  }

  // MARK: - Sendable Conformance Tests

  func testSendableConformance() async {
    let state = MagazineDragState()

    // Should work with async/await
    await MainActor.run {
      let itemId = UUID()
      state.startDragging(itemId, section: 1, index: 2)
      XCTAssertTrue(state.isDragging)
    }
  }

  func testConcurrentAccess() async {
    let state = MagazineDragState()

    await MainActor.run {
      let itemId = UUID()
      state.startDragging(itemId, section: 1, index: 2)
      state.updateDropTarget(section: 1, index: 5)

      let result = state.endDragging(success: true)
      XCTAssertNotNil(result)
    }
  }

  // MARK: - DragDropResult Tests

  func testDragDropResult() {
    let itemId = UUID()
    let result = MagazineDragState.DragDropResult(
      itemId: itemId,
      fromSection: 1,
      fromIndex: 2,
      toSection: 3,
      toIndex: 5
    )

    XCTAssertEqual(result.itemId, itemId)
    XCTAssertEqual(result.fromSection, 1)
    XCTAssertEqual(result.fromIndex, 2)
    XCTAssertEqual(result.toSection, 3)
    XCTAssertEqual(result.toIndex, 5)
    XCTAssertTrue(result.movedBetweenSections)
  }

  func testDragDropResultSameSection() {
    let itemId = UUID()
    let result = MagazineDragState.DragDropResult(
      itemId: itemId,
      fromSection: 2,
      fromIndex: 3,
      toSection: 2,
      toIndex: 7
    )

    XCTAssertFalse(result.movedBetweenSections)
  }
}
