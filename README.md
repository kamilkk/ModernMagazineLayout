# ModernMagazineLayout

A SwiftUI implementation inspired by Airbnb's MagazineLayout, providing flexible magazine-style layouts with dynamic item sizing and modern SwiftUI architecture.

## Features

- ✅ **Flexible Width Modes**: Full width, half width, third width, and fractional width support
- ✅ **Dynamic Height**: Automatic height calculation based on content
- ✅ **Section Support**: Organize content into logical sections
- ✅ **SwiftUI Native**: Built with modern SwiftUI Layout protocol
- ✅ **iOS 17+**: Takes advantage of latest SwiftUI features
- ✅ **Configurable Spacing**: Customizable horizontal, vertical, and section spacing
- ✅ **Design System Integration**: Complete design system with reusable components
- ✅ **Advanced Architecture**: Configurator pattern inspired by professional iOS apps

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ModernMagazineLayout.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. Go to File → Add Package Dependencies
2. Enter the repository URL
3. Select the version range

## Quick Start

```swift
import SwiftUI
import ModernMagazineLayout

struct ContentView: View {
    var body: some View {
        MagazineView {
            MagazineItem(widthMode: .fullWidth) {
                Text("Full Width Item")
                    .frame(height: 100)
                    .background(Color.blue)
            }
            
            MagazineItem(widthMode: .halfWidth) {
                Text("Half Width")
                    .frame(height: 80)
                    .background(Color.green)
            }
            
            MagazineItem(widthMode: .halfWidth) {
                Text("Half Width")
                    .frame(height: 80)
                    .background(Color.orange)
            }
        }
    }
}
```

## Advanced Usage

### Design System Approach

ModernMagazineLayout includes a complete design system with reusable components:

```swift
// Use pre-built cards
ArticleCard(article: article)
ProductCard(product: product)
PromotionCard(promotion: promotion)

// With consistent design tokens
DSColors.primary
DSTypography.headline
```

### Section-Based Layout

Organize content into sections with independent configurations:

```swift
struct MagazineSection {
    let title: String?
    let items: [MagazineItemConfigurator]
    let configuration: SectionConfiguration
}

// Advanced magazine view with sections
AdvancedMagazineView(
    sections: sections,
    configuration: configuration,
    onSectionHeaderTapped: { sectionIndex in
        // Handle section interaction
    }
)
```

### Configurator Pattern

Use the configurator pattern for flexible item management:

```swift
// Article configurator
ArticleItemConfigurator(
    article: article,
    widthMode: .fullWidth,
    priority: 1
)

// Product configurator  
ProductItemConfigurator(
    product: product,
    widthMode: .thirdWidth,
    priority: 3
)
```

### Data Service Integration

Integrate with reactive data services:

```swift
@StateObject private var dataService = MagazineDataService()

var body: some View {
    AdvancedMagazineView(sections: dataService.sections)
        .refreshable {
            dataService.refreshData()
        }
}
```

## Architecture

The architecture is inspired by professional iOS applications like those from ChiliLabs:

### Core Components

1. **ModernMagazineLayout**: SwiftUI Layout implementation
2. **MagazineSection**: Section-based content organization
3. **MagazineItemConfigurator**: Flexible item configuration protocol
4. **Design System**: Consistent typography, colors, and components
5. **Data Services**: Reactive data management with Combine

### Design Patterns

- **Configurator Pattern**: Type-safe item configuration
- **Section-Based Architecture**: Logical content organization
- **Design System**: Consistent visual language
- **Reactive Data Flow**: Combine-based data management
- **Accessibility Support**: Built-in accessibility optimizations

## Example App

The package includes two comprehensive example implementations:

### Advanced Example
- Section-based magazine layout
- Design system components
- Data service integration
- Real-world content types (articles, products, promotions)
- Interactive features (refresh, section headers)

### Simple Example  
- Basic magazine layout demonstration
- Easy to understand implementation
- Perfect for getting started

To run the examples:

1. Navigate to the `Example` folder
2. Open `MagazineLayoutExample.xcodeproj` in Xcode
3. Build and run the project (requires Xcode and iOS 17+ simulator)

**Note**: The example app requires Xcode to build and run. If you don't have Xcode, you can still explore the source code to see usage examples.

## API Reference

### MagazineView

A scrollable container that uses `ModernMagazineLayout` internally.

```swift
MagazineView(
    configuration: ModernMagazineLayout.Configuration = .init(),
    @ViewBuilder content: () -> Content
)
```

### AdvancedMagazineView

Section-based magazine layout with advanced features.

```swift
AdvancedMagazineView(
    sections: [MagazineSection],
    configuration: ModernMagazineLayout.Configuration = .init(),
    onSectionHeaderTapped: ((Int) -> Void)? = nil,
    onSectionFooterTapped: ((Int) -> Void)? = nil
)
```

### MagazineItem

A wrapper for individual layout items.

```swift
MagazineItem(
    widthMode: MagazineWidthMode = .fullWidth,
    section: Int? = nil,
    @ViewBuilder content: () -> Content
)
```

### MagazineItemConfigurator

Protocol for configuring magazine items.

```swift
protocol MagazineItemConfigurator: Identifiable {
    var widthMode: MagazineWidthMode { get }
    var priority: Int { get }
    
    @ViewBuilder
    func buildView() -> AnyView
}
```

### Configuration

Configuration object for customizing layout behavior.

```swift
Configuration(
    horizontalSpacing: CGFloat = 16,   // Outer horizontal padding
    verticalSpacing: CGFloat = 16,     // Outer vertical padding
    sectionSpacing: CGFloat = 24,      // Space between sections
    itemSpacing: CGFloat = 8           // Space between items
)
```

### MagazineWidthMode

Enum defining how items should be sized horizontally.

```swift
enum MagazineWidthMode {
    case fullWidth        // 100% width
    case halfWidth        // 50% width (2 per row)
    case thirdWidth       // 33% width (3 per row)
    case fractional(CGFloat) // Custom fraction (0.0 - 1.0)
}
```

## Design System Components

### Cards
- `ArticleCard`: News and blog content
- `ProductCard`: E-commerce products  
- `PromotionCard`: Marketing promotions

### Typography
- `DSTypography`: Consistent font scales
- Adaptive font sizes
- Accessibility support

### Colors
- `DSColors`: Semantic color system
- Dark mode support
- Category-specific gradients

## Requirements

- iOS 17.0+ / macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

## Migration from UIKit MagazineLayout

If you're migrating from Airbnb's UIKit MagazineLayout:

| UIKit MagazineLayout | ModernMagazineLayout |
|---------------------|----------------------|
| `MagazineLayoutItemSizeMode` | `MagazineWidthMode` |
| `UICollectionViewDelegateMagazineLayout` | `MagazineItemConfigurator` |
| `MagazineLayout.prepare()` | Automatic layout calculation |
| Manual cell registration | Protocol-based configuration |

## Performance Considerations

- **LazyVStack**: Efficient memory usage for large content
- **Section-based rendering**: Only visible sections are calculated
- **Accessibility optimizations**: Automatic layout adjustments for accessibility
- **Image loading**: AsyncImage with placeholder support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by [Airbnb's MagazineLayout](https://github.com/airbnb/MagazineLayout)
- Architecture patterns from [ChiliLabs iOS Design System Example](https://github.com/ChiliLabs/ios_DesignSystemExample)
- Built with SwiftUI's Layout protocol introduced in iOS 16