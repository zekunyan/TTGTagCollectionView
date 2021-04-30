# TTGTagCollectionView

[![CI Status](http://img.shields.io/travis/zekunyan/TTGTagCollectionView.svg?style=flat)](https://travis-ci.org/zekunyan/TTGTagCollectionView)
[![Version](https://img.shields.io/cocoapods/v/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![License](https://img.shields.io/cocoapods/l/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Apps Using](https://img.shields.io/badge/Apps%20Using-%3E%201,096-blue.svg)](https://github.com/zekunyan/TTGTagCollectionView)
[![Total Download](https://img.shields.io/badge/Total%20Download-%3E%2068,461-blue.svg)](https://github.com/zekunyan/TTGTagCollectionView)

![Screenshot](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/screen_shot.png)

![Alignment Type](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/alignment_type.png)

## What

`TTGTagCollectionView` is useful for showing different size tag views in a vertical or horizontal scrollable view. And if you only want to show text tags, you can use `TTGTextTagCollectionView` instead, which has more simple api. At the same time, It is highly customizable that many features of the text tag can be configured, like the tag font size and the background color.

## Features

* Both rich style text tag and custom view tag supported.
* Highly customizable, each text tag can be configured.
* Vertical and horizontal scrollable.
* Support `NSAttributedString` rich text tag.
* Support different kinds of alignment types.
* Support specifying number of lines.
* Support Autolayout `intrinsicContentSize` to auto determine height based on content size.
* Support pull to refresh, like `SVPullToRefresh`.
* Use `preferredMaxLayoutWidth` to set available width like UIlabel.

## Demo

You can find demos in the `Example->TTGTagCollectionView.xcworkspace` project.
Run `pod update` before try it.

![Example project](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/demo_example.jpeg)

## Code Structure

![Example project](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/code_structure.png)

## Requirements

iOS 9 and later.

## Installation

### CocoaPods for Objective-C

TTGTagCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTGTagCollectionView"
```

### CocoaPods for Swift

```ruby
use_frameworks!
pod "TTGTagCollectionView"
```

## Usage

### TTGTextTagCollectionView

Use `TTGTextTagCollectionView` to show text tags.

#### Basic usage

```Objective-C
// Create TTGTextTagCollectionView view
TTGTextTagCollectionView *tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
[self.view addSubview:tagCollectionView];
// Create TTGTextTag object
TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:@"Some text"] style:[TTGTextTagStyle new]];
// Add tag
[tagCollectionView addTag:textTag];
```

#### Delegate

Conform the `TTGTextTagCollectionViewDelegate` protocol to get callback when you select the tag or content height changes.

```Objective-C
@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
            updateContentSize:(CGSize)contentSize;
@end
```

#### Customization

Each tag can be configured.

```Objective-C
@interface TTGTextTag : NSObject <NSCopying>

/// ID
@property (nonatomic, assign, readonly) NSUInteger tagId; // Auto increase. The only identifier and main key for a tag

/// Attachment object. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) id _Nullable attachment;

/// Normal state content and style
@property (nonatomic, copy) TTGTextTagContent * _Nonnull content;
@property (nonatomic, copy) TTGTextTagStyle * _Nonnull style;

/// Selected state content and style
@property (nonatomic, copy) TTGTextTagContent * _Nullable selectedContent;
@property (nonatomic, copy) TTGTextTagStyle * _Nullable selectedStyle;

/// Selection state
@property (nonatomic, assign) BOOL selected;

///...Other things...

@end
```

`TTGTextTagContent` has two sub classes.

```Objective-C
// Normal Text
@interface TTGTextTagStringContent : TTGTextTagContent
/// Text
@property (nonatomic, copy) NSString * _Nonnull text;
/// Text font
@property (nonatomic, copy) UIFont * _Nonnull textFont;
/// Text color
@property (nonatomic, copy) UIColor * _Nonnull textColor;
@end

// NSAttributedString Text
@interface TTGTextTagAttributedStringContent : TTGTextTagContent
/// Attributed text
@property (nonatomic, copy) NSAttributedString * _Nonnull attributedText;
@end
```

Config `TTGTextTagStyle` if you want to change tag styles.

```Objective-C
@interface TTGTextTagStyle : NSObject <NSCopying>

/// Background color
@property (nonatomic, copy) UIColor * _Nonnull backgroundColor; // Default is [UIColor lightGrayColor]

/// Text alignment
@property (nonatomic, assign) NSTextAlignment textAlignment; // Default is NSTextAlignmentCenter

/// Gradient background color
@property (nonatomic, assign) BOOL enableGradientBackground; // Default is NO
@property (nonatomic, copy) UIColor * _Nonnull gradientBackgroundStartColor;
@property (nonatomic, copy) UIColor * _Nonnull gradientBackgroundEndColor;
@property (nonatomic, assign) CGPoint gradientBackgroundStartPoint;
@property (nonatomic, assign) CGPoint gradientBackgroundEndPoint;

/// Corner radius
@property (nonatomic, assign) CGFloat cornerRadius; // Default is 4
@property (nonatomic, assign) Boolean cornerTopRight;
@property (nonatomic, assign) Boolean cornerTopLeft;
@property (nonatomic, assign) Boolean cornerBottomRight;
@property (nonatomic, assign) Boolean cornerBottomLeft;

/// Border
@property (nonatomic, assign) CGFloat borderWidth; // Default is [UIColor whiteColor]
@property (nonatomic, copy) UIColor * _Nonnull borderColor; // Default is 1

/// Shadow.
@property (nonatomic, copy) UIColor * _Nonnull shadowColor;    // Default is [UIColor blackColor]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

/// Extra space in width and height, will expand each tag's size
@property (nonatomic, assign) CGSize extraSpace;

/// Max width for a text tag. 0 and below means no max width.
@property (nonatomic, assign) CGFloat maxWidth;
/// Min width for a text tag. 0 and below means no min width.
@property (nonatomic, assign) CGFloat minWidth;

/// Max height for a text tag. 0 and below means no max height.
@property (nonatomic, assign) CGFloat maxHeight;
/// Min height for a text tag. 0 and below means no min height.
@property (nonatomic, assign) CGFloat minHeight;

/// Exact width. 0 and below means no work
@property (nonatomic, assign) CGFloat exactWidth;
/// Exact height. 0 and below means no work
@property (nonatomic, assign) CGFloat exactHeight;

@end
```

You can also configure scroll direction, alignment, lines limit, spacing and inset.

```Objective-C
// TTGTextTagCollectionView.h
// Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

// Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;

// Tag selection limit, default is 0, means no limit
@property (nonatomic, assign) NSUInteger selectionLimit;

// Horizontal and vertical space between tags, default is 4.
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

// Manual content height
// Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
// Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

// Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;
```

Alignment types:

```Objective-C
typedef NS_ENUM(NSInteger, TTGTagCollectionAlignment) {
    TTGTagCollectionAlignmentLeft = 0,                           // Default
    TTGTagCollectionAlignmentCenter,                             // Center
    TTGTagCollectionAlignmentRight,                              // Right
    TTGTagCollectionAlignmentFillByExpandingSpace,               // Expand horizontal spacing and fill
    TTGTagCollectionAlignmentFillByExpandingWidth,               // Expand width and fill
    TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine, // Expand width and fill, except last line
};
```

#### Modify tags

Add tag.

```Objective-C
// TTGTextTagCollectionView.h
/// Add
- (void)addTag:(TTGTextTag *)tag;
- (void)addTags:(NSArray <TTGTextTag *> *)tags;
```

Insert tag.

```Objective-C
// TTGTextTagCollectionView.h
/// Insert
- (void)insertTag:(TTGTextTag *)tag atIndex:(NSUInteger)index;
- (void)insertTags:(NSArray <TTGTextTag *> *)tags atIndex:(NSUInteger)index;
```

Update tag.

```Objective-C
// TTGTextTagCollectionView.h
/// Update
- (void)updateTagAtIndex:(NSUInteger)index selected:(BOOL)selected;
- (void)updateTagAtIndex:(NSUInteger)index withNewTag:(TTGTextTag *)tag;
```

Remove tag.

```Objective-C
// TTGTextTagCollectionView.h
// Remove tag
- (void)removeTag:(TTGTextTag *)tag;
- (void)removeTagById:(NSUInteger)tagId;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;
```

Get tags.

```Objective-C
// TTGTextTagCollectionView.h
/// Get tag
- (TTGTextTag *)getTagAtIndex:(NSUInteger)index;
- (NSArray <TTGTextTag *> *)getTagsInRange:(NSRange)range;

/// Get all
- (NSArray <TTGTextTag *> *)allTags;
- (NSArray <TTGTextTag *> *)allSelectedTags;
- (NSArray <TTGTextTag *> *)allNotSelectedTags;
```

#### Reload

You can reload tags programmatically.

```Objective-C
// TTGTextTagCollectionView.h
- (void)reload;
```

#### Index at point

Returns the index of the tag located at the specified point.

```Objective-C
// TTGTextTagCollectionView.h
- (NSInteger)indexOfTagAt:(CGPoint)point;
```

### TTGTagCollectionView

Use `TTGTagCollectionView` to show custom tag views.

#### DataSource and Delegate

Just like the UITableView, you must conform and implement the required methods of `TTGTagCollectionViewDelegate` and `TTGTagCollectionViewDataSource` to get `TTGTagCollectionView` work.

**DataSource**

```Objective-C
@protocol TTGTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end
```

**Delegate**

```Objective-C
@protocol TTGTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (BOOL)tagCollectionView:(TTGTagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end
```

#### Customization

```Objective-C
// TTGTagCollectionView.h
// Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;

// Horizontal and vertical space between tags, default is 4.
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

// Manual content height
// Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
// Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

// Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;
```

#### Reload

You can reload tags programmatically.

```Objective-C
// TTGTagCollectionView.h
- (void)reload;
```

#### Index at point

Returns the index of the tag located at the specified point.

```Objective-C
// TTGTagCollectionView.h
- (NSInteger)indexOfTagAt:(CGPoint)point;
```

## Fix

`UITableViewAutomaticDimension` may not work when using tagView in tableViewCell. You should reload your tableView in the `viewDidAppear`.

## Author

zekunyan, zekunyan@163.com

## License

TTGTagCollectionView is available under the MIT license. See the LICENSE file for more info.
