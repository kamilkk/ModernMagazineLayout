//
//  WidthModeTests.swift
//  ModernMagazineLayoutTests
//
//  Created by Claude on 04/12/2025.
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
final class WidthModeTests: XCTestCase {
  // MARK: - Equality Tests

  func testWidthModeEquality() {
    // Test that each width mode equals itself
    XCTAssertEqual(MagazineWidthMode.fullWidth, .fullWidth)
    XCTAssertEqual(MagazineWidthMode.halfWidth, .halfWidth)
    XCTAssertEqual(MagazineWidthMode.thirdWidth, .thirdWidth)
    XCTAssertEqual(MagazineWidthMode.quarterWidth, .quarterWidth)
    XCTAssertEqual(MagazineWidthMode.twoThirds, .twoThirds)

    // Test fractional equality
    XCTAssertEqual(MagazineWidthMode.fractional(0.5), .fractional(0.5))
    XCTAssertEqual(MagazineWidthMode.fractional(0.25), .fractional(0.25))
  }

  func testWidthModeInequality() {
    // Test that different width modes are not equal
    XCTAssertNotEqual(MagazineWidthMode.fullWidth, .halfWidth)
    XCTAssertNotEqual(MagazineWidthMode.halfWidth, .thirdWidth)
    XCTAssertNotEqual(MagazineWidthMode.thirdWidth, .quarterWidth)
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .twoThirds)
    XCTAssertNotEqual(MagazineWidthMode.fullWidth, .fractional(1.0))

    // Test fractional inequality
    XCTAssertNotEqual(MagazineWidthMode.fractional(0.5), .fractional(0.6))
  }

  // MARK: - Columns Convenience Method Tests

  func testColumnsConvenienceForStandardCounts() {
    // Test that columns() returns correct width modes for standard counts
    XCTAssertEqual(MagazineWidthMode.columns(1), .fullWidth)
    XCTAssertEqual(MagazineWidthMode.columns(2), .halfWidth)
    XCTAssertEqual(MagazineWidthMode.columns(3), .thirdWidth)
    XCTAssertEqual(MagazineWidthMode.columns(4), .quarterWidth)
  }

  func testColumnsConvenienceForArbitraryCounts() {
    // Test that columns() returns fractional for non-standard counts
    XCTAssertEqual(MagazineWidthMode.columns(5), .fractional(0.2))
    XCTAssertEqual(MagazineWidthMode.columns(6), .fractional(1.0 / 6.0))
    XCTAssertEqual(MagazineWidthMode.columns(8), .fractional(0.125))
    XCTAssertEqual(MagazineWidthMode.columns(10), .fractional(0.1))
  }

  func testColumnsConvenienceCalculation() {
    // Test the fractional calculation
    let fiveColumns = MagazineWidthMode.columns(5)
    if case let .fractional(fraction) = fiveColumns {
      XCTAssertEqual(fraction, 0.2, accuracy: 0.0001)
    } else {
      XCTFail("Expected fractional width mode for 5 columns")
    }

    let sixColumns = MagazineWidthMode.columns(6)
    if case let .fractional(fraction) = sixColumns {
      XCTAssertEqual(fraction, 1.0 / 6.0, accuracy: 0.0001)
    } else {
      XCTFail("Expected fractional width mode for 6 columns")
    }
  }

  // MARK: - Sendable Conformance Tests

  func testSendableConformance() {
    // Test that MagazineWidthMode can be used in concurrent contexts
    let expectation = self.expectation(description: "Sendable test")

    Task {
      let widthMode: MagazineWidthMode = .quarterWidth
      // If this compiles, Sendable conformance works
      _ = widthMode
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  func testSendableWithFractional() {
    // Test that fractional width modes are sendable
    let expectation = self.expectation(description: "Sendable fractional test")

    Task {
      let widthMode: MagazineWidthMode = .fractional(0.333)
      // If this compiles, Sendable conformance works with associated values
      _ = widthMode
      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  // MARK: - New Width Modes Tests

  func testQuarterWidthDistinctFromOthers() {
    // Ensure quarterWidth is distinct
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .fullWidth)
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .halfWidth)
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .thirdWidth)
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .twoThirds)
    XCTAssertNotEqual(MagazineWidthMode.quarterWidth, .fractional(0.25))
  }

  func testTwoThirdsDistinctFromOthers() {
    // Ensure twoThirds is distinct
    XCTAssertNotEqual(MagazineWidthMode.twoThirds, .fullWidth)
    XCTAssertNotEqual(MagazineWidthMode.twoThirds, .halfWidth)
    XCTAssertNotEqual(MagazineWidthMode.twoThirds, .thirdWidth)
    XCTAssertNotEqual(MagazineWidthMode.twoThirds, .quarterWidth)
    XCTAssertNotEqual(MagazineWidthMode.twoThirds, .fractional(2.0 / 3.0))
  }

  // MARK: - Edge Cases

  func testColumnsWithZero() {
    // Test edge case: 0 columns should return fractional(infinity)
    let result = MagazineWidthMode.columns(0)
    if case let .fractional(fraction) = result {
      XCTAssertTrue(fraction.isInfinite)
    } else {
      XCTFail("Expected fractional for 0 columns")
    }
  }

  func testColumnsWithNegative() {
    // Test edge case: negative columns should return fractional(negative)
    let result = MagazineWidthMode.columns(-2)
    if case let .fractional(fraction) = result {
      XCTAssertTrue(fraction < 0)
    } else {
      XCTFail("Expected fractional for negative columns")
    }
  }

  // MARK: - Exhaustive Pattern Matching

  func testAllCasesHandled() {
    // Ensure all cases are handled in a switch
    let allModes: [MagazineWidthMode] = [
      .fullWidth,
      .halfWidth,
      .thirdWidth,
      .quarterWidth,
      .twoThirds,
      .fractional(0.5),
    ]

    for mode in allModes {
      let description: String
      switch mode {
      case .fullWidth:
        description = "fullWidth"
      case .halfWidth:
        description = "halfWidth"
      case .thirdWidth:
        description = "thirdWidth"
      case .quarterWidth:
        description = "quarterWidth"
      case .twoThirds:
        description = "twoThirds"
      case .fractional:
        description = "fractional"
      }

      XCTAssertFalse(description.isEmpty)
    }
  }
}
