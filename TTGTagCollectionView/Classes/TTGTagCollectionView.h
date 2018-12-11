//
//  TTGTagCollectionView.h
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import <UIKit/UIKit.h>

@class TTGTagCollectionView;

/**
 * Tags scroll direction
 */
typedef NS_ENUM(NSInteger, TTGTagCollectionScrollDirection) {
    TTGTagCollectionScrollDirectionVertical = 0, // Default
    TTGTagCollectionScrollDirectionHorizontal = 1
};

/**
 * Tags alignment
 */
typedef NS_ENUM(NSInteger, TTGTagCollectionAlignment) {
    TTGTagCollectionAlignmentLeft = 0,                           // Default
    TTGTagCollectionAlignmentCenter,                             // Center
    TTGTagCollectionAlignmentRight,                              // Right
    TTGTagCollectionAlignmentFillByExpandingSpace,               // Expand horizontal spacing and fill
    TTGTagCollectionAlignmentFillByExpandingWidth,               // Expand width and fill
    TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine  // Expand width and fill, except last line
};

/**
 * Tags delegate
 */
@protocol TTGTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (BOOL)tagCollectionView:(TTGTagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end

/**
 * Tags dataSource
 */
@protocol TTGTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end

@interface TTGTagCollectionView : UIView
@property (nonatomic, weak) id <TTGTagCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id <TTGTagCollectionViewDelegate> delegate;

// Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;
// The real number of lines ignoring the numberOfLines value
@property (nonatomic, assign, readonly) NSUInteger actualNumberOfLines;

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

// Tap blank area callback
@property (nonatomic, copy) void (^onTapBlankArea)(CGPoint location);
// Tap all area callback
@property (nonatomic, copy) void (^onTapAllArea)(CGPoint location);

/**
 * Reload all tag cells
 */
- (void)reload;

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
- (NSInteger)indexOfTagAt:(CGPoint)point;

@end
