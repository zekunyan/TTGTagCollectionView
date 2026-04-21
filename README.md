# TTGTagCollectionView

[![Version](https://img.shields.io/cocoapods/v/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![License](https://img.shields.io/cocoapods/l/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)

![Screenshot](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/screen_shot.png)

A flexible tag collection view for iOS — show text tags or fully custom views in a vertically or horizontally scrollable container, with rich layout alignment options and AutoLayout support.

## Features

- **Two view types**: `TextTagCollectionView` for styled text tags, `TagCollectionView` for any custom `UIView`
- **6 alignment modes**: left, center, right, fill by space, fill by width, fill by width except last line
- **Vertical & horizontal** scroll directions with configurable line limits
- **Per-tag customization**: background color, gradient, corner radius (per-corner), border, shadow, padding, size constraints
- **Rich text support** via `NSAttributedString`
- **Selection management**: tap-to-select, selection limit, selected state style
- **AutoLayout friendly**: `intrinsicContentSize` auto-updates; `preferredMaxLayoutWidth` support
- **Accessibility**: auto-detect mode or manual `accessibilityLabel / hint / traits`
- **Swift-first API** with full Objective-C backward compatibility
- **CocoaPods** and **Swift Package Manager** support

## Screenshots

![Alignment Types](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/alignment_type.png)

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15+

## Installation

### Swift Package Manager

In Xcode: **File → Add Package Dependencies**, enter:

```
https://github.com/zekunyan/TTGTagCollectionView.git
```

Or add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/zekunyan/TTGTagCollectionView.git", from: "3.0.0")
]
```

### CocoaPods

```ruby
pod 'TTGTagCollectionView'
```

## Source Structure

```
Sources/TTGTags/
├── Model/
│   ├── TextTag.swift                      # Tag data model (id, content, style, selection)
│   ├── TextTagContent.swift               # Abstract content base class
│   ├── TextTagStringContent.swift         # Plain text content
│   └── TextTagAttributedStringContent.swift  # NSAttributedString content
├── Style/
│   └── TextTagStyle.swift                 # Visual style (background, border, shadow, corner, size)
├── Layout/
│   └── TagCollectionLayout.swift          # Pure layout calculator (no UIKit side effects)
└── View/
    ├── TagCollectionView.swift            # Custom-view tag collection
    ├── TextTagCollectionView.swift        # Text tag collection
    └── Internal/
        ├── TextTagComponentView.swift     # Per-tag rendering view
        └── TextTagGradientLabel.swift     # CAGradientLayer-backed label

Tests/TTGTagsTests/
├── TagCollectionLayoutTests.swift
├── TextTagTests.swift
└── TextTagContentTests.swift
```

---

## Usage

### TextTagCollectionView — text tags

#### Quick start (Swift)

```swift
import TTGTags

let tagView = TextTagCollectionView(frame: CGRect(x: 16, y: 100, width: 320, height: 200))
view.addSubview(tagView)

// Build a tag
let content = TextTagStringContent(text: "Swift")
content.textFont = .boldSystemFont(ofSize: 14)
content.textColor = .white

let style = TextTagStyle()
style.backgroundColor = .systemBlue
style.cornerRadius = 10
style.extraSpace = CGSize(width: 12, height: 8)

// Selected state (optional)
let selectedStyle = TextTagStyle()
selectedStyle.backgroundColor = .systemOrange
selectedStyle.cornerRadius = 10
selectedStyle.extraSpace = CGSize(width: 12, height: 8)

let tag = TextTag(content: content, style: style)
tag.selectedStyle = selectedStyle

tagView.add(tag: tag)
tagView.reload()   // always call after mutations
```

#### Quick start (Objective-C)

```objc
#import <TTGTags/TTGTags-Swift.h>

TTGTextTagCollectionView *tagView = [[TTGTextTagCollectionView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:tagView];

TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:@"Hello"];
TTGTextTagStyle *style = [TTGTextTagStyle new];
style.backgroundColor = UIColor.systemBlueColor;
style.cornerRadius = 10;
style.extraSpace = CGSizeMake(12, 8);

TTGTextTag *tag = [TTGTextTag tagWithContent:content style:style];
[tagView addTag:tag];
[tagView reload];
```

#### Delegate

```swift
tagView.delegate = self

// TextTagCollectionViewDelegate
func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           canTapTag tag: TextTag, at index: Int) -> Bool { true }

func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           didTapTag tag: TextTag, at index: Int) {
    print("tapped: \(tag.rightfulContent.contentAttributedString.string), selected: \(tag.selected)")
}

func textTagCollectionView(_ collectionView: TextTagCollectionView,
                           updateContentSize contentSize: CGSize) {
    // e.g. update a height constraint
}
```

#### Tag model — TextTag

```swift
let tag = TextTag()

// Content & style for normal / selected state
tag.content         = TextTagStringContent(text: "Label")
tag.style           = TextTagStyle()
tag.selectedContent = TextTagStringContent(text: "Selected")   // optional fallback to content copy
tag.selectedStyle   = TextTagStyle()                           // optional fallback to style copy

// Selection
tag.selected = false
tag.onSelectStateChanged = { selected in print(selected) }

// Attach any object
tag.attachment = myModel

// Accessibility
tag.enableAutoDetectAccessibility = true   // auto sets label + traits from content
// or manually:
tag.isAccessibilityElement  = true
tag.accessibilityLabel      = "My tag"
tag.accessibilityHint       = "Double tap to select"
tag.accessibilityTraits     = .button

// Current active content / style (respects selected state)
let activeContent = tag.rightfulContent
let activeStyle   = tag.rightfulStyle
```

#### Content types

```swift
// Plain text
let c1 = TextTagStringContent(text: "Hello")
c1.textFont  = .systemFont(ofSize: 14)
c1.textColor = .darkText

// NSAttributedString
let attrs: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.systemRed,
    .font: UIFont.boldSystemFont(ofSize: 16)
]
let c2 = TextTagAttributedStringContent(
    attributedText: NSAttributedString(string: "Rich", attributes: attrs)
)
```

#### Style properties — TextTagStyle

```swift
let style = TextTagStyle()

// Background
style.backgroundColor = .lightGray

// Gradient background
style.enableGradientBackground        = true
style.gradientBackgroundStartColor    = .systemBlue
style.gradientBackgroundEndColor      = .systemPurple
style.gradientBackgroundStartPoint    = CGPoint(x: 0, y: 0.5)
style.gradientBackgroundEndPoint      = CGPoint(x: 1, y: 0.5)

// Corner (all corners by default; set individual flags for per-corner control)
style.cornerRadius      = 8
style.cornerTopLeft     = true
style.cornerTopRight    = true
style.cornerBottomLeft  = false
style.cornerBottomRight = false

// Border
style.borderWidth = 1
style.borderColor = .white

// Shadow
style.shadowColor   = .black
style.shadowOffset  = CGSize(width: 2, height: 2)
style.shadowRadius  = 2
style.shadowOpacity = 0.3

// Size
style.extraSpace  = CGSize(width: 8, height: 4)   // padding
style.minWidth    = 60      // 0 = no limit
style.maxWidth    = 200
style.exactWidth  = 0       // 0 = auto
style.exactHeight = 32
```

#### Layout configuration

```swift
tagView.scrollDirection  = .vertical     // .vertical (default) or .horizontal
tagView.alignment        = .left         // see Alignment below
tagView.numberOfLines    = 0             // 0 = unlimited
tagView.selectionLimit   = 3             // 0 = unlimited
tagView.horizontalSpacing = 8
tagView.verticalSpacing   = 8
tagView.contentInset      = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

// AutoLayout manual height
tagView.manualCalculateHeight   = true
tagView.preferredMaxLayoutWidth = 320

// Tap callbacks (no delegate needed)
tagView.onTapBlankArea = { point in print("tapped blank at \(point)") }
tagView.onTapAllArea   = { point in print("tapped anywhere at \(point)") }
```

#### Alignment modes

| Swift | Description |
|---|---|
| `.left` | Left-aligned (default) |
| `.center` | Center-aligned |
| `.right` | Right-aligned |
| `.fillByExpandingSpace` | Expand spacing between tags to fill each row |
| `.fillByExpandingWidth` | Expand each tag's width to fill each row |
| `.fillByExpandingWidthExceptLastLine` | Same as above but skip the last row |

#### Mutating tags

```swift
// Add
tagView.add(tag: tag)
tagView.add(tags: [tag1, tag2])

// Insert
tagView.insert(tag: tag, at: 0)
tagView.insert(tags: [tag1, tag2], at: 2)

// Update
tagView.updateTag(at: 0, selected: true)
tagView.updateTag(at: 0, with: newTag)

// Remove
tagView.remove(tag: tag)
tagView.removeTag(byId: tag.tagId)
tagView.removeTag(at: 0)
tagView.removeAllTags()

// Query
let tag  = tagView.getTag(at: 0)
let tags = tagView.getTags(in: NSRange(location: 0, length: 3))
let all      = tagView.allTags()
let selected = tagView.allSelectedTags()
let unselected = tagView.allNotSelectedTags()

// Reload (required after any mutation)
tagView.reload()
```

#### Hit-testing

```swift
let index = tagView.indexOfTag(at: touchPoint)   // NSNotFound if missed
```

---

### TagCollectionView — custom views

Use this when your tags are arbitrary `UIView` subclasses.

#### DataSource & Delegate

```swift
tagCollectionView.dataSource = self
tagCollectionView.delegate   = self

// TagCollectionViewDataSource
func numberOfTags(in tagCollectionView: TagCollectionView) -> Int { items.count }

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       tagViewFor index: Int) -> UIView { myViews[index] }

// TagCollectionViewDelegate
func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       sizeForTagAt index: Int) -> CGSize { myViews[index].frame.size }

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       didSelectTag tagView: UIView, at index: Int) {
    print("selected \(index)")
}

func tagCollectionView(_ tagCollectionView: TagCollectionView,
                       updateContentSize contentSize: CGSize) { }
```

#### Reload

```swift
tagCollectionView.reload()
```

All layout and spacing properties (`scrollDirection`, `alignment`, `numberOfLines`, `horizontalSpacing`, `verticalSpacing`, `contentInset`, `manualCalculateHeight`, `preferredMaxLayoutWidth`) are identical to `TextTagCollectionView`.

---

## Tips

- Always call `reload()` after adding, removing, or updating tags.
- When embedding in a `UITableViewCell`, call `tableView.reloadData()` inside `viewDidAppear` if `UITableViewAutomaticDimension` behaves unexpectedly.
- Use `manualCalculateHeight = true` + `preferredMaxLayoutWidth` when the view's width is not yet determined at layout time (e.g. inside a self-sizing cell).

---

## 3.0 Migration Guide

Version 3.0 rewrites all core sources in Swift. Objective-C class names, selectors, and enum cases are fully preserved via `@objc(TTGXxx)` aliases — existing OC call sites need only one change: replace the old `.h` imports with the Swift-generated umbrella header.

**One-line OC migration:**

```objc
// Before (2.x)
#import <TTGTags/TTGTextTagCollectionView.h>

// After (3.0+)
#import <TTGTags/TTGTags-Swift.h>
```

### Swift API mapping

| 2.x / Objective-C | 3.0 Swift |
|---|---|
| `TTGTagCollectionView` | `TagCollectionView` |
| `TTGTextTagCollectionView` | `TextTagCollectionView` |
| `TTGTextTag` | `TextTag` |
| `TTGTextTagStyle` | `TextTagStyle` |
| `TTGTextTagContent` | `TextTagContent` |
| `TTGTextTagStringContent` | `TextTagStringContent` |
| `TTGTextTagAttributedStringContent` | `TextTagAttributedStringContent` |
| `TTGTagCollectionAlignment` | `TagCollectionAlignment` |
| `TTGTagCollectionScrollDirection` | `TagCollectionScrollDirection` |
| `[tag getRightfulContent]` | `tag.rightfulContent` |
| `[tag getRightfulStyle]` | `tag.rightfulStyle` |
| `[content getContentAttributedString]` | `content.contentAttributedString` |
| `[tagView addTag:]` | `tagView.add(tag:)` |
| `[tagView insertTag:atIndex:]` | `tagView.insert(tag:at:)` |
| `[tagView removeTagAtIndex:]` | `tagView.removeTag(at:)` |
| `[tagView getTagAtIndex:]` | `tagView.getTag(at:)` |
| `[tagView updateTagAtIndex:selected:]` | `tagView.updateTag(at:selected:)` |

### Other changes in 3.0

- Minimum deployment target raised from iOS 11 to **iOS 16**
- `tagId` auto-increment is now thread-safe (`NSLock`)
- Per-corner `UIRectCorner` bitmask bug fixed
- Pure layout calculator `TagCollectionLayout` extracted (fully unit-tested)
- SPM test target added (`Tests/TTGTagsTests`)

---

## Author

zekunyan — zekunyan@163.com

## License

TTGTagCollectionView is available under the MIT license. See the LICENSE file for more info.
