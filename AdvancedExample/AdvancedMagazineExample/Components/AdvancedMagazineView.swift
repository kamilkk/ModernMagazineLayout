//
//  AdvancedMagazineView.swift
//  AdvancedMagazineExample
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

import ModernMagazineLayout
import SwiftUI

struct AdvancedMagazineView: View {
  let sections: [MagazineSection]
  let configuration: ModernMagazineLayout.Configuration
  let selection: MagazineSelection<UUID>?
  let onSectionHeaderTapped: ((Int) -> Void)?
  let onSectionFooterTapped: ((Int) -> Void)?

  init(
    sections: [MagazineSection],
    configuration: ModernMagazineLayout.Configuration = ModernMagazineLayout.Configuration(),
    selection: MagazineSelection<UUID>? = nil,
    onSectionHeaderTapped: ((Int) -> Void)? = nil,
    onSectionFooterTapped: ((Int) -> Void)? = nil
  ) {
    self.sections = sections
    self.configuration = configuration
    self.selection = selection
    self.onSectionHeaderTapped = onSectionHeaderTapped
    self.onSectionFooterTapped = onSectionFooterTapped
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(sections.enumerated()), id: \.element.id) { sectionIndex, section in
          VStack(spacing: 0) {
            if section.configuration.showHeader, let title = section.title {
              SectionHeaderView(
                title: title,
                style: section.configuration.headerStyle,
                onSeeAllTapped: {
                  onSectionHeaderTapped?(sectionIndex)
                }
              )
            }

            if section.configuration.showBackground {
              sectionContent(for: section, at: sectionIndex)
                .background(section.configuration.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
            } else {
              sectionContent(for: section, at: sectionIndex)
            }

            if section.configuration.showFooter {
              SectionFooterView {
                onSectionFooterTapped?(sectionIndex)
              }
            }
          }
          .padding(.bottom, section.configuration.spacing)
        }
      }
    }
    .background(DSColors.backgroundPrimary)
  }

  @ViewBuilder
  private func sectionContent(for section: MagazineSection, at sectionIndex: Int) -> some View {
    ModernMagazineLayout(configuration: configuration) {
      ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
        MagazineItem(
          widthMode: item.widthMode,
          section: sectionIndex,
          itemId: item.id,
          index: index,
          accessibilityLabel: getAccessibilityLabel(for: item),
          totalItemsInSection: section.items.count
        ) {
          item.buildView()
            .onAppear {
              trackItemImpression(item: item, section: sectionIndex)
            }
        }
      }
    }
    .environment(\.magazineSelection, selection)
  }

  private func getAccessibilityLabel(for item: MagazineItemConfigurator) -> String {
    // Try to extract a meaningful label from the item
    switch item {
    case let articleItem as ArticleItemConfigurator:
      return articleItem.article.title
    case let productItem as ProductItemConfigurator:
      return productItem.product.name
    case let promotionItem as PromotionItemConfigurator:
      return promotionItem.promotion.title
    default:
      return "Magazine item"
    }
  }

  private func trackItemImpression(item: MagazineItemConfigurator, section: Int) {
    // Analytics tracking
    print("Item impression: Section \(section), ID: \(item.id)")
  }
}

enum MagazineLayoutManager {
  static func calculateOptimalLayout(for items: [MagazineItemConfigurator], containerWidth _: CGFloat) -> [MagazineItemConfigurator] {
    return items.sorted { item1, item2 in
      if item1.priority != item2.priority {
        return item1.priority < item2.priority
      }
      return false
    }
  }

  static func adaptLayoutForAccessibility(_ items: [MagazineItemConfigurator]) -> [MagazineItemConfigurator] {
    return items.map { item in
      if UIAccessibility.isVoiceOverRunning {
        return createAccessibleVersion(of: item)
      }
      return item
    }
  }

  private static func createAccessibleVersion(of item: MagazineItemConfigurator) -> MagazineItemConfigurator {
    switch item {
    case let articleItem as ArticleItemConfigurator:
      return ArticleItemConfigurator(
        article: articleItem.article,
        widthMode: .fullWidth, // Force full width for better accessibility
        priority: articleItem.priority
      )
    case let productItem as ProductItemConfigurator:
      return ProductItemConfigurator(
        product: productItem.product,
        widthMode: .halfWidth, // Force half width for products
        priority: productItem.priority
      )
    default:
      return item
    }
  }
}
