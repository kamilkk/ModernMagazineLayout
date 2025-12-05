//
//  MagazineDataService.swift
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

import Foundation
import ModernMagazineLayout

@Observable
@MainActor
class MagazineDataService {
  var sections: [MagazineSection] = []
  var isLoading = false
  var error: Error?

  init() {
    loadInitialData()
  }

  func loadInitialData() {
    isLoading = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.sections = self.generateSampleSections()
      self.isLoading = false
    }
  }

  func refreshData() {
    loadInitialData()
  }

  func addItemToSection(_ item: any MagazineItemConfigurator, sectionIndex: Int) {
    guard sectionIndex < sections.count else { return }

    let section = sections[sectionIndex]
    var items = section.items
    items.append(item)

    sections[sectionIndex] = MagazineSection(
      title: section.title,
      items: items,
      configuration: section.configuration
    )
  }

  func removeItem(withId id: UUID, fromSectionIndex sectionIndex: Int) {
    guard sectionIndex < sections.count else { return }

    let section = sections[sectionIndex]
    var items = section.items
    items.removeAll { $0.id == id }

    sections[sectionIndex] = MagazineSection(
      title: section.title,
      items: items,
      configuration: section.configuration
    )
  }

  func updateSectionConfiguration(_ configuration: MagazineSection.SectionConfiguration, forSectionIndex index: Int) {
    guard index < sections.count else { return }

    let section = sections[index]
    sections[index] = MagazineSection(
      title: section.title,
      items: section.items,
      configuration: configuration
    )
  }
}

extension MagazineDataService {
  private func generateSampleSections() -> [MagazineSection] {
    return [
      createFeaturedSection(),
      createNewsSection(),
      createProductsSection(),
      createPromotionsSection(),
      createLifestyleSection(),
    ]
  }

  private func createFeaturedSection() -> MagazineSection {
    let articles = SampleData.generateFeaturedArticles()
    let items = articles.map { article in
      ArticleItemConfigurator(
        article: article,
        widthMode: .fullWidth,
        priority: 1
      )
    }

    return MagazineSection(
      title: "Featured Stories",
      items: items,
      configuration: MagazineSection.SectionConfiguration(
        showHeader: true,
        showFooter: false,
        showBackground: true,
        headerStyle: .large,
        backgroundColor: DSColors.backgroundSecondary,
        spacing: 20
      )
    )
  }

  private func createNewsSection() -> MagazineSection {
    let articles = SampleData.generateNewsArticles()
    let items = articles.enumerated().map { index, article in
      ArticleItemConfigurator(
        article: article,
        widthMode: index == 0 ? .fullWidth : .halfWidth,
        priority: index == 0 ? 1 : 2
      )
    }

    return MagazineSection(
      title: "Latest News",
      items: items,
      configuration: .default
    )
  }

  private func createProductsSection() -> MagazineSection {
    let products = SampleData.generateProducts()
    let items = products.map { product in
      ProductItemConfigurator(
        product: product,
        widthMode: .thirdWidth,
        priority: 3
      )
    }

    return MagazineSection(
      title: "Trending Products",
      items: items,
      configuration: MagazineSection.SectionConfiguration(
        showHeader: true,
        showFooter: true,
        showBackground: false,
        headerStyle: .medium,
        backgroundColor: DSColors.backgroundPrimary,
        spacing: 12
      )
    )
  }

  private func createPromotionsSection() -> MagazineSection {
    let promotions = SampleData.generatePromotions()
    let items = promotions.map { promotion in
      PromotionItemConfigurator(
        promotion: promotion,
        widthMode: .fullWidth,
        priority: 1
      )
    }

    return MagazineSection(
      title: nil,
      items: items,
      configuration: MagazineSection.SectionConfiguration(
        showHeader: false,
        showFooter: false,
        showBackground: false,
        headerStyle: .medium,
        backgroundColor: DSColors.backgroundPrimary,
        spacing: 16
      )
    )
  }

  private func createLifestyleSection() -> MagazineSection {
    let articles = SampleData.generateLifestyleArticles()
    let items = articles.enumerated().map { index, article in
      ArticleItemConfigurator(
        article: article,
        widthMode: index % 3 == 0 ? .fractional(0.6) : .fractional(0.4),
        priority: index % 3 == 0 ? 1 : 2
      )
    }

    return MagazineSection(
      title: "Lifestyle",
      items: items,
      configuration: MagazineSection.SectionConfiguration(
        showHeader: true,
        showFooter: false,
        showBackground: false,
        headerStyle: .medium,
        backgroundColor: DSColors.backgroundPrimary,
        spacing: 16
      )
    )
  }
}
