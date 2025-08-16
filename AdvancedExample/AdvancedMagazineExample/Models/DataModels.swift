//
//  DataModels.swift
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

struct Article: Identifiable, Codable {
    let id: UUID
    let title: String
    let subtitle: String
    let author: String
    let publishDate: Date
    let imageURL: URL?
    let category: String?
    let isPremium: Bool
    let readingTime: Int
    let tags: [String]
    
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        author: String,
        publishDate: Date,
        imageURL: URL? = nil,
        category: String? = nil,
        isPremium: Bool = false,
        readingTime: Int = 5,
        tags: [String] = []
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.publishDate = publishDate
        self.imageURL = imageURL
        self.category = category
        self.isPremium = isPremium
        self.readingTime = readingTime
        self.tags = tags
    }
}

struct Product: Identifiable, Codable {
    let id: UUID
    let name: String
    let brand: String?
    let price: Double
    let originalPrice: Double?
    let imageURL: URL?
    let rating: Double
    let reviewCount: Int
    let isOnSale: Bool
    let discountPercentage: Int?
    let category: String
    let tags: [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        brand: String? = nil,
        price: Double,
        originalPrice: Double? = nil,
        imageURL: URL? = nil,
        rating: Double = 0.0,
        reviewCount: Int = 0,
        isOnSale: Bool = false,
        discountPercentage: Int? = nil,
        category: String,
        tags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.price = price
        self.originalPrice = originalPrice
        self.imageURL = imageURL
        self.rating = rating
        self.reviewCount = reviewCount
        self.isOnSale = isOnSale
        self.discountPercentage = discountPercentage
        self.category = category
        self.tags = tags
    }
}

struct Promotion: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let backgroundImageURL: URL?
    let type: String?
    let ctaText: String?
    let startDate: Date
    let endDate: Date?
    let isActive: Bool
    let targetURL: URL?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        backgroundImageURL: URL? = nil,
        type: String? = nil,
        ctaText: String? = nil,
        startDate: Date = Date(),
        endDate: Date? = nil,
        isActive: Bool = true,
        targetURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.backgroundImageURL = backgroundImageURL
        self.type = type
        self.ctaText = ctaText
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.targetURL = targetURL
    }
}