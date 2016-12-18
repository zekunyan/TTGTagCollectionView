# TTGTagCollectionView

[![CI Status](http://img.shields.io/travis/zekunyan/TTGTagCollectionView.svg?style=flat)](https://travis-ci.org/zekunyan/TTGTagCollectionView)
[![Version](https://img.shields.io/cocoapods/v/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![License](https://img.shields.io/cocoapods/l/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Apps Using](https://img.shields.io/badge/Apps%20Using-%3E%20150-blue.svg)](https://github.com/zekunyan/TTGTagCollectionView)
[![Total Download](https://img.shields.io/badge/Total%20Download-%3E%209948-blue.svg)](https://github.com/zekunyan/TTGTagCollectionView)

![Screenshot](https://github.com/zekunyan/TTGTagCollectionView/raw/master/Resources/screen_shot.png)

## What 

TTGTagCollectionView is useful for showing different size tag views in a vertical or horizontal scrollable view. And if you only want to show text tags, you can use TTGTextTagCollectionView instead, which has more simple api. At the same time, It is highly customizable that many features of the text tag can be configured, like the tag font size and the background color.

## Features
* Both text tag and custom view tag supported.
* Highly customizable
* Vertical and horizontal scrollable
* Support left, center and right aligment
* Support specifying number of lines
* Support Autolayout `intrinsicContentSize` to auto determine height based on content size

## Requirements
iOS 7 and later.

## Installation

### CocoaPods
TTGTagCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTGTagCollectionView"
```

### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `TTGTagCollectionView` by adding it to your `Cartfile`:
```
github "zekunyan/TTGTagCollectionView"
```

## Usage
### TTGTextTagCollectionView
Use TTGTextTagCollectionView to show text tags.

#### Basic usage
```
TTGTextTagCollectionView *tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
[self.view addSubview:tagCollectionView];
[tagCollectionView addTags:@[@"TTG", @"Tag", @"collection", @"view"]];

```

#### Delegate
Conform the `TTGTextTagCollectionViewDelegate` protocol to get callback when you select the tag or content height changes.

```
@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize;
@end
```

#### Customization
```
// Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

// Text
@property (strong, nonatomic) UIFont *tagTextFont;

// Text color
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

// Background color
@property (strong, nonatomic) UIColor *tagBackgroundColor;
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;

// Corner radius
@property (assign, nonatomic) CGFloat tagCornerRadius;
@property (assign, nonatomic) CGFloat tagSelectedCornerRadius;

// Border
@property (assign, nonatomic) CGFloat tagBorderWidth;
@property (assign, nonatomic) CGFloat tagSelectedBorderWidth;
@property (strong, nonatomic) UIColor *tagBorderColor;
@property (strong, nonatomic) UIColor *tagSelectedBorderColor;

// Tag shadow.
@property (nonatomic, copy) UIColor *tagShadowColor;    // Default is [UIColor black]
@property (nonatomic, assign) CGSize tagShadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat tagShadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat tagShadowOpacity; // Default is 0.3f

// Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;

// Each tag extra space in width and height
@property (assign, nonatomic) CGSize tagExtraSpace;

// Horizontal and vertical space between tags, default is 4.
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;
```

#### Config tags

```
// Add tags
- (void)addTag:(NSString *)tag;

- (void)addTags:(NSArray <NSString *> *)tags;

/// Remove tags
- (void)removeTag:(NSString *)tag;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;
```

#### Config tag selection

```
- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected;
```

#### Get tag information

```
- (NSArray <NSString *> *)allTags;

- (NSArray <NSString *> *)allSelectedTags;

- (NSArray <NSString *> *)allNotSelectedTags;
```

#### Reload
You can reload tags programmatically.

```
- (void)reload;
```

### TTGTagCollectionView
Use `TTGTagCollectionView` to show custom tag views.

#### DataSource and Delegate
Just like the UITableView, you must conform and implement the required methods of `TTGTagCollectionViewDelegate` and `TTGTagCollectionViewDataSource` to get `TTGTagCollectionView` work.

**DataSource**

```
@protocol TTGTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end
```

**Delegate**

```
@protocol TTGTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end
```

#### Customization

```
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
```

#### Reload
You can reload tags programmatically.
```
- (void)reload;
```

## Example
For more information, you can download the zip and run the example.

## Author

zekunyan, zekunyan@163.com

## License

TTGTagCollectionView is available under the MIT license. See the LICENSE file for more info.
