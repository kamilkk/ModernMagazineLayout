//
//  ModernMagazineLayoutTests.swift
//  ModernMagazineLayoutTests
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

import XCTest
@testable import ModernMagazineLayout

@available(iOS 17.0, macOS 14.0, *)
final class ModernMagazineLayoutTests: XCTestCase {
    
    func testConfigurationInitialization() {
        let config = ModernMagazineLayout.Configuration()
        
        XCTAssertEqual(config.horizontalSpacing, 16)
        XCTAssertEqual(config.verticalSpacing, 16)
        XCTAssertEqual(config.sectionSpacing, 24)
        XCTAssertEqual(config.itemSpacing, 8)
    }
    
    func testCustomConfigurationInitialization() {
        let config = ModernMagazineLayout.Configuration(
            horizontalSpacing: 20,
            verticalSpacing: 30,
            sectionSpacing: 40,
            itemSpacing: 10
        )
        
        XCTAssertEqual(config.horizontalSpacing, 20)
        XCTAssertEqual(config.verticalSpacing, 30)
        XCTAssertEqual(config.sectionSpacing, 40)
        XCTAssertEqual(config.itemSpacing, 10)
    }
    
    func testWidthModeEquality() {
        XCTAssertEqual(MagazineWidthMode.fullWidth, MagazineWidthMode.fullWidth)
        XCTAssertEqual(MagazineWidthMode.halfWidth, MagazineWidthMode.halfWidth)
        XCTAssertEqual(MagazineWidthMode.thirdWidth, MagazineWidthMode.thirdWidth)
        XCTAssertEqual(MagazineWidthMode.fractional(0.5), MagazineWidthMode.fractional(0.5))
        
        XCTAssertNotEqual(MagazineWidthMode.fullWidth, MagazineWidthMode.halfWidth)
        XCTAssertNotEqual(MagazineWidthMode.fractional(0.5), MagazineWidthMode.fractional(0.6))
    }
}

extension MagazineWidthMode: Equatable {
    public static func == (lhs: MagazineWidthMode, rhs: MagazineWidthMode) -> Bool {
        switch (lhs, rhs) {
        case (.fullWidth, .fullWidth),
             (.halfWidth, .halfWidth),
             (.thirdWidth, .thirdWidth):
            return true
        case (.fractional(let lhsFraction), .fractional(let rhsFraction)):
            return lhsFraction == rhsFraction
        default:
            return false
        }
    }
}