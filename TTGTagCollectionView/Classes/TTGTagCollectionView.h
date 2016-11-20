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
    TTGTagCollectionAlignmentLeft = 0, // Default
    TTGTagCollectionAlignmentCenter,
    TTGTagCollectionAlignmentRight
};

/**
 * Tags delegate
 */
@protocol TTGTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
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

/**
 * Tags scroll direction, default is vertical
 */
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

/**
 * Tags layout alignment, default is left, only work when scroll vertically
 */
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

/**
 * Number of lines
 */
@property (nonatomic, assign) NSUInteger numberOfLines;

/**
 * Horizontal and Vertical space between tags
 */
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;

/**
 * The true tags content size, readonly
 */
@property (nonatomic, assign, readonly) CGSize contentSize;

/**
 * Tag shadow
 */
@property (nonatomic, strong) UIColor *shadowColor; // Default is [UIColor black]
@property (nonatomic, assign) CGSize shadowOffset; // Default is CGSizeZero
@property (nonatomic, assign) CGFloat shadowRadius; // Default is 0f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.5f

/**
 * Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2)
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 * Reload all tag cells
 */
- (void)reload;

@end
