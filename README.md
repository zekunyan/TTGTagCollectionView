# TTGTagCollectionView

[![CI Status](http://img.shields.io/travis/zekunyan/TTGTagCollectionView.svg?style=flat)](https://travis-ci.org/zekunyan/TTGTagCollectionView)
[![Version](https://img.shields.io/cocoapods/v/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![License](https://img.shields.io/cocoapods/l/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/TTGTagCollectionView.svg?style=flat)](http://cocoapods.org/pods/TTGTagCollectionView)

![Screenshot](http://7nj2iz.com1.z0.glb.clouddn.com/TTGTagCollectionView_screenshot.jpeg)

## What 

TTGTagCollectionView is useful for showing different size tag views in a vertical scrollable view. And if you only want to show text tags, you can use TTGTextTagCollectionView instead, which has more simple api. At the same time, It is highly customizable that many features of the text tag can be configured, like the tag font size and the background color.

## Features
* Both text tag and custom view tag supported.
* Highly customizable
* Vertical scrollable
* Power by UICollectionView
* Support Autolayout `intrinsicContentSize` to auto determine height based on content size

## Requirements
iOS 7 and later.

## Installation

TTGTagCollectionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTGTagCollectionView"
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

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentHeight:(CGFloat)newContentHeight;
@end
```

#### Customization
```
// Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

// Text font
@property (strong, nonatomic) UIFont *tagTextFont;

// Text color
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

// Background color
@property (strong, nonatomic) UIColor *tagBackgroundColor;
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;

// Corner radius
@property (assign, nonatomic) CGFloat tagCornerRadius;
@property (assign, nonatomic) CGFloat tagSelectedCornerRadius; // Default is tagCornerRadius

// Border
@property (assign, nonatomic) CGFloat tagBorderWidth;
@property (assign, nonatomic) CGFloat tagSelectedBorderWidth; // Default is tagBorderWidth
@property (strong, nonatomic) UIColor *tagBorderColor;
@property (strong, nonatomic) UIColor *tagSelectedBorderColor; // Default is tagBorderColor

// Extra space for width and height
@property (assign, nonatomic) CGSize extraSpace;

// Horizontal and veritical space between tags
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content height
@property (assign, nonatomic, readonly) CGFloat contentHeight;
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

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentHeight:(CGFloat)newContentHeight;
@end
```

#### Customization

You can config the horizontal and vertical space between tags.
```
// Space
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content height
@property (assign, nonatomic, readonly) CGFloat contentHeight;
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
