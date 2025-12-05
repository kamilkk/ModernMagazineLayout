//
//  DragDropConfigurationTests.swift
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
import UniformTypeIdentifiers
import XCTest

@available(iOS 18.0, macOS 15.0, *)
final class DragDropConfigurationTests: XCTestCase {
  // MARK: - Initialization Tests

  func testDefaultInitialization() {
    let config = MagazineDragDropConfiguration()

    XCTAssertTrue(config.allowsReordering)
    XCTAssertTrue(config.allowsImport)
    XCTAssertTrue(config.allowsExport)
    XCTAssertTrue(config.allowsCrossSectionMovement)
    XCTAssertEqual(config.acceptedTypes, [.item])
    XCTAssertNil(config.onReorder)
    XCTAssertNil(config.onMoveBetweenSections)
    XCTAssertNil(config.onImport)
    XCTAssertNil(config.onDragStarted)
    XCTAssertNil(config.onDragEnded)
  }

  func testCustomInitialization() {
    let config = MagazineDragDropConfiguration(
      allowsReordering: false,
      allowsImport: false,
      allowsExport: false,
      allowsCrossSectionMovement: false,
      acceptedTypes: [.text, .image],
      onReorder: { _, _, _ in }
    )

    XCTAssertFalse(config.allowsReordering)
    XCTAssertFalse(config.allowsImport)
    XCTAssertFalse(config.allowsExport)
    XCTAssertFalse(config.allowsCrossSectionMovement)
    XCTAssertEqual(config.acceptedTypes, [.text, .image])
    XCTAssertNotNil(config.onReorder)
  }

  // MARK: - Drag Preview Style Tests

  func testDragPreviewStyleAutomatic() {
    let config = MagazineDragDropConfiguration(dragPreviewStyle: .automatic)

    if case .automatic = config.dragPreviewStyle {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected automatic style")
    }
  }

  func testDragPreviewStyleShadow() {
    let config = MagazineDragDropConfiguration(
      dragPreviewStyle: .shadow(radius: 10, opacity: 0.5)
    )

    if case let .shadow(radius, opacity) = config.dragPreviewStyle {
      XCTAssertEqual(radius, 10)
      XCTAssertEqual(opacity, 0.5)
    } else {
      XCTFail("Expected shadow style")
    }
  }

  func testDragPreviewStyleBorder() {
    let config = MagazineDragDropConfiguration(
      dragPreviewStyle: .border(color: "blue", width: 2.0)
    )

    if case let .border(color, width) = config.dragPreviewStyle {
      XCTAssertEqual(color, "blue")
      XCTAssertEqual(width, 2.0)
    } else {
      XCTFail("Expected border style")
    }
  }

  func testDragPreviewStyleNone() {
    let config = MagazineDragDropConfiguration(dragPreviewStyle: .none)

    if case .none = config.dragPreviewStyle {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected none style")
    }
  }

  // MARK: - Callback Tests

  func testOnReorderCallback() async {
    actor CallbackCapture {
      var capturedItemId: UUID?
      var capturedFromIndex: Int?
      var capturedToIndex: Int?

      func capture(itemId: UUID, fromIndex: Int, toIndex: Int) {
        capturedItemId = itemId
        capturedFromIndex = fromIndex
        capturedToIndex = toIndex
      }
    }

    let capture = CallbackCapture()

    let config = MagazineDragDropConfiguration(
      onReorder: { itemId, fromIndex, toIndex in
        Task {
          await capture.capture(itemId: itemId, fromIndex: fromIndex, toIndex: toIndex)
        }
      }
    )

    let itemId = UUID()
    config.onReorder?(itemId, 5, 10)

    // Give time for async capture
    try? await Task.sleep(nanoseconds: 10_000_000)

    let capturedItemId = await capture.capturedItemId
    let capturedFromIndex = await capture.capturedFromIndex
    let capturedToIndex = await capture.capturedToIndex

    XCTAssertEqual(capturedItemId, itemId)
    XCTAssertEqual(capturedFromIndex, 5)
    XCTAssertEqual(capturedToIndex, 10)
  }

  func testOnMoveBetweenSectionsCallback() async {
    actor CallbackCapture {
      var capturedItemId: UUID?
      var capturedFromSection: Int?
      var capturedToSection: Int?

      func capture(itemId: UUID, fromSection: Int, toSection: Int) {
        capturedItemId = itemId
        capturedFromSection = fromSection
        capturedToSection = toSection
      }
    }

    let capture = CallbackCapture()

    let config = MagazineDragDropConfiguration(
      onMoveBetweenSections: { itemId, fromSection, toSection in
        Task {
          await capture.capture(itemId: itemId, fromSection: fromSection, toSection: toSection)
        }
      }
    )

    let itemId = UUID()
    config.onMoveBetweenSections?(itemId, 2, 5)

    try? await Task.sleep(nanoseconds: 10_000_000)

    let capturedItemId = await capture.capturedItemId
    let capturedFromSection = await capture.capturedFromSection
    let capturedToSection = await capture.capturedToSection

    XCTAssertEqual(capturedItemId, itemId)
    XCTAssertEqual(capturedFromSection, 2)
    XCTAssertEqual(capturedToSection, 5)
  }

  func testOnImportCallback() async {
    actor CallbackCapture {
      var importCalled = false
      var providerCount = 0

      func capture(count: Int) {
        importCalled = true
        providerCount = count
      }
    }

    let capture = CallbackCapture()

    let config = MagazineDragDropConfiguration(
      onImport: { providers in
        let count = providers.count
        Task {
          await capture.capture(count: count)
        }
      }
    )

    let providers = [NSItemProvider(object: "Test" as NSString)]
    config.onImport?(providers)

    try? await Task.sleep(nanoseconds: 10_000_000)

    let importCalled = await capture.importCalled
    let providerCount = await capture.providerCount

    XCTAssertTrue(importCalled)
    XCTAssertEqual(providerCount, 1)
  }

  func testOnDragStartedCallback() async {
    actor CallbackCapture {
      var capturedItemId: UUID?

      func capture(itemId: UUID) {
        capturedItemId = itemId
      }
    }

    let capture = CallbackCapture()

    let config = MagazineDragDropConfiguration(
      onDragStarted: { itemId in
        Task {
          await capture.capture(itemId: itemId)
        }
      }
    )

    let itemId = UUID()
    config.onDragStarted?(itemId)

    try? await Task.sleep(nanoseconds: 10_000_000)

    let capturedItemId = await capture.capturedItemId
    XCTAssertEqual(capturedItemId, itemId)
  }

  func testOnDragEndedCallback() async {
    actor CallbackCapture {
      var capturedItemId: UUID?
      var capturedSuccess: Bool?

      func capture(itemId: UUID, success: Bool) {
        capturedItemId = itemId
        capturedSuccess = success
      }
    }

    let capture = CallbackCapture()

    let config = MagazineDragDropConfiguration(
      onDragEnded: { itemId, success in
        Task {
          await capture.capture(itemId: itemId, success: success)
        }
      }
    )

    let itemId = UUID()
    config.onDragEnded?(itemId, true)

    try? await Task.sleep(nanoseconds: 10_000_000)

    let capturedItemId = await capture.capturedItemId
    let capturedSuccess = await capture.capturedSuccess

    XCTAssertEqual(capturedItemId, itemId)
    XCTAssertEqual(capturedSuccess, true)
  }

  // MARK: - Sendable Conformance Tests

  func testSendableConformance() {
    let config = MagazineDragDropConfiguration()

    // Should compile without errors due to Sendable conformance
    Task {
      let _ = config
    }
  }

  func testSendableWithCallbacks() {
    let config = MagazineDragDropConfiguration(
      onReorder: { _, _, _ in },
      onMoveBetweenSections: { _, _, _ in },
      onImport: { _ in }
    )

    // Should compile due to @Sendable closures
    Task {
      config.onReorder?(UUID(), 0, 1)
    }
  }

  // MARK: - Accepted Types Tests

  func testCustomAcceptedTypes() {
    let config = MagazineDragDropConfiguration(
      acceptedTypes: [.text, .image, .pdf]
    )

    XCTAssertEqual(config.acceptedTypes.count, 3)
    XCTAssertTrue(config.acceptedTypes.contains(.text))
    XCTAssertTrue(config.acceptedTypes.contains(.image))
    XCTAssertTrue(config.acceptedTypes.contains(.pdf))
  }

  func testEmptyAcceptedTypes() {
    let config = MagazineDragDropConfiguration(acceptedTypes: [])

    XCTAssertTrue(config.acceptedTypes.isEmpty)
  }
}
