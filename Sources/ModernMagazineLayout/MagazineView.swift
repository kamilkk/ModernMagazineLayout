//
//  MagazineView.swift
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
public struct MagazineView<Content: View>: View {
    private let configuration: ModernMagazineLayout.Configuration
    private let content: Content
    
    public init(
        configuration: ModernMagazineLayout.Configuration = ModernMagazineLayout.Configuration(),
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    public var body: some View {
        ScrollView {
            ModernMagazineLayout(configuration: configuration) {
                content
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
public struct MagazineItem<Content: View>: View {
    private let widthMode: MagazineWidthMode
    private let section: Int?
    private let content: Content
    
    public init(
        widthMode: MagazineWidthMode = .fullWidth,
        section: Int? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.widthMode = widthMode
        self.section = section
        self.content = content()
    }
    
    public var body: some View {
        content
            .magazineWidthMode(widthMode)
            .if(section != nil) { view in
                view.magazineSection(section!)
            }
    }
}

@available(iOS 17.0, macOS 14.0, *)
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