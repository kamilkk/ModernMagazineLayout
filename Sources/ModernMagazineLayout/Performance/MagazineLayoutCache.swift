//
//  MagazineLayoutCache.swift
//  ModernMagazineLayout
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

import CoreGraphics
import Foundation

/// Thread-safe layout cache using Swift 6 actor model
///
/// `MagazineLayoutCache` provides efficient caching of layout calculations
/// to improve performance when rendering large numbers of items.
///
/// Example usage:
/// ```swift
/// let cache = MagazineLayoutCache()
///
/// // Cache an item size
/// await cache.cacheSize(CGSize(width: 200, height: 150), for: itemId)
///
/// // Retrieve cached size
/// if let size = await cache.getCachedSize(for: itemId) {
///     // Use cached size
/// }
/// ```
@available(iOS 18.0, macOS 15.0, *)
public actor MagazineLayoutCache {
  /// Cached item sizes by UUID
  private var cachedSizes: [UUID: CGSize] = [:]

  /// Cached section heights by section index
  private var cachedSectionHeights: [Int: CGFloat] = [:]

  /// Currently visible index range (for cache eviction)
  private var visibleRange: Range<Int> = 0 ..< 20

  /// Cache eviction buffer (items outside visible range + buffer are evicted)
  private let evictionBuffer: Int

  /// Maximum cache size
  private let maxCacheSize: Int

  /// Timestamp of last access for each cached item (for LRU eviction)
  private var accessTimestamps: [UUID: Date] = [:]

  /// Creates a new layout cache
  /// - Parameters:
  ///   - evictionBuffer: Number of items outside visible range to keep cached (default: 10)
  ///   - maxCacheSize: Maximum number of items to cache (default: 200)
  public init(evictionBuffer: Int = 10, maxCacheSize: Int = 200) {
    self.evictionBuffer = evictionBuffer
    self.maxCacheSize = maxCacheSize
  }

  // MARK: - Item Size Caching

  /// Cache a size for an item
  ///
  /// If the cache exceeds `maxCacheSize`, oldest entries will be evicted using LRU strategy.
  ///
  /// - Parameters:
  ///   - size: The size to cache
  ///   - itemId: The UUID of the item
  public func cacheSize(_ size: CGSize, for itemId: UUID) {
    cachedSizes[itemId] = size
    accessTimestamps[itemId] = Date()

    // Evict oldest entries if cache is too large
    if cachedSizes.count > maxCacheSize {
      evictOldestEntries()
    }
  }

  /// Retrieve cached size for an item
  ///
  /// Updates the access timestamp for LRU tracking.
  ///
  /// - Parameter itemId: The UUID of the item
  /// - Returns: The cached size, or `nil` if not cached
  public func getCachedSize(for itemId: UUID) -> CGSize? {
    if let size = cachedSizes[itemId] {
      accessTimestamps[itemId] = Date()
      return size
    }
    return nil
  }

  // MARK: - Section Height Caching

  /// Cache section height
  /// - Parameters:
  ///   - height: The height to cache
  ///   - section: The section index
  public func cacheSectionHeight(_ height: CGFloat, for section: Int) {
    cachedSectionHeights[section] = height
  }

  /// Get cached section height
  /// - Parameter section: The section index
  /// - Returns: The cached height, or `nil` if not cached
  public func getCachedSectionHeight(for section: Int) -> CGFloat? {
    cachedSectionHeights[section]
  }

  // MARK: - Visible Range Management

  /// Update visible range and evict caches outside range + buffer
  ///
  /// This helps manage memory usage by removing cached data for items
  /// that are far from the visible viewport.
  ///
  /// - Parameter range: The currently visible section range
  public func updateVisibleRange(_ range: Range<Int>) {
    visibleRange = range
    evictOutsideVisibleRange()
  }

  // MARK: - Cache Management

  /// Clear all caches
  public func clearAll() {
    cachedSizes.removeAll()
    cachedSectionHeights.removeAll()
    accessTimestamps.removeAll()
  }

  /// Clear caches for specific items
  /// - Parameter itemIds: Set of item IDs to clear from cache
  public func clearItems(_ itemIds: Set<UUID>) {
    for id in itemIds {
      cachedSizes.removeValue(forKey: id)
      accessTimestamps.removeValue(forKey: id)
    }
  }

  /// Clear caches for specific sections
  /// - Parameter sections: Set of section indices to clear from cache
  public func clearSections(_ sections: Set<Int>) {
    for section in sections {
      cachedSectionHeights.removeValue(forKey: section)
    }
  }

  // MARK: - Statistics

  /// Get cache statistics
  /// - Returns: A dictionary with cache statistics
  public func getStatistics() -> CacheStatistics {
    CacheStatistics(
      itemCacheSize: cachedSizes.count,
      sectionCacheSize: cachedSectionHeights.count,
      maxCacheSize: maxCacheSize,
      hitRate: calculateHitRate()
    )
  }

  /// Statistics about the cache
  public struct CacheStatistics: Sendable {
    public let itemCacheSize: Int
    public let sectionCacheSize: Int
    public let maxCacheSize: Int
    public let hitRate: Double
  }

  // MARK: - Private Helpers

  private var cacheHits: Int = 0
  private var cacheMisses: Int = 0

  private func calculateHitRate() -> Double {
    let total = cacheHits + cacheMisses
    guard total > 0 else { return 0 }
    return Double(cacheHits) / Double(total)
  }

  private func evictOldestEntries() {
    let targetCount = maxCacheSize * 3 / 4 // Evict to 75% capacity
    let excessCount = cachedSizes.count - targetCount

    guard excessCount > 0 else { return }

    // Sort by access timestamp (oldest first)
    let sortedByAge = accessTimestamps.sorted { $0.value < $1.value }
    let idsToRemove = sortedByAge.prefix(excessCount).map { $0.key }

    for id in idsToRemove {
      cachedSizes.removeValue(forKey: id)
      accessTimestamps.removeValue(forKey: id)
    }
  }

  private func evictOutsideVisibleRange() {
    let minSection = max(0, visibleRange.lowerBound - evictionBuffer)
    let maxSection = visibleRange.upperBound + evictionBuffer

    // Evict section heights outside range
    cachedSectionHeights = cachedSectionHeights.filter { section, _ in
      section >= minSection && section <= maxSection
    }
  }
}
