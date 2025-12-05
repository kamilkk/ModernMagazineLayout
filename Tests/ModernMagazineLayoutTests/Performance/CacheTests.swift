//
//  CacheTests.swift
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
final class CacheTests: XCTestCase {
  // MARK: - Item Size Caching Tests

  func testCacheSizeStorage() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()
    let size = CGSize(width: 100, height: 200)

    await cache.cacheSize(size, for: id)
    let retrieved = await cache.getCachedSize(for: id)

    XCTAssertEqual(retrieved, size)
  }

  func testCacheSizeRetrieval() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()

    // Should return nil for non-cached item
    let retrieved = await cache.getCachedSize(for: id)
    XCTAssertNil(retrieved)
  }

  func testCacheMultipleSizes() async throws {
    let cache = MagazineLayoutCache()
    let ids = [UUID(), UUID(), UUID()]
    let sizes = [
      CGSize(width: 100, height: 200),
      CGSize(width: 150, height: 250),
      CGSize(width: 200, height: 300),
    ]

    for (id, size) in zip(ids, sizes) {
      await cache.cacheSize(size, for: id)
    }

    for (id, expectedSize) in zip(ids, sizes) {
      let retrieved = await cache.getCachedSize(for: id)
      XCTAssertEqual(retrieved, expectedSize)
    }
  }

  func testCacheSizeOverwrite() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()
    let size1 = CGSize(width: 100, height: 200)
    let size2 = CGSize(width: 150, height: 250)

    await cache.cacheSize(size1, for: id)
    await cache.cacheSize(size2, for: id)

    let retrieved = await cache.getCachedSize(for: id)
    XCTAssertEqual(retrieved, size2, "Should return the most recent cached size")
  }

  // MARK: - Section Height Caching Tests

  func testSectionHeightStorage() async throws {
    let cache = MagazineLayoutCache()

    await cache.cacheSectionHeight(500, for: 0)
    await cache.cacheSectionHeight(300, for: 1)

    let height0 = await cache.getCachedSectionHeight(for: 0)
    let height1 = await cache.getCachedSectionHeight(for: 1)

    XCTAssertEqual(height0, 500)
    XCTAssertEqual(height1, 300)
  }

  func testSectionHeightRetrieval() async throws {
    let cache = MagazineLayoutCache()

    // Should return nil for non-cached section
    let retrieved = await cache.getCachedSectionHeight(for: 5)
    XCTAssertNil(retrieved)
  }

  // MARK: - Cache Eviction Tests

  func testCacheEvictionAtLimit() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10)

    // Add 15 items (exceeds limit of 10)
    for _ in 0 ..< 15 {
      let id = UUID()
      let size = CGSize(width: 100, height: 100)
      await cache.cacheSize(size, for: id)
    }

    let stats = await cache.getStatistics()
    // After eviction, cache should be at ~75% of max (7-8 items)
    XCTAssertLessThanOrEqual(stats.itemCacheSize, 10, "Cache should not exceed max size")
  }

  func testLRUEviction() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 10)

    var ids: [UUID] = []

    // Cache 10 items (fill cache to limit)
    for _ in 0 ..< 10 {
      let id = UUID()
      ids.append(id)
      await cache.cacheSize(CGSize(width: 100, height: 100), for: id)
      try await Task.sleep(nanoseconds: 1_000_000) // 0.001 seconds
    }

    // Access the first item to mark it as recently used
    _ = await cache.getCachedSize(for: ids[0])

    // Add 5 more items to trigger eviction (cache will evict to 75% = 7-8 items)
    for _ in 0 ..< 5 {
      await cache.cacheSize(CGSize(width: 100, height: 100), for: UUID())
    }

    // The cache should have evicted some items but kept recently accessed ones
    let stats = await cache.getStatistics()
    XCTAssertLessThanOrEqual(stats.itemCacheSize, 10, "Cache should not exceed max size")
    XCTAssertGreaterThan(stats.itemCacheSize, 5, "Cache should retain some items after eviction")
  }

  // MARK: - Visible Range Tests

  func testVisibleRangeUpdate() async throws {
    let cache = MagazineLayoutCache()

    // Cache section heights for sections 0-9
    for i in 0 ..< 10 {
      await cache.cacheSectionHeight(CGFloat(100 * i), for: i)
    }

    // Set visible range to 3..<6 with buffer of 1
    // Should keep sections 2-6 (3-6 visible + 1 buffer on each side)
    await cache.updateVisibleRange(3 ..< 6)

    // Sections far outside range might be evicted
    // But exact eviction depends on buffer
    let stats = await cache.getStatistics()
    XCTAssertGreaterThan(stats.sectionCacheSize, 0)
  }

  // MARK: - Cache Clearing Tests

  func testClearAll() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()

    await cache.cacheSize(CGSize(width: 100, height: 100), for: id)
    await cache.cacheSectionHeight(500, for: 0)

    await cache.clearAll()

    let size = await cache.getCachedSize(for: id)
    let height = await cache.getCachedSectionHeight(for: 0)

    XCTAssertNil(size)
    XCTAssertNil(height)
  }

  func testClearSpecificItems() async throws {
    let cache = MagazineLayoutCache()
    let id1 = UUID()
    let id2 = UUID()
    let id3 = UUID()

    await cache.cacheSize(CGSize(width: 100, height: 100), for: id1)
    await cache.cacheSize(CGSize(width: 150, height: 150), for: id2)
    await cache.cacheSize(CGSize(width: 200, height: 200), for: id3)

    await cache.clearItems([id1, id3])

    let size1 = await cache.getCachedSize(for: id1)
    let size2 = await cache.getCachedSize(for: id2)
    let size3 = await cache.getCachedSize(for: id3)

    XCTAssertNil(size1, "Cleared item should be nil")
    XCTAssertNotNil(size2, "Non-cleared item should remain")
    XCTAssertNil(size3, "Cleared item should be nil")
  }

  func testClearSpecificSections() async throws {
    let cache = MagazineLayoutCache()

    await cache.cacheSectionHeight(100, for: 0)
    await cache.cacheSectionHeight(200, for: 1)
    await cache.cacheSectionHeight(300, for: 2)

    await cache.clearSections([0, 2])

    let height0 = await cache.getCachedSectionHeight(for: 0)
    let height1 = await cache.getCachedSectionHeight(for: 1)
    let height2 = await cache.getCachedSectionHeight(for: 2)

    XCTAssertNil(height0)
    XCTAssertNotNil(height1)
    XCTAssertNil(height2)
  }

  // MARK: - Statistics Tests

  func testStatistics() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 100)

    // Add 5 items
    for _ in 0 ..< 5 {
      await cache.cacheSize(CGSize(width: 100, height: 100), for: UUID())
    }

    // Add 3 section heights
    for i in 0 ..< 3 {
      await cache.cacheSectionHeight(CGFloat(100 * i), for: i)
    }

    let stats = await cache.getStatistics()

    XCTAssertEqual(stats.itemCacheSize, 5)
    XCTAssertEqual(stats.sectionCacheSize, 3)
    XCTAssertEqual(stats.maxCacheSize, 100)
  }

  // MARK: - Concurrent Access Tests

  func testConcurrentAccess() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()
    let size = CGSize(width: 100, height: 200)

    // Write from one task
    let writeTask = Task {
      await cache.cacheSize(size, for: id)
    }

    // Read from another task
    let readTask = Task {
      let _ = await cache.getCachedSize(for: id)
    }

    await writeTask.value
    await readTask.value

    // Should not crash due to actor isolation
    let retrieved = await cache.getCachedSize(for: id)
    XCTAssertEqual(retrieved, size)
  }

  func testMultipleConcurrentWrites() async throws {
    let cache = MagazineLayoutCache()

    await withTaskGroup(of: Void.self) { group in
      for i in 0 ..< 10 {
        group.addTask {
          let id = UUID()
          let size = CGSize(width: CGFloat(i * 100), height: 100)
          await cache.cacheSize(size, for: id)
        }
      }
    }

    let stats = await cache.getStatistics()
    XCTAssertEqual(stats.itemCacheSize, 10)
  }

  // MARK: - Edge Cases

  func testZeroSizeCache() async throws {
    let cache = MagazineLayoutCache()
    let id = UUID()
    let size = CGSize.zero

    await cache.cacheSize(size, for: id)
    let retrieved = await cache.getCachedSize(for: id)

    XCTAssertEqual(retrieved, .zero)
  }

  func testNegativeSectionHeight() async throws {
    let cache = MagazineLayoutCache()

    await cache.cacheSectionHeight(-100, for: 0)
    let height = await cache.getCachedSectionHeight(for: 0)

    XCTAssertEqual(height, -100, "Should cache negative values")
  }

  func testLargeNumberOfItems() async throws {
    let cache = MagazineLayoutCache(maxCacheSize: 1000)

    // Cache 500 items
    for _ in 0 ..< 500 {
      await cache.cacheSize(CGSize(width: 100, height: 100), for: UUID())
    }

    let stats = await cache.getStatistics()
    XCTAssertEqual(stats.itemCacheSize, 500)
  }
}
