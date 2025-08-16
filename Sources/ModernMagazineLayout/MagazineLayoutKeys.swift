//
//  MagazineLayoutKeys.swift
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

@available(iOS 17.0, macOS 14.0, *)
public enum MagazineWidthMode {
    case fullWidth
    case halfWidth
    case thirdWidth
    case fractional(CGFloat)
}

@available(iOS 17.0, macOS 14.0, *)
public struct MagazineWidthModeKey: LayoutValueKey {
    public static let defaultValue: MagazineWidthMode? = nil
}

@available(iOS 17.0, macOS 14.0, *)
public struct MagazineSectionKey: LayoutValueKey {
    public static let defaultValue: Int? = nil
}

@available(iOS 17.0, macOS 14.0, *)
public extension View {
    func magazineWidthMode(_ mode: MagazineWidthMode) -> some View {
        layoutValue(key: MagazineWidthModeKey.self, value: mode)
    }
    
    func magazineSection(_ section: Int) -> some View {
        layoutValue(key: MagazineSectionKey.self, value: section)
    }
}