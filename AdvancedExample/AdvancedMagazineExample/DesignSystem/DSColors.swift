//
//  DSColors.swift
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

struct DSColors {
    
    static let primary = Color("Primary")
    static let secondary = Color("Secondary")
    static let accent = Color("Accent")
    
    static let backgroundPrimary = Color("BackgroundPrimary")
    static let backgroundSecondary = Color("BackgroundSecondary")
    static let backgroundTertiary = Color("BackgroundTertiary")
    
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textTertiary = Color("TextTertiary")
    
    static let success = Color("Success")
    static let warning = Color("Warning")
    static let error = Color("Error")
    static let info = Color("Info")
    
    static let cardBackground = Color("CardBackground")
    static let cardBorder = Color("CardBorder")
    static let cardShadow = Color("CardShadow")
    
    static let gradient = LinearGradient(
        colors: [primary, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let categoryGradients = [
        "tech": LinearGradient(
            colors: [Color.blue, Color.cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        "lifestyle": LinearGradient(
            colors: [Color.pink, Color.orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        "business": LinearGradient(
            colors: [Color.green, Color.mint],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        "sports": LinearGradient(
            colors: [Color.red, Color.orange],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    ]
}

extension Color {
    init(_ name: String) {
        if let uiColor = UIColor(named: name) {
            self.init(uiColor)
        } else {
            self.init(.label)
        }
    }
}