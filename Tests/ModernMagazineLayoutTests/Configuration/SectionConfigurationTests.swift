//
//  SectionConfigurationTests.swift
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
final class SectionConfigurationTests: XCTestCase {
  // MARK: - Initialization Tests

  func testDefaultInitialization() {
    let config = MagazineSectionConfiguration()

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .clear)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertNil(config.border)
    XCTAssertNil(config.shadow)
    XCTAssertEqual(config.padding, EdgeInsets())
    XCTAssertEqual(config.cornerRadius, 0)
    XCTAssertEqual(config.itemSpacing, 8)
    XCTAssertNil(config.header)
  }

  func testCustomInitialization() {
    let padding = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    let border = MagazineSectionConfiguration.BorderStyle(color: .blue, width: 2)
    let shadow = MagazineSectionConfiguration.ShadowStyle(radius: 10)

    let config = MagazineSectionConfiguration(
      backgroundColor: .white,
      border: border,
      shadow: shadow,
      padding: padding,
      cornerRadius: 12,
      itemSpacing: 16
    )

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .white)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertNotNil(config.border)
    XCTAssertEqual(config.border?.width, 2)
    XCTAssertNotNil(config.shadow)
    XCTAssertEqual(config.shadow?.radius, 10)
    XCTAssertEqual(config.padding, padding)
    XCTAssertEqual(config.cornerRadius, 12)
    XCTAssertEqual(config.itemSpacing, 16)
  }

  // MARK: - Background Style Tests

  func testColorBackground() {
    let background = MagazineSectionConfiguration.BackgroundStyle.color(.red)

    if case let .color(color) = background {
      XCTAssertEqual(color, .red)
    } else {
      XCTFail("Expected color background")
    }
  }

  func testSolidBackgroundHelper() {
    let background = MagazineSectionConfiguration.BackgroundStyle.solid(.blue)

    if case let .color(color) = background {
      XCTAssertEqual(color, .blue)
    } else {
      XCTFail("Expected color background")
    }
  }

  func testLinearGradientBackground() {
    let gradient = Gradient(colors: [.red, .blue])
    let background = MagazineSectionConfiguration.BackgroundStyle.linearGradient(
      gradient,
      startPoint: .top,
      endPoint: .bottom
    )

    if case .linearGradient = background {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected linear gradient background")
    }
  }

  func testRadialGradientBackground() {
    let gradient = Gradient(colors: [.yellow, .orange])
    let background = MagazineSectionConfiguration.BackgroundStyle.radialGradient(
      gradient,
      center: .center,
      startRadius: 0,
      endRadius: 100
    )

    if case .radialGradient = background {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected radial gradient background")
    }
  }

  func testClearBackground() {
    let background = MagazineSectionConfiguration.BackgroundStyle.clear

    if case .clear = background {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected clear background")
    }
  }

  // MARK: - Border Style Tests

  func testBasicBorder() {
    let border = MagazineSectionConfiguration.BorderStyle(color: .red, width: 2)

    XCTAssertEqual(border.color, .red)
    XCTAssertEqual(border.width, 2)
  }

  func testDefaultBorderWidth() {
    let border = MagazineSectionConfiguration.BorderStyle(color: .blue)

    XCTAssertEqual(border.color, .blue)
    XCTAssertEqual(border.width, 1)
  }

  func testThinBorderPreset() {
    let border = MagazineSectionConfiguration.BorderStyle.thin(.green)

    XCTAssertEqual(border.color, .green)
    XCTAssertEqual(border.width, 1)
  }

  func testMediumBorderPreset() {
    let border = MagazineSectionConfiguration.BorderStyle.medium(.purple)

    XCTAssertEqual(border.color, .purple)
    XCTAssertEqual(border.width, 2)
  }

  func testThickBorderPreset() {
    let border = MagazineSectionConfiguration.BorderStyle.thick(.orange)

    XCTAssertEqual(border.color, .orange)
    XCTAssertEqual(border.width, 4)
  }

  // MARK: - Shadow Style Tests

  func testBasicShadow() {
    let shadow = MagazineSectionConfiguration.ShadowStyle(
      color: .black.opacity(0.3),
      radius: 12,
      x: 2,
      y: 4
    )

    XCTAssertEqual(shadow.color, .black.opacity(0.3))
    XCTAssertEqual(shadow.radius, 12)
    XCTAssertEqual(shadow.x, 2)
    XCTAssertEqual(shadow.y, 4)
  }

  func testDefaultShadow() {
    let shadow = MagazineSectionConfiguration.ShadowStyle()

    XCTAssertEqual(shadow.color, .black.opacity(0.2))
    XCTAssertEqual(shadow.radius, 8)
    XCTAssertEqual(shadow.x, 0)
    XCTAssertEqual(shadow.y, 2)
  }

  func testSubtleShadowPreset() {
    let shadow = MagazineSectionConfiguration.ShadowStyle.subtle

    XCTAssertEqual(shadow.color, .black.opacity(0.1))
    XCTAssertEqual(shadow.radius, 4)
    XCTAssertEqual(shadow.x, 0)
    XCTAssertEqual(shadow.y, 1)
  }

  func testStandardShadowPreset() {
    let shadow = MagazineSectionConfiguration.ShadowStyle.standard

    XCTAssertEqual(shadow.color, .black.opacity(0.2))
    XCTAssertEqual(shadow.radius, 8)
    XCTAssertEqual(shadow.x, 0)
    XCTAssertEqual(shadow.y, 2)
  }

  func testElevatedShadowPreset() {
    let shadow = MagazineSectionConfiguration.ShadowStyle.elevated

    XCTAssertEqual(shadow.color, .black.opacity(0.3))
    XCTAssertEqual(shadow.radius, 16)
    XCTAssertEqual(shadow.x, 0)
    XCTAssertEqual(shadow.y, 4)
  }

  // MARK: - Header Style Tests

  func testBasicHeader() {
    let header = MagazineSectionConfiguration.HeaderStyle(title: "Section Title")

    XCTAssertEqual(header.title, "Section Title")
    XCTAssertEqual(header.font, .headline)
    XCTAssertEqual(header.color, .primary)
  }

  func testCustomHeader() {
    let padding = EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
    let header = MagazineSectionConfiguration.HeaderStyle(
      title: "Custom Header",
      font: .title,
      color: .blue,
      padding: padding
    )

    XCTAssertEqual(header.title, "Custom Header")
    XCTAssertEqual(header.font, .title)
    XCTAssertEqual(header.color, .blue)
    XCTAssertEqual(header.padding, padding)
  }

  // MARK: - Preset Configurations Tests

  func testCardPreset() {
    let config = MagazineSectionConfiguration.card

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .white)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertNotNil(config.shadow)
    XCTAssertEqual(config.cornerRadius, 12)
    XCTAssertEqual(config.padding.top, 16)
    XCTAssertEqual(config.padding.leading, 16)
  }

  func testBorderedPreset() {
    let config = MagazineSectionConfiguration.bordered

    XCTAssertNotNil(config.border)
    XCTAssertEqual(config.border?.width, 1)
    XCTAssertEqual(config.cornerRadius, 8)
    XCTAssertNil(config.shadow)
  }

  func testFlatPreset() {
    let config = MagazineSectionConfiguration.flat()

    if case .color = config.background {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertEqual(config.cornerRadius, 8)
    XCTAssertNil(config.border)
    XCTAssertNil(config.shadow)
  }

  func testFlatPresetWithCustomColor() {
    let config = MagazineSectionConfiguration.flat(color: .blue.opacity(0.2))

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .blue.opacity(0.2))
    } else {
      XCTFail("Expected color background")
    }
  }

  func testElevatedPreset() {
    let config = MagazineSectionConfiguration.elevated

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .white)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertNotNil(config.shadow)
    XCTAssertEqual(config.shadow?.radius, 16)
    XCTAssertEqual(config.cornerRadius, 16)
    XCTAssertEqual(config.padding.top, 20)
  }

  func testDefaultPreset() {
    let config = MagazineSectionConfiguration.default

    if case let .color(color) = config.background {
      XCTAssertEqual(color, .clear)
    } else {
      XCTFail("Expected color background")
    }

    XCTAssertNil(config.border)
    XCTAssertNil(config.shadow)
    XCTAssertEqual(config.cornerRadius, 0)
  }

  // MARK: - Sendable Conformance Tests

  func testConfigurationIsSendable() {
    let config = MagazineSectionConfiguration.card

    Task {
      let _ = config
    }
  }

  func testBorderStyleIsSendable() {
    let border = MagazineSectionConfiguration.BorderStyle.medium(.blue)

    Task {
      let _ = border
    }
  }

  func testShadowStyleIsSendable() {
    let shadow = MagazineSectionConfiguration.ShadowStyle.standard

    Task {
      let _ = shadow
    }
  }

  func testHeaderStyleIsSendable() {
    let header = MagazineSectionConfiguration.HeaderStyle(title: "Test")

    Task {
      let _ = header
    }
  }

  func testBackgroundStyleIsSendable() {
    let background = MagazineSectionConfiguration.BackgroundStyle.solid(.red)

    Task {
      let _ = background
    }
  }

  // MARK: - Edge Cases

  func testZeroPadding() {
    let config = MagazineSectionConfiguration(
      padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    )

    XCTAssertEqual(config.padding.top, 0)
    XCTAssertEqual(config.padding.leading, 0)
  }

  func testZeroCornerRadius() {
    let config = MagazineSectionConfiguration(cornerRadius: 0)

    XCTAssertEqual(config.cornerRadius, 0)
  }

  func testLargeCornerRadius() {
    let config = MagazineSectionConfiguration(cornerRadius: 50)

    XCTAssertEqual(config.cornerRadius, 50)
  }

  func testZeroItemSpacing() {
    let config = MagazineSectionConfiguration(itemSpacing: 0)

    XCTAssertEqual(config.itemSpacing, 0)
  }

  func testLargeItemSpacing() {
    let config = MagazineSectionConfiguration(itemSpacing: 100)

    XCTAssertEqual(config.itemSpacing, 100)
  }

  func testEmptyHeaderTitle() {
    let header = MagazineSectionConfiguration.HeaderStyle(title: "")

    XCTAssertEqual(header.title, "")
  }

  func testLongHeaderTitle() {
    let longTitle = String(repeating: "Long ", count: 50)
    let header = MagazineSectionConfiguration.HeaderStyle(title: longTitle)

    XCTAssertEqual(header.title, longTitle)
  }

  // MARK: - Complex Configuration Tests

  func testConfigurationWithAllFeatures() {
    let header = MagazineSectionConfiguration.HeaderStyle(title: "Complete Section")
    let border = MagazineSectionConfiguration.BorderStyle.medium(.blue)
    let shadow = MagazineSectionConfiguration.ShadowStyle.elevated
    let padding = EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

    let config = MagazineSectionConfiguration(
      backgroundColor: .white,
      border: border,
      shadow: shadow,
      padding: padding,
      cornerRadius: 16,
      itemSpacing: 12,
      header: header
    )

    XCTAssertNotNil(config.header)
    XCTAssertEqual(config.header?.title, "Complete Section")
    XCTAssertNotNil(config.border)
    XCTAssertNotNil(config.shadow)
    XCTAssertEqual(config.cornerRadius, 16)
    XCTAssertEqual(config.itemSpacing, 12)
  }

  func testGradientConfiguration() {
    let gradient = Gradient(colors: [.red, .orange, .yellow])
    let config = MagazineSectionConfiguration(
      background: .linearGradient(gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
    )

    if case .linearGradient = config.background {
      XCTAssertTrue(true)
    } else {
      XCTFail("Expected linear gradient background")
    }
  }
}
