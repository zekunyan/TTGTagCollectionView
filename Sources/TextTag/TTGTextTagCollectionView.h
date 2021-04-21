//
//  TTGTextTagCollectionView.h
//  Pods
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTGTagCollectionView.h"
#import "TTGTextTag.h"
#import "TTGTextTagStringContent.h"
#import "TTGTextTagAttributedStringContent.h"

/**
 Highly useful for text tag display.
 */

@class TTGTextTagCollectionView;

/// Delegate
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

/// Main Class
@interface TTGTextTagCollectionView : UIView
/// Delegate
@property (weak, nonatomic) id <TTGTextTagCollectionViewDelegate> delegate;

/// Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/// Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

/// Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

/// Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

/// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;
/// The real number of lines ignoring the numberOfLines value
@property (nonatomic, assign, readonly) NSUInteger actualNumberOfLines;

/// Tag selection limit, default is 0, means no limit
@property (nonatomic, assign) NSUInteger selectionLimit;

/// Horizontal and vertical space between tags, default is 4.
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

/// Content inset, like padding, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

/// Manual content height
/// Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
/// Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

/// Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/// Tap blank area callback
@property (nonatomic, copy) void (^onTapBlankArea)(CGPoint location);
/// Tap all area callback
@property (nonatomic, copy) void (^onTapAllArea)(CGPoint location);

/// Reload
- (void)reload;

/// Add
- (void)addTag:(TTGTextTag *)tag;
- (void)addTags:(NSArray <TTGTextTag *> *)tags;

/// Insert
- (void)insertTag:(TTGTextTag *)tag atIndex:(NSUInteger)index;
- (void)insertTags:(NSArray <TTGTextTag *> *)tags atIndex:(NSUInteger)index;

/// Update
- (void)updateTagAtIndex:(NSUInteger)index selected:(BOOL)selected;
- (void)updateTagAtIndex:(NSUInteger)index withNewTag:(TTGTextTag *)tag;

/// Remove
- (void)removeTag:(TTGTextTag *)tag;
- (void)removeTagById:(NSUInteger)tagId;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;

/// Get tag
- (TTGTextTag *)getTagAtIndex:(NSUInteger)index;
- (NSArray <TTGTextTag *> *)getTagsInRange:(NSRange)range;

/// Get all
- (NSArray <TTGTextTag *> *)allTags;
- (NSArray <TTGTextTag *> *)allSelectedTags;
- (NSArray <TTGTextTag *> *)allNotSelectedTags;

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
- (NSInteger)indexOfTagAtPoint:(CGPoint)point;

@end
