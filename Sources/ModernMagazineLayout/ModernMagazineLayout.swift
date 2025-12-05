//
//  ModernMagazineLayout.swift
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
public struct ModernMagazineLayout: Layout {
  public let configuration: Configuration

  public init(configuration: Configuration = Configuration()) {
    self.configuration = configuration
  }

  public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
    let width = proposal.width ?? 0
    let height = calculateHeight(for: subviews, availableWidth: width, cache: &cache)
    return CGSize(width: width, height: height)
  }

  public func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
    let availableWidth = bounds.width - configuration.horizontalSpacing * 2
    var currentY = bounds.minY + configuration.verticalSpacing

    let sections = groupSubviewsIntoSections(subviews)

    for (sectionIndex, section) in sections.enumerated() {
      if sectionIndex > 0 {
        currentY += configuration.sectionSpacing
      }

      currentY += placeSectionItems(
        section,
        in: bounds,
        startingY: currentY,
        availableWidth: availableWidth,
        cache: &cache
      )
    }
  }

  public func makeCache(subviews _: Subviews) -> Cache {
    Cache()
  }
}

@available(iOS 18.0, macOS 15.0, *)
public extension ModernMagazineLayout {
  struct Configuration: Sendable {
    public let horizontalSpacing: CGFloat
    public let verticalSpacing: CGFloat
    public let sectionSpacing: CGFloat
    public let itemSpacing: CGFloat

    public init(
      horizontalSpacing: CGFloat = 16,
      verticalSpacing: CGFloat = 16,
      sectionSpacing: CGFloat = 24,
      itemSpacing: CGFloat = 8
    ) {
      self.horizontalSpacing = horizontalSpacing
      self.verticalSpacing = verticalSpacing
      self.sectionSpacing = sectionSpacing
      self.itemSpacing = itemSpacing
    }
  }

  struct Cache: Sendable {
    var itemSizes: [CGSize] = []
    var sectionInfo: [SectionInfo] = []
  }

  internal struct SectionInfo: Sendable {
    let itemCount: Int
    let totalHeight: CGFloat
  }
}

@available(iOS 18.0, macOS 15.0, *)
extension ModernMagazineLayout {
  private func groupSubviewsIntoSections(_ subviews: Subviews) -> [[LayoutSubview]] {
    var sections: [[LayoutSubview]] = []
    var currentSection: [LayoutSubview] = []

    for subview in subviews {
      if let sectionIndex = subview[MagazineSectionKey.self] {
        while sections.count <= sectionIndex {
          if !currentSection.isEmpty {
            sections.append(currentSection)
            currentSection = []
          }
          if sections.count <= sectionIndex {
            sections.append([])
          }
        }
        sections[sectionIndex].append(subview)
      } else {
        currentSection.append(subview)
      }
    }

    if !currentSection.isEmpty {
      sections.append(currentSection)
    }

    return sections
  }

  private func calculateHeight(for subviews: Subviews, availableWidth: CGFloat, cache: inout Cache) -> CGFloat {
    let contentWidth = availableWidth - configuration.horizontalSpacing * 2
    let sections = groupSubviewsIntoSections(subviews)
    var totalHeight: CGFloat = configuration.verticalSpacing

    for (sectionIndex, section) in sections.enumerated() {
      if sectionIndex > 0 {
        totalHeight += configuration.sectionSpacing
      }

      totalHeight += calculateSectionHeight(section, availableWidth: contentWidth, cache: &cache)
    }

    totalHeight += configuration.verticalSpacing
    return totalHeight
  }

  private func calculateSectionHeight(_ section: [LayoutSubview], availableWidth: CGFloat, cache _: inout Cache) -> CGFloat {
    var maxY: CGFloat = 0
    var currentX: CGFloat = 0
    var currentRowHeight: CGFloat = 0

    for subview in section {
      let widthMode = subview[MagazineWidthModeKey.self] ?? .fullWidth
      let itemWidth = calculateItemWidth(for: widthMode, availableWidth: availableWidth)

      let proposal = ProposedViewSize(width: itemWidth, height: nil)
      let itemSize = subview.sizeThatFits(proposal)

      if currentX + itemWidth > availableWidth {
        maxY += currentRowHeight + configuration.itemSpacing
        currentX = 0
        currentRowHeight = 0
      }

      currentX += itemWidth + configuration.itemSpacing
      currentRowHeight = max(currentRowHeight, itemSize.height)
    }

    maxY += currentRowHeight
    return maxY
  }

  private func placeSectionItems(
    _ section: [LayoutSubview],
    in bounds: CGRect,
    startingY: CGFloat,
    availableWidth: CGFloat,
    cache _: inout Cache
  ) -> CGFloat {
    var currentX: CGFloat = bounds.minX + configuration.horizontalSpacing
    var currentY: CGFloat = startingY
    var currentRowHeight: CGFloat = 0

    for subview in section {
      let widthMode = subview[MagazineWidthModeKey.self] ?? .fullWidth
      let itemWidth = calculateItemWidth(for: widthMode, availableWidth: availableWidth)

      let proposal = ProposedViewSize(width: itemWidth, height: nil)
      let itemSize = subview.sizeThatFits(proposal)

      if currentX + itemWidth > bounds.minX + configuration.horizontalSpacing + availableWidth {
        currentY += currentRowHeight + configuration.itemSpacing
        currentX = bounds.minX + configuration.horizontalSpacing
        currentRowHeight = 0
      }

      let itemBounds = CGRect(
        x: currentX,
        y: currentY,
        width: itemWidth,
        height: itemSize.height
      )

      subview.place(at: itemBounds.origin, proposal: ProposedViewSize(itemBounds.size))

      currentX += itemWidth + configuration.itemSpacing
      currentRowHeight = max(currentRowHeight, itemSize.height)
    }

    return currentY + currentRowHeight - startingY
  }

  private func calculateItemWidth(for widthMode: MagazineWidthMode, availableWidth: CGFloat) -> CGFloat {
    switch widthMode {
    case .fullWidth:
      return availableWidth
    case .halfWidth:
      return (availableWidth - configuration.itemSpacing) / 2
    case .thirdWidth:
      return (availableWidth - configuration.itemSpacing * 2) / 3
    case .quarterWidth:
      return (availableWidth - configuration.itemSpacing * 3) / 4
    case .twoThirds:
      return (availableWidth - configuration.itemSpacing) * 2 / 3
    case let .fractional(fraction):
      return availableWidth * fraction
    }
  }
}
