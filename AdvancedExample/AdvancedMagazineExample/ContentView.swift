//
//  ContentView.swift
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

import ModernMagazineLayout
import SwiftUI

struct ContentView: View {
  @State private var dataService = MagazineDataService()
  @State private var selection = MagazineSelection<UUID>()

  var body: some View {
    AdvancedMagazineLayoutView(dataService: dataService, selection: selection)
  }
}

struct AdvancedMagazineLayoutView: View {
  let dataService: MagazineDataService
  @Bindable var selection: MagazineSelection<UUID>
  @State private var showingSettings = false

  var body: some View {
    NavigationView {
      Group {
        if dataService.isLoading {
          LoadingView()
        } else {
          AdvancedMagazineView(
            sections: dataService.sections,
            configuration: ModernMagazineLayout.Configuration(
              horizontalSpacing: 16,
              verticalSpacing: 8,
              sectionSpacing: 24,
              itemSpacing: 8
            ),
            selection: selection,
            onSectionHeaderTapped: { sectionIndex in
              print("Header tapped for section \(sectionIndex)")
            },
            onSectionFooterTapped: { sectionIndex in
              print("Footer tapped for section \(sectionIndex)")
            }
          )
        }
      }
      .navigationTitle("Advanced Magazine")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        if selection.isSelectionMode {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              selection.exitSelectionMode()
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Delete (\(selection.selectedItems.count))") {
              deleteSelectedItems()
            }
            .disabled(selection.selectedItems.isEmpty)
          }
        } else {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: {
              selection.isSelectionMode = true
            }) {
              Image(systemName: "checkmark.circle")
            }

            Button(action: {
              withAnimation(.easeInOut(duration: 0.5)) {
                dataService.refreshData()
              }
            }) {
              Image(systemName: "arrow.clockwise")
            }

            Button(action: {
              showingSettings = true
            }) {
              Image(systemName: "gear")
            }
          }
        }
      }
      .refreshable {
        dataService.refreshData()
      }
    }
    .navigationViewStyle(.stack)
    .sheet(isPresented: $showingSettings) {
      SettingsView()
    }
  }

  private func deleteSelectedItems() {
    withAnimation {
      let selectedIds = selection.selectedItems
      for sectionIndex in 0 ..< dataService.sections.count {
        for itemId in selectedIds {
          dataService.removeItem(withId: itemId, fromSectionIndex: sectionIndex)
        }
      }
      selection.exitSelectionMode()
    }
  }
}

struct LoadingView: View {
  var body: some View {
    VStack(spacing: 16) {
      ProgressView()
        .scaleEffect(1.5)
      Text("Loading content...")
        .font(DSTypography.subheadline)
        .foregroundColor(DSColors.textSecondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DSColors.backgroundPrimary)
  }
}

struct SettingsView: View {
  var body: some View {
    NavigationView {
      List {
        Section("Layout Options") {
          HStack {
            Text("Spacing")
            Spacer()
            Text("Dynamic")
              .foregroundColor(DSColors.textSecondary)
          }

          HStack {
            Text("Animation")
            Spacer()
            Text("Enabled")
              .foregroundColor(DSColors.textSecondary)
          }
        }

        Section("Content") {
          HStack {
            Text("Auto-refresh")
            Spacer()
            Text("30 minutes")
              .foregroundColor(DSColors.textSecondary)
          }

          HStack {
            Text("Image Quality")
            Spacer()
            Text("High")
              .foregroundColor(DSColors.textSecondary)
          }
        }

        Section("About") {
          HStack {
            Text("Version")
            Spacer()
            Text("1.0.1")
              .foregroundColor(DSColors.textSecondary)
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  ContentView()
}
