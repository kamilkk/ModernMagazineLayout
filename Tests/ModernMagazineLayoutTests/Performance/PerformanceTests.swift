//
//  PerformanceTests.swift
//  ModernMagazineLayoutTests
//
//  Created by Claude on 05/12/2025.
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

@testable import ModernMagazineLayout
import XCTest

@available(iOS 18.0, macOS 15.0, *)
final class PerformanceTests: XCTestCase {
  // MARK: - Cache Performance Tests

  func testCacheLargeDatasetPerformance() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10000)

    // Cache 1000 items and verify performance
    let start = Date()
    for _ in 0 ..< 1000 {
      let id = UUID()
      let size = CGSize(width: 100, height: 200)
      await cache.cacheSize(size, for: id)
    }
    let duration = Date().timeIntervalSince(start)

    // Should complete within reasonable time (2 seconds for 1000 items)
    XCTAssertLessThan(duration, 2.0, "Caching 1000 items should complete quickly")
  }

  func testCacheRetrievalPerformance() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10000)
    let ids: [UUID] = (0 ..< 1000).map { _ in UUID() }

    // Pre-populate cache
    for id in ids {
      let size = CGSize(width: 100, height: 200)
      await cache.cacheSize(size, for: id)
    }

    // Measure retrieval performance
    let start = Date()
    for id in ids.prefix(100) {
      _ = await cache.getCachedSize(for: id)
    }
    let duration = Date().timeIntervalSince(start)

    // Should complete very quickly (0.5 seconds for 100 retrievals)
    XCTAssertLessThan(duration, 0.5, "Retrieving 100 cached items should be fast")
  }

  func testCacheConcurrentAccessPerformance() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10000)

    let start = Date()
    await withTaskGroup(of: Void.self) { group in
      for i in 0 ..< 100 {
        group.addTask {
          let id = UUID()
          let size = CGSize(width: CGFloat(i * 10), height: 200)
          await cache.cacheSize(size, for: id)
        }
      }
    }
    let duration = Date().timeIntervalSince(start)

    // Should complete quickly even with concurrent access (2 seconds for 100 concurrent writes)
    XCTAssertLessThan(duration, 2.0, "100 concurrent cache writes should complete quickly")
  }

  func testCacheEvictionPerformance() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 100)

    let start = Date()
    // Add 200 items to trigger eviction
    for _ in 0 ..< 200 {
      let id = UUID()
      let size = CGSize(width: 100, height: 200)
      await cache.cacheSize(size, for: id)
    }
    let duration = Date().timeIntervalSince(start)

    // Eviction should not significantly slow down operations (2 seconds for 200 items with eviction)
    XCTAssertLessThan(duration, 2.0, "Cache with eviction should still be performant")
  }

  // MARK: - Viewport Calculator Performance Tests

  func testVisibleSectionsPerformanceSmallDataset() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 50)

    measure {
      _ = MagazineViewportCalculator.visibleSections(
        scrollOffset: 1000,
        viewportHeight: 800,
        sectionHeights: sectionHeights
      )
    }
  }

  func testVisibleSectionsPerformanceLargeDataset() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 10000)

    measure {
      _ = MagazineViewportCalculator.visibleSections(
        scrollOffset: 50000,
        viewportHeight: 800,
        sectionHeights: sectionHeights
      )
    }
  }

  func testSectionYPositionPerformance() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 1000)

    measure {
      for i in stride(from: 0, to: 1000, by: 10) {
        _ = MagazineViewportCalculator.sectionYPosition(
          sectionIndex: i,
          sectionHeights: sectionHeights
        )
      }
    }
  }

  func testSectionAtYPositionPerformance() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 1000)

    measure {
      for y in stride(from: 0, to: 200_000, by: 500) {
        _ = MagazineViewportCalculator.sectionAtYPosition(
          CGFloat(y),
          sectionHeights: sectionHeights
        )
      }
    }
  }

  func testScrollOffsetCalculationPerformance() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 1000)

    measure {
      for i in stride(from: 0, to: 1000, by: 10) {
        _ = MagazineViewportCalculator.scrollOffsetForSection(
          i,
          sectionHeights: sectionHeights,
          position: .center,
          viewportHeight: 800
        )
      }
    }
  }

  // MARK: - Cache Hit/Miss Ratio Tests

  func testCacheHitRatio() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 100)
    var ids: [UUID] = []

    // Populate cache with 50 items
    for _ in 0 ..< 50 {
      let id = UUID()
      ids.append(id)
      await cache.cacheSize(CGSize(width: 100, height: 200), for: id)
    }

    var hits = 0
    var misses = 0

    // Access items - some cached, some not
    for _ in 0 ..< 100 {
      let id = Bool.random() ? ids.randomElement()! : UUID()
      let size = await cache.getCachedSize(for: id)
      if size != nil {
        hits += 1
      } else {
        misses += 1
      }
    }

    let hitRatio = Double(hits) / Double(hits + misses)
    XCTAssertGreaterThan(hitRatio, 0.3, "Cache hit ratio should be reasonable")
  }

  func testCacheEffectivenessWithVisibleRange() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 100)
    var ids: [UUID] = []

    // Cache 200 items across different sections
    for section in 0 ..< 20 {
      for _ in 0 ..< 10 {
        let id = UUID()
        ids.append(id)
        await cache.cacheSize(CGSize(width: 100, height: 200), for: id)
      }
      await cache.cacheSectionHeight(200, for: section)
    }

    // Update visible range to focus on middle sections
    await cache.updateVisibleRange(8 ..< 12)

    let stats = await cache.getStatistics()

    // After focusing on a visible range, cache should maintain reasonable size
    XCTAssertGreaterThan(stats.itemCacheSize, 0, "Cache should retain some items")
    XCTAssertLessThanOrEqual(stats.itemCacheSize, 100, "Cache should respect max size")
  }

  // MARK: - Memory Usage Tests

  func testMemoryBoundsWithLargeCache() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10000)

    // Add 5000 items
    for _ in 0 ..< 5000 {
      await cache.cacheSize(CGSize(width: 100, height: 200), for: UUID())
    }

    let stats = await cache.getStatistics()

    // Cache should not exceed its maximum size
    XCTAssertEqual(stats.itemCacheSize, 5000, "Cache should store all items when under limit")
    XCTAssertEqual(stats.maxCacheSize, 10000, "Max cache size should match initialization")
  }

  func testMemoryBoundsWithEviction() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 100)

    // Add 500 items (triggers eviction)
    for _ in 0 ..< 500 {
      await cache.cacheSize(CGSize(width: 100, height: 200), for: UUID())
    }

    let stats = await cache.getStatistics()

    // Cache should not exceed maximum after eviction
    XCTAssertLessThanOrEqual(stats.itemCacheSize, 100, "Cache should maintain size limit after eviction")
  }

  func testSectionCacheMemoryBounds() async throws {
    let cache = MagazineLayoutCache()

    // Cache 1000 section heights
    for section in 0 ..< 1000 {
      await cache.cacheSectionHeight(CGFloat(section * 100), for: section)
    }

    let stats = await cache.getStatistics()

    // Section cache should grow independently
    XCTAssertEqual(stats.sectionCacheSize, 1000, "Section cache should store all sections")
  }

  // MARK: - Concurrent Access Stress Tests

  func testHighConcurrencyStress() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 1000)

    await withTaskGroup(of: Void.self) { group in
      // 50 concurrent write tasks
      for i in 0 ..< 50 {
        group.addTask {
          for j in 0 ..< 20 {
            let id = UUID()
            let size = CGSize(width: CGFloat(i * 10 + j), height: 200)
            await cache.cacheSize(size, for: id)
          }
        }
      }

      // 50 concurrent read tasks
      for _ in 0 ..< 50 {
        group.addTask {
          for _ in 0 ..< 20 {
            let id = UUID()
            _ = await cache.getCachedSize(for: id)
          }
        }
      }
    }

    let stats = await cache.getStatistics()

    // Should complete without crashing and respect size limits
    XCTAssertLessThanOrEqual(stats.itemCacheSize, 1000, "Cache should maintain bounds under concurrent access")
  }

  func testMixedOperationsConcurrency() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 500)

    await withTaskGroup(of: Void.self) { group in
      // Cache operations
      group.addTask {
        for _ in 0 ..< 100 {
          await cache.cacheSize(CGSize(width: 100, height: 200), for: UUID())
        }
      }

      // Section operations
      group.addTask {
        for section in 0 ..< 100 {
          await cache.cacheSectionHeight(200, for: section)
        }
      }

      // Clear operations
      group.addTask {
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        await cache.clearAll()
      }

      // Statistics access
      group.addTask {
        for _ in 0 ..< 50 {
          _ = await cache.getStatistics()
        }
      }
    }

    // Should complete without crashing
    let finalStats = await cache.getStatistics()
    XCTAssertLessThanOrEqual(finalStats.itemCacheSize, 500)
  }

  // MARK: - Viewport Calculator Accuracy Tests

  func testViewportCalculatorAccuracyWithVariedHeights() {
    let sectionHeights: [CGFloat] = (0 ..< 100).map { _ in CGFloat.random(in: 100 ... 500) }

    for scrollOffset in stride(from: 0, to: 20000, by: 1000) {
      let visible = MagazineViewportCalculator.visibleSections(
        scrollOffset: CGFloat(scrollOffset),
        viewportHeight: 800,
        sectionHeights: sectionHeights
      )

      // Verify that returned range is valid
      XCTAssertGreaterThanOrEqual(visible.lowerBound, 0)
      XCTAssertLessThanOrEqual(visible.upperBound, sectionHeights.count)
      XCTAssertLessThanOrEqual(visible.lowerBound, visible.upperBound)
    }
  }

  func testViewportCalculatorConsistency() {
    let sectionHeights: [CGFloat] = Array(repeating: 200, count: 100)
    let scrollOffset: CGFloat = 5000
    let viewportHeight: CGFloat = 800

    // Call multiple times - should return consistent results
    let result1 = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    let result2 = MagazineViewportCalculator.visibleSections(
      scrollOffset: scrollOffset,
      viewportHeight: viewportHeight,
      sectionHeights: sectionHeights
    )

    XCTAssertEqual(result1, result2, "Viewport calculator should return consistent results")
  }
}
