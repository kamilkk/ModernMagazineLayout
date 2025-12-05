//
//  MagazineViewportCalculator.swift
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

import CoreGraphics
import Foundation

/// Calculates visible viewport and item ranges for optimized rendering
///
/// `MagazineViewportCalculator` helps determine which sections and items
/// are currently visible in the viewport, enabling efficient cache management
/// and lazy loading strategies.
@available(iOS 18.0, macOS 15.0, *)
public struct MagazineViewportCalculator: Sendable {
  /// Calculate visible section range based on scroll offset
  ///
  /// This method determines which sections are currently visible in the viewport
  /// by comparing section positions with the scroll offset and viewport height.
  ///
  /// - Parameters:
  ///   - scrollOffset: The current vertical scroll offset
  ///   - viewportHeight: The height of the visible viewport
  ///   - sectionHeights: Array of section heights in order
  /// - Returns: A range of visible section indices
  ///
  /// Example:
  /// ```swift
  /// let visibleRange = MagazineViewportCalculator.visibleSections(
  ///     scrollOffset: 500,
  ///     viewportHeight: 800,
  ///     sectionHeights: [200, 300, 400, 250]
  /// )
  /// // Returns something like 1..<3
  /// ```
  public static func visibleSections(
    scrollOffset: CGFloat,
    viewportHeight: CGFloat,
    sectionHeights: [CGFloat]
  ) -> Range<Int> {
    guard !sectionHeights.isEmpty else {
      return 0 ..< 0
    }

    var currentY: CGFloat = 0
    var firstVisible: Int?
    var lastVisible: Int?

    let viewportBottom = scrollOffset + viewportHeight

    for (index, height) in sectionHeights.enumerated() {
      let sectionTop = currentY
      let sectionBottom = currentY + height

      // Check if section intersects viewport
      // Section is visible if its bottom is below scroll offset
      // AND its top is above viewport bottom
      if sectionBottom > scrollOffset && sectionTop < viewportBottom {
        if firstVisible == nil {
          firstVisible = index
        }
        lastVisible = index
      }

      currentY += height

      // Early exit if we've passed the viewport
      if sectionTop >= viewportBottom {
        break
      }
    }

    let first = firstVisible ?? 0
    let last = min((lastVisible ?? sectionHeights.count - 1) + 1, sectionHeights.count)

    return first ..< last
  }

  /// Calculate visible section range with buffer
  ///
  /// Similar to `visibleSections` but includes a buffer of sections
  /// before and after the visible range for smoother scrolling.
  ///
  /// - Parameters:
  ///   - scrollOffset: The current vertical scroll offset
  ///   - viewportHeight: The height of the visible viewport
  ///   - sectionHeights: Array of section heights in order
  ///   - buffer: Number of sections to include before and after visible range
  /// - Returns: A range of section indices including buffer
  public static func visibleSectionsWithBuffer(
    scrollOffset: CGFloat,
    viewportHeight: CGFloat,
    sectionHeights: [CGFloat],
    buffer: Int = 2
  ) -> Range<Int> {
    let visibleRange = visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    let bufferedStart = max(0, visibleRange.lowerBound - buffer)
    let bufferedEnd = min(sectionHeights.count, visibleRange.upperBound + buffer)

    return bufferedStart ..< bufferedEnd
  }

  /// Calculate the Y position of a specific section
  ///
  /// - Parameters:
  ///   - sectionIndex: The index of the section
  ///   - sectionHeights: Array of section heights in order
  /// - Returns: The Y position where the section starts, or `nil` if index is invalid
  public static func sectionYPosition(
    sectionIndex: Int,
    sectionHeights: [CGFloat]
  ) -> CGFloat? {
    guard sectionIndex >= 0 && sectionIndex < sectionHeights.count else {
      return nil
    }

    var y: CGFloat = 0
    for index in 0 ..< sectionIndex {
      y += sectionHeights[index]
    }
    return y
  }

  /// Find which section contains a given Y position
  ///
  /// - Parameters:
  ///   - yPosition: The Y position to query
  ///   - sectionHeights: Array of section heights in order
  /// - Returns: The index of the section containing the Y position, or `nil` if out of bounds
  public static func sectionAtYPosition(
    _ yPosition: CGFloat,
    sectionHeights: [CGFloat]
  ) -> Int? {
    guard !sectionHeights.isEmpty else {
      return nil
    }

    var currentY: CGFloat = 0

    for (index, height) in sectionHeights.enumerated() {
      if yPosition >= currentY && yPosition < currentY + height {
        return index
      }
      currentY += height
    }

    // If position is beyond all sections, return the last section
    if yPosition >= currentY {
      return sectionHeights.count - 1
    }

    return nil
  }

  /// Calculate scroll offset needed to make a section visible
  ///
  /// - Parameters:
  ///   - sectionIndex: The index of the section to scroll to
  ///   - sectionHeights: Array of section heights in order
  ///   - position: Where to position the section (top, center, bottom)
  ///   - viewportHeight: The height of the visible viewport
  /// - Returns: The scroll offset to use, or `nil` if section index is invalid
  public static func scrollOffsetForSection(
    _ sectionIndex: Int,
    sectionHeights: [CGFloat],
    position: ScrollPosition = .top,
    viewportHeight: CGFloat
  ) -> CGFloat? {
    guard let sectionY = sectionYPosition(sectionIndex: sectionIndex, sectionHeights: sectionHeights),
          sectionIndex < sectionHeights.count else {
      return nil
    }

    let sectionHeight = sectionHeights[sectionIndex]

    switch position {
    case .top:
      return sectionY
    case .center:
      return sectionY - (viewportHeight - sectionHeight) / 2
    case .bottom:
      return sectionY - viewportHeight + sectionHeight
    }
  }

  /// Position where a section should be placed in the viewport
  public enum ScrollPosition: Sendable {
    /// Section should be at the top of the viewport
    case top
    /// Section should be centered in the viewport
    case center
    /// Section should be at the bottom of the viewport
    case bottom
  }
}
