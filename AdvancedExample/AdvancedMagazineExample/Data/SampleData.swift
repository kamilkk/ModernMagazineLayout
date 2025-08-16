//
//  SampleData.swift
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

struct SampleData {
    
    static func generateFeaturedArticles() -> [Article] {
        return [
            Article(
                title: "The Future of AI in Mobile Development",
                subtitle: "Exploring how artificial intelligence is revolutionizing the way we build mobile applications",
                author: "Sarah Chen",
                publishDate: Date().addingTimeInterval(-3600),
                imageURL: URL(string: "https://picsum.photos/800/600?random=1"),
                category: "tech",
                isPremium: true,
                readingTime: 8,
                tags: ["AI", "Mobile", "Development"]
            ),
            Article(
                title: "Sustainable Living: Small Changes, Big Impact",
                subtitle: "Simple lifestyle modifications that can help reduce your environmental footprint",
                author: "Marcus Green",
                publishDate: Date().addingTimeInterval(-7200),
                imageURL: URL(string: "https://picsum.photos/800/600?random=2"),
                category: "lifestyle",
                isPremium: false,
                readingTime: 6,
                tags: ["Sustainability", "Environment", "Lifestyle"]
            )
        ]
    }
    
    static func generateNewsArticles() -> [Article] {
        return [
            Article(
                title: "Breaking: New Climate Agreement Reached",
                subtitle: "World leaders unite on unprecedented environmental action plan",
                author: "Emma Thompson",
                publishDate: Date().addingTimeInterval(-1800),
                imageURL: URL(string: "https://picsum.photos/600/400?random=3"),
                category: "news",
                isPremium: false,
                readingTime: 4,
                tags: ["Climate", "Politics", "Environment"]
            ),
            Article(
                title: "Tech Giant Announces Revolutionary Chip",
                subtitle: "New processor promises 50% better performance with reduced power consumption",
                author: "Alex Rodriguez",
                publishDate: Date().addingTimeInterval(-3600),
                imageURL: URL(string: "https://picsum.photos/600/400?random=4"),
                category: "tech",
                isPremium: false,
                readingTime: 5,
                tags: ["Technology", "Hardware", "Innovation"]
            ),
            Article(
                title: "Market Analysis: Q4 Growth Trends",
                subtitle: "Financial experts weigh in on the latest market developments",
                author: "Jennifer Walsh",
                publishDate: Date().addingTimeInterval(-5400),
                imageURL: URL(string: "https://picsum.photos/600/400?random=5"),
                category: "business",
                isPremium: true,
                readingTime: 7,
                tags: ["Finance", "Market", "Analysis"]
            ),
            Article(
                title: "Olympic Preparations Underway",
                subtitle: "Athletes gear up for the upcoming summer games",
                author: "Mike Johnson",
                publishDate: Date().addingTimeInterval(-7200),
                imageURL: URL(string: "https://picsum.photos/600/400?random=6"),
                category: "sports",
                isPremium: false,
                readingTime: 3,
                tags: ["Olympics", "Sports", "Athletes"]
            )
        ]
    }
    
    static func generateProducts() -> [Product] {
        return [
            Product(
                name: "Wireless Noise-Canceling Headphones",
                brand: "AudioTech",
                price: 199.99,
                originalPrice: 249.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=10"),
                rating: 4.5,
                reviewCount: 1250,
                isOnSale: true,
                discountPercentage: 20,
                category: "electronics",
                tags: ["Audio", "Wireless", "Premium"]
            ),
            Product(
                name: "Organic Cotton T-Shirt",
                brand: "EcoWear",
                price: 29.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=11"),
                rating: 4.2,
                reviewCount: 567,
                isOnSale: false,
                category: "clothing",
                tags: ["Organic", "Cotton", "Sustainable"]
            ),
            Product(
                name: "Smart Water Bottle",
                brand: "HydroTech",
                price: 79.99,
                originalPrice: 99.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=12"),
                rating: 4.0,
                reviewCount: 234,
                isOnSale: true,
                discountPercentage: 20,
                category: "lifestyle",
                tags: ["Smart", "Health", "Hydration"]
            ),
            Product(
                name: "Mechanical Keyboard",
                brand: "KeyCraft",
                price: 149.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=13"),
                rating: 4.8,
                reviewCount: 892,
                isOnSale: false,
                category: "electronics",
                tags: ["Gaming", "Mechanical", "RGB"]
            ),
            Product(
                name: "Bamboo Phone Case",
                brand: "EcoProtect",
                price: 24.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=14"),
                rating: 4.3,
                reviewCount: 156,
                isOnSale: false,
                category: "accessories",
                tags: ["Bamboo", "Eco-friendly", "Protection"]
            ),
            Product(
                name: "Fitness Tracker Pro",
                brand: "FitLife",
                price: 299.99,
                originalPrice: 349.99,
                imageURL: URL(string: "https://picsum.photos/400/400?random=15"),
                rating: 4.6,
                reviewCount: 2100,
                isOnSale: true,
                discountPercentage: 15,
                category: "fitness",
                tags: ["Fitness", "Health", "Tracking"]
            )
        ]
    }
    
    static func generatePromotions() -> [Promotion] {
        return [
            Promotion(
                title: "Black Friday Sale",
                description: "Up to 70% off on selected items. Limited time offer!",
                backgroundImageURL: URL(string: "https://picsum.photos/800/400?random=20"),
                type: "Sale",
                ctaText: "Shop Now",
                startDate: Date(),
                endDate: Date().addingTimeInterval(86400 * 7), // 7 days
                isActive: true,
                targetURL: URL(string: "https://example.com/sale")
            ),
            Promotion(
                title: "Premium Membership",
                description: "Get exclusive access to premium content and early releases",
                backgroundImageURL: URL(string: "https://picsum.photos/800/400?random=21"),
                type: "Premium",
                ctaText: "Join Now",
                startDate: Date(),
                endDate: nil,
                isActive: true,
                targetURL: URL(string: "https://example.com/premium")
            )
        ]
    }
    
    static func generateLifestyleArticles() -> [Article] {
        return [
            Article(
                title: "Mindfulness in the Digital Age",
                subtitle: "Finding balance in our connected world",
                author: "Lisa Chen",
                publishDate: Date().addingTimeInterval(-10800),
                imageURL: URL(string: "https://picsum.photos/600/400?random=30"),
                category: "lifestyle",
                isPremium: false,
                readingTime: 6,
                tags: ["Mindfulness", "Digital", "Wellness"]
            ),
            Article(
                title: "Home Workout Essentials",
                subtitle: "Build an effective home gym on any budget",
                author: "Tom Wilson",
                publishDate: Date().addingTimeInterval(-14400),
                imageURL: URL(string: "https://picsum.photos/600/400?random=31"),
                category: "fitness",
                isPremium: false,
                readingTime: 5,
                tags: ["Fitness", "Home", "Budget"]
            ),
            Article(
                title: "Plant-Based Cooking Made Easy",
                subtitle: "Delicious recipes for beginners",
                author: "Maria Garcia",
                publishDate: Date().addingTimeInterval(-18000),
                imageURL: URL(string: "https://picsum.photos/600/400?random=32"),
                category: "lifestyle",
                isPremium: true,
                readingTime: 8,
                tags: ["Cooking", "Plant-based", "Recipes"]
            ),
            Article(
                title: "Travel Photography Tips",
                subtitle: "Capture memories like a pro",
                author: "David Kim",
                publishDate: Date().addingTimeInterval(-21600),
                imageURL: URL(string: "https://picsum.photos/600/400?random=33"),
                category: "lifestyle",
                isPremium: false,
                readingTime: 4,
                tags: ["Photography", "Travel", "Tips"]
            ),
            Article(
                title: "Sustainable Fashion Brands",
                subtitle: "Ethical choices for conscious consumers",
                author: "Sophie Brown",
                publishDate: Date().addingTimeInterval(-25200),
                imageURL: URL(string: "https://picsum.photos/600/400?random=34"),
                category: "lifestyle",
                isPremium: false,
                readingTime: 7,
                tags: ["Fashion", "Sustainable", "Ethical"]
            )
        ]
    }
}