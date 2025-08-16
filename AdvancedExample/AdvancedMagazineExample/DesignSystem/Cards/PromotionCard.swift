//
//  PromotionCard.swift
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

struct PromotionCard: View {
    let promotion: Promotion
    
    var body: some View {
        ZStack {
            AsyncImageView(url: promotion.backgroundImageURL)
                .aspectRatio(2, contentMode: .fill)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.black.opacity(0.3), Color.black.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if let type = promotion.type {
                        PromotionTypeTag(type: type)
                    }
                    Spacer()
                    if let endDate = promotion.endDate {
                        CountdownTimer(endDate: endDate)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(promotion.title)
                        .font(DSTypography.title3)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(promotion.description)
                        .font(DSTypography.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    if let ctaText = promotion.ctaText {
                        Button(action: {
                            // Handle CTA action
                        }) {
                            Text(ctaText)
                                .font(DSTypography.buttonMedium)
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: DSColors.cardShadow.opacity(0.15),
            radius: 6,
            x: 0,
            y: 3
        )
        .onTapGesture {
            // Handle promotion tap
        }
    }
}

struct PromotionTypeTag: View {
    let type: String
    
    var body: some View {
        Text(type.uppercased())
            .font(DSTypography.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(DSColors.accent.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct CountdownTimer: View {
    let endDate: Date
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        if timeRemaining > 0 {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption2)
                Text(timeString)
                    .font(DSTypography.caption2)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.red.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .onAppear {
                updateTimeRemaining()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    updateTimeRemaining()
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private var timeString: String {
        let hours = Int(timeRemaining) / 3600
        let minutes = Int(timeRemaining) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func updateTimeRemaining() {
        timeRemaining = max(0, endDate.timeIntervalSinceNow)
    }
}