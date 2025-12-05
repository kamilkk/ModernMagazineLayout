//
//  ViewportCalculatorTests.swift
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
final class ViewportCalculatorTests: XCTestCase {
  // MARK: - Visible Sections Tests

  func testVisibleSectionsBasic() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250]
    let scrollOffset: CGFloat = 0
    let viewportHeight: CGFloat = 500

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    // At scroll 0 with viewport 500, sections 0-1 are visible (200 + 300 = 500)
    XCTAssertEqual(visible, 0 ..< 2)
  }

  func testVisibleSectionsAtMiddle() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250]
    let scrollOffset: CGFloat = 500 // Start of section 2
    let viewportHeight: CGFloat = 800

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    // At scroll 500, viewport covers sections 2-3
    XCTAssertTrue(visible.contains(2))
  }

  func testVisibleSectionsAtEnd() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250]
    let scrollOffset: CGFloat = 900 // Near end
    let viewportHeight: CGFloat = 300

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    // Should include last section
    XCTAssertTrue(visible.contains(3))
  }

  func testVisibleSectionsEmptyHeights() {
    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: 0,
      viewportHeight: 800,
      sectionHeights: []
    )

    XCTAssertEqual(visible, 0 ..< 0)
  }

  func testVisibleSectionsSingleSection() {
    let sectionHeights: [CGFloat] = [500]
    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: 100,
      viewportHeight: 300,
      sectionHeights: sectionHeights
    )

    XCTAssertEqual(visible, 0 ..< 1)
  }

  // MARK: - Visible Sections With Buffer Tests

  func testVisibleSectionsWithBuffer() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250, 350]
    let scrollOffset: CGFloat = 500 // Section 2
    let viewportHeight: CGFloat = 400
    let buffer = 1

    let visible = MagazineViewportCalculator.visibleSectionsWithBuffer(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights,
      buffer: buffer
    )

    // Should include buffer sections before and after
    XCTAssertTrue(visible.count >= 2, "Should include buffer sections")
  }

  func testVisibleSectionsWithLargeBuffer() {
    let sectionHeights: [CGFloat] = [200, 300, 400]
    let buffer = 10 // Buffer larger than array

    let visible = MagazineViewportCalculator.visibleSectionsWithBuffer(
      scrollOffset: 200,
      viewportHeight: 300,
      sectionHeights: sectionHeights,
      buffer: buffer
    )

    // Should clamp to array bounds
    XCTAssertEqual(visible, 0 ..< 3)
  }

  // MARK: - Section Y Position Tests

  func testSectionYPosition() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250]

    let y0 = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: 0,
      sectionHeights: sectionHeights
    )
    XCTAssertEqual(y0, 0)

    let y1 = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: 1,
      sectionHeights: sectionHeights
    )
    XCTAssertEqual(y1, 200)

    let y2 = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: 2,
      sectionHeights: sectionHeights
    )
    XCTAssertEqual(y2, 500) // 200 + 300

    let y3 = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: 3,
      sectionHeights: sectionHeights
    )
    XCTAssertEqual(y3, 900) // 200 + 300 + 400
  }

  func testSectionYPositionInvalid() {
    let sectionHeights: [CGFloat] = [200, 300]

    let y = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: 5,
      sectionHeights: sectionHeights
    )
    XCTAssertNil(y)
  }

  func testSectionYPositionNegativeIndex() {
    let sectionHeights: [CGFloat] = [200, 300]

    let y = MagazineViewportCalculator.sectionYPosition(
      sectionIndex: -1,
      sectionHeights: sectionHeights
    )
    XCTAssertNil(y)
  }

  // MARK: - Section At Y Position Tests

  func testSectionAtYPosition() {
    let sectionHeights: [CGFloat] = [200, 300, 400, 250]

    // Y = 100 should be in section 0
    let section0 = MagazineViewportCalculator.sectionAtYPosition(100, sectionHeights: sectionHeights)
    XCTAssertEqual(section0, 0)

    // Y = 250 should be in section 1 (starts at 200)
    let section1 = MagazineViewportCalculator.sectionAtYPosition(250, sectionHeights: sectionHeights)
    XCTAssertEqual(section1, 1)

    // Y = 550 should be in section 2 (starts at 500)
    let section2 = MagazineViewportCalculator.sectionAtYPosition(550, sectionHeights: sectionHeights)
    XCTAssertEqual(section2, 2)

    // Y = 950 should be in section 3 (starts at 900)
    let section3 = MagazineViewportCalculator.sectionAtYPosition(950, sectionHeights: sectionHeights)
    XCTAssertEqual(section3, 3)
  }

  func testSectionAtYPositionBeyondEnd() {
    let sectionHeights: [CGFloat] = [200, 300]

    let section = MagazineViewportCalculator.sectionAtYPosition(1000, sectionHeights: sectionHeights)
    XCTAssertEqual(section, 1, "Should return last section for positions beyond end")
  }

  func testSectionAtYPositionEmpty() {
    let section = MagazineViewportCalculator.sectionAtYPosition(100, sectionHeights: [])
    XCTAssertNil(section)
  }

  func testSectionAtYPositionZero() {
    let sectionHeights: [CGFloat] = [200, 300]

    let section = MagazineViewportCalculator.sectionAtYPosition(0, sectionHeights: sectionHeights)
    XCTAssertEqual(section, 0)
  }

  func testSectionAtYPositionNegative() {
    let sectionHeights: [CGFloat] = [200, 300]

    let section = MagazineViewportCalculator.sectionAtYPosition(-50, sectionHeights: sectionHeights)
    XCTAssertNil(section)
  }

  // MARK: - Scroll Offset For Section Tests

  func testScrollOffsetForSectionTop() {
    let sectionHeights: [CGFloat] = [200, 300, 400]
    let viewportHeight: CGFloat = 800

    let offset = MagazineViewportCalculator.scrollOffsetForSection(
      1,
      sectionHeights: sectionHeights,
      position: .top,
      viewportHeight: viewportHeight
    )

    XCTAssertEqual(offset, 200, "Section 1 starts at Y=200")
  }

  func testScrollOffsetForSectionCenter() {
    let sectionHeights: [CGFloat] = [200, 300, 400]
    let viewportHeight: CGFloat = 800

    let offset = MagazineViewportCalculator.scrollOffsetForSection(
      1,
      sectionHeights: sectionHeights,
      position: .center,
      viewportHeight: viewportHeight
    )

    // Section 1: starts at 200, height 300
    // Center: 200 - (800 - 300) / 2 = 200 - 250 = -50
    XCTAssertEqual(offset, -50)
  }

  func testScrollOffsetForSectionBottom() {
    let sectionHeights: [CGFloat] = [200, 300, 400]
    let viewportHeight: CGFloat = 800

    let offset = MagazineViewportCalculator.scrollOffsetForSection(
      1,
      sectionHeights: sectionHeights,
      position: .bottom,
      viewportHeight: viewportHeight
    )

    // Section 1: starts at 200, height 300
    // Bottom: 200 - 800 + 300 = -300
    XCTAssertEqual(offset, -300)
  }

  func testScrollOffsetForInvalidSection() {
    let sectionHeights: [CGFloat] = [200, 300]
    let viewportHeight: CGFloat = 800

    let offset = MagazineViewportCalculator.scrollOffsetForSection(
      10,
      sectionHeights: sectionHeights,
      position: .top,
      viewportHeight: viewportHeight
    )

    XCTAssertNil(offset)
  }

  // MARK: - Edge Cases

  func testAllSectionsVerySmall() {
    let sectionHeights: [CGFloat] = [10, 20, 15, 25]
    let scrollOffset: CGFloat = 0
    let viewportHeight: CGFloat = 1000

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    // All sections should be visible
    XCTAssertEqual(visible, 0 ..< 4)
  }

  func testSingleLargeSection() {
    let sectionHeights: [CGFloat] = [5000]
    let scrollOffset: CGFloat = 2000
    let viewportHeight: CGFloat = 800

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    XCTAssertEqual(visible, 0 ..< 1)
  }

  func testVeryLargeViewport() {
    let sectionHeights: [CGFloat] = [200, 300, 400]
    let scrollOffset: CGFloat = 0
    let viewportHeight: CGFloat = 10000

    let visible = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    // All sections visible
    XCTAssertEqual(visible, 0 ..< 3)
  }
}
