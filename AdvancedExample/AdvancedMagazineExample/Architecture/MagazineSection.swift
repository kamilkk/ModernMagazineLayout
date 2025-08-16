//
//  MagazineSection.swift
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

import SwiftUI
import ModernMagazineLayout

struct MagazineSection: Identifiable {
    let id = UUID()
    let title: String?
    let items: [MagazineItemConfigurator]
    let configuration: SectionConfiguration
    
    struct SectionConfiguration {
        let showHeader: Bool
        let showFooter: Bool
        let showBackground: Bool
        let headerStyle: HeaderStyle
        let backgroundColor: Color
        let spacing: CGFloat
        
        enum HeaderStyle {
            case large
            case medium
            case small
        }
        
        static let `default` = SectionConfiguration(
            showHeader: true,
            showFooter: false,
            showBackground: false,
            headerStyle: .medium,
            backgroundColor: Color(.systemBackground),
            spacing: 16
        )
    }
}

protocol MagazineItemConfigurator: Identifiable where ID == UUID {
    var id: UUID { get }
    var widthMode: MagazineWidthMode { get }
    var priority: Int { get }
    
    @ViewBuilder
    func buildView() -> AnyView
}

struct ArticleItemConfigurator: MagazineItemConfigurator {
    let id = UUID()
    let article: Article
    let widthMode: MagazineWidthMode
    let priority: Int
    
    func buildView() -> AnyView {
        AnyView(ArticleCard(article: article))
    }
}

struct ProductItemConfigurator: MagazineItemConfigurator {
    let id = UUID()
    let product: Product
    let widthMode: MagazineWidthMode
    let priority: Int
    
    func buildView() -> AnyView {
        AnyView(ProductCard(product: product))
    }
}

struct PromotionItemConfigurator: MagazineItemConfigurator {
    let id = UUID()
    let promotion: Promotion
    let widthMode: MagazineWidthMode
    let priority: Int
    
    func buildView() -> AnyView {
        AnyView(PromotionCard(promotion: promotion))
    }
}