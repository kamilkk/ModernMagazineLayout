//
//  MagazineSectionConfiguration.swift
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

import SwiftUI

/// Configuration for magazine section visual customization
///
/// `MagazineSectionConfiguration` provides comprehensive styling options
/// for magazine sections, including backgrounds, borders, shadows, padding,
/// corner radius, and spacing.
///
/// Example:
/// ```swift
/// let sectionConfig = MagazineSectionConfiguration(
///     backgroundColor: .gray.opacity(0.1),
///     cornerRadius: 12,
///     padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
///     border: .init(color: .blue, width: 2)
/// )
///
/// MagazineSection(configuration: sectionConfig) {
///     ForEach(items) { item in
///         MagazineItem(itemId: item.id) {
///             ItemCard(item: item)
///         }
///     }
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public struct MagazineSectionConfiguration: Sendable {
  /// Background configuration for the section
  public var background: BackgroundStyle

  /// Border configuration for the section
  public var border: BorderStyle?

  /// Shadow configuration for the section
  public var shadow: ShadowStyle?

  /// Padding inside the section
  public var padding: EdgeInsets

  /// Corner radius for the section
  public var cornerRadius: CGFloat

  /// Spacing between items in the section
  public var itemSpacing: CGFloat

  /// Header configuration
  public var header: HeaderStyle?

  /// Initialize section configuration
  ///
  /// - Parameters:
  ///   - backgroundColor: Background color (default: clear)
  ///   - border: Border style (default: nil)
  ///   - shadow: Shadow style (default: nil)
  ///   - padding: Inside padding (default: zero)
  ///   - cornerRadius: Corner radius (default: 0)
  ///   - itemSpacing: Spacing between items (default: 8)
  ///   - header: Header style (default: nil)
  public init(
    backgroundColor: Color = .clear,
    border: BorderStyle? = nil,
    shadow: ShadowStyle? = nil,
    padding: EdgeInsets = EdgeInsets(),
    cornerRadius: CGFloat = 0,
    itemSpacing: CGFloat = 8,
    header: HeaderStyle? = nil
  ) {
    background = .color(backgroundColor)
    self.border = border
    self.shadow = shadow
    self.padding = padding
    self.cornerRadius = cornerRadius
    self.itemSpacing = itemSpacing
    self.header = header
  }

  /// Initialize with custom background style
  public init(
    background: BackgroundStyle,
    border: BorderStyle? = nil,
    shadow: ShadowStyle? = nil,
    padding: EdgeInsets = EdgeInsets(),
    cornerRadius: CGFloat = 0,
    itemSpacing: CGFloat = 8,
    header: HeaderStyle? = nil
  ) {
    self.background = background
    self.border = border
    self.shadow = shadow
    self.padding = padding
    self.cornerRadius = cornerRadius
    self.itemSpacing = itemSpacing
    self.header = header
  }

  // MARK: - Background Style

  /// Background style options for sections
  public enum BackgroundStyle: Sendable {
    /// Solid color background
    case color(Color)

    /// Linear gradient background
    case linearGradient(Gradient, startPoint: UnitPoint, endPoint: UnitPoint)

    /// Radial gradient background
    case radialGradient(Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)

    /// No background
    case clear

    /// Create a simple color background
    public static func solid(_ color: Color) -> BackgroundStyle {
      .color(color)
    }
  }

  // MARK: - Border Style

  /// Border style for sections
  public struct BorderStyle: Sendable {
    /// Border color
    public let color: Color

    /// Border width
    public let width: CGFloat

    /// Initialize border style
    public init(color: Color, width: CGFloat = 1) {
      self.color = color
      self.width = width
    }

    /// Predefined thin border
    public static func thin(_ color: Color) -> BorderStyle {
      BorderStyle(color: color, width: 1)
    }

    /// Predefined medium border
    public static func medium(_ color: Color) -> BorderStyle {
      BorderStyle(color: color, width: 2)
    }

    /// Predefined thick border
    public static func thick(_ color: Color) -> BorderStyle {
      BorderStyle(color: color, width: 4)
    }
  }

  // MARK: - Shadow Style

  /// Shadow style for sections
  public struct ShadowStyle: Sendable {
    /// Shadow color
    public let color: Color

    /// Shadow radius
    public let radius: CGFloat

    /// Shadow offset
    public let x: CGFloat
    public let y: CGFloat

    /// Initialize shadow style
    public init(color: Color = .black.opacity(0.2), radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 2) {
      self.color = color
      self.radius = radius
      self.x = x
      self.y = y
    }

    /// Predefined subtle shadow
    public static var subtle: ShadowStyle {
      ShadowStyle(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
    }

    /// Predefined standard shadow
    public static var standard: ShadowStyle {
      ShadowStyle(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
    }

    /// Predefined elevated shadow
    public static var elevated: ShadowStyle {
      ShadowStyle(color: .black.opacity(0.3), radius: 16, x: 0, y: 4)
    }
  }

  // MARK: - Header Style

  /// Header style for sections
  public struct HeaderStyle: Sendable {
    /// Header title
    public let title: String

    /// Header font
    public let font: Font

    /// Header color
    public let color: Color

    /// Header padding
    public let padding: EdgeInsets

    /// Initialize header style
    public init(
      title: String,
      font: Font = .headline,
      color: Color = .primary,
      padding: EdgeInsets = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    ) {
      self.title = title
      self.font = font
      self.color = color
      self.padding = padding
    }
  }

  // MARK: - Presets

  /// Card-style section with subtle shadow and padding
  public static var card: MagazineSectionConfiguration {
    MagazineSectionConfiguration(
      backgroundColor: .white,
      shadow: .standard,
      padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
      cornerRadius: 12
    )
  }

  /// Bordered section with no background
  public static var bordered: MagazineSectionConfiguration {
    MagazineSectionConfiguration(
      border: .thin(.gray),
      padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12),
      cornerRadius: 8
    )
  }

  /// Flat section with background color
  public static func flat(color: Color = .gray.opacity(0.1)) -> MagazineSectionConfiguration {
    MagazineSectionConfiguration(
      backgroundColor: color,
      padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
      cornerRadius: 8
    )
  }

  /// Elevated section with prominent shadow
  public static var elevated: MagazineSectionConfiguration {
    MagazineSectionConfiguration(
      backgroundColor: .white,
      shadow: .elevated,
      padding: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20),
      cornerRadius: 16
    )
  }

  /// Default section with no styling
  public static var `default`: MagazineSectionConfiguration {
    MagazineSectionConfiguration()
  }
}

// MARK: - MagazineSection View

/// A section container for magazine layouts with customizable styling
@available(iOS 18.0, macOS 15.0, *)
public struct MagazineSection<Content: View>: View {
  private let configuration: MagazineSectionConfiguration
  private let content: Content

  public init(
    configuration: MagazineSectionConfiguration = .default,
    @ViewBuilder content: () -> Content
  ) {
    self.configuration = configuration
    self.content = content()
  }

  public var body: some View {
    VStack(spacing: configuration.itemSpacing) {
      if let header = configuration.header {
        Text(header.title)
          .font(header.font)
          .foregroundColor(header.color)
          .padding(header.padding)
          .frame(maxWidth: .infinity, alignment: .leading)
          .magazineSectionHeader(header.title, index: 0)
      }

      content
    }
    .padding(configuration.padding)
    .background {
      backgroundView
    }
    .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius))
    .if(configuration.border != nil) { view in
      view.overlay {
        RoundedRectangle(cornerRadius: configuration.cornerRadius)
          .strokeBorder(configuration.border!.color, lineWidth: configuration.border!.width)
      }
    }
    .if(configuration.shadow != nil) { view in
      view.shadow(
        color: configuration.shadow!.color,
        radius: configuration.shadow!.radius,
        x: configuration.shadow!.x,
        y: configuration.shadow!.y
      )
    }
  }

  @ViewBuilder
  private var backgroundView: some View {
    switch configuration.background {
    case let .color(color):
      color
    case let .linearGradient(gradient, startPoint, endPoint):
      LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    case let .radialGradient(gradient, center, startRadius, endRadius):
      RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
    case .clear:
      Color.clear
    }
  }
}

// MARK: - Helper Extension

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
