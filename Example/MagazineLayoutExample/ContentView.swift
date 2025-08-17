//
//  ContentView.swift
//  MagazineLayoutExample
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

struct ContentView: View {
    @State private var items = SampleData.items
    
    var body: some View {
        NavigationView {
            MagazineView(
                configuration: ModernMagazineLayout.Configuration(
                    horizontalSpacing: 16,
                    verticalSpacing: 16,
                    sectionSpacing: 24,
                    itemSpacing: 8
                )
            ) {
                ForEach(items) { item in
                    MagazineItem(
                        widthMode: item.widthMode,
                        section: item.section
                    ) {
                        ItemCard(item: item)
                    }
                }
            }
            .navigationTitle("Magazine Layout")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Shuffle") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            items.shuffle()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ItemCard: View {
    let item: SampleItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.color.gradient)
                .frame(height: item.imageHeight)
                .overlay(
                    Text("📸")
                        .font(.largeTitle)
                        .foregroundColor(.white.opacity(0.7))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct SampleItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
    let widthMode: MagazineWidthMode
    let section: Int?
    let imageHeight: CGFloat
}

struct SampleData {
    static let items: [SampleItem] = [
        SampleItem(
            title: "Breaking News",
            subtitle: "Major developments in technology sector continue to shape the future of innovation",
            color: .red,
            widthMode: .fullWidth,
            section: 0,
            imageHeight: 200
        ),
        SampleItem(
            title: "Tech Review",
            subtitle: "Latest gadgets and their impact on daily life",
            color: .blue,
            widthMode: .halfWidth,
            section: 0,
            imageHeight: 120
        ),
        SampleItem(
            title: "Sports Update",
            subtitle: "Championship results and upcoming matches",
            color: .green,
            widthMode: .halfWidth,
            section: 0,
            imageHeight: 120
        ),
        SampleItem(
            title: "Feature Story",
            subtitle: "In-depth analysis of current market trends and their implications for consumers",
            color: .purple,
            widthMode: .thirdWidth,
            section: 1,
            imageHeight: 140
        ),
        SampleItem(
            title: "Quick Tips",
            subtitle: "Simple life hacks for productivity",
            color: .orange,
            widthMode: .thirdWidth,
            section: 1,
            imageHeight: 100
        ),
        SampleItem(
            title: "Weather",
            subtitle: "Weekly forecast and climate updates",
            color: .cyan,
            widthMode: .thirdWidth,
            section: 1,
            imageHeight: 100
        ),
        SampleItem(
            title: "Travel Guide",
            subtitle: "Discover hidden gems and popular destinations around the world",
            color: .indigo,
            widthMode: .fractional(0.6),
            section: 2,
            imageHeight: 160
        ),
        SampleItem(
            title: "Health",
            subtitle: "Wellness tips for better living",
            color: .pink,
            widthMode: .fractional(0.4),
            section: 2,
            imageHeight: 120
        ),
        SampleItem(
            title: "Food & Culture",
            subtitle: "Exploring culinary traditions from around the globe",
            color: .yellow,
            widthMode: .fullWidth,
            section: 3,
            imageHeight: 180
        ),
        SampleItem(
            title: "Art News",
            subtitle: "Gallery openings and exhibitions",
            color: .mint,
            widthMode: .halfWidth,
            section: 3,
            imageHeight: 140
        ),
        SampleItem(
            title: "Music Scene",
            subtitle: "Latest releases and concert reviews",
            color: .teal,
            widthMode: .halfWidth,
            section: 3,
            imageHeight: 140
        )
    ]
}

#Preview {
    ContentView()
}