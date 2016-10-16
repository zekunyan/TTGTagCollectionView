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
 * Tags scroll direction, default is veritical
 */
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

/**
 * Number of lines for horizontal scroll direction
 */
@property (nonatomic, assign) NSUInteger numberOfLinesForHorizontalScrollDirection;

/**
 * Horizontal space between tags
 */
@property (nonatomic, assign) CGFloat horizontalSpacing;

/**
 * Vertical space between tags
 */
@property (nonatomic, assign) CGFloat verticalSpacing;

/**
 * The true tags content size
 */
@property (nonatomic, assign, readonly) CGSize contentSize;

/**
 * Reload all tag cells
 */
- (void)reload;

@end
