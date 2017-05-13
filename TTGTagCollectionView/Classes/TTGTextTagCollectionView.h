//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

/// TTGTextTagConfig

@interface TTGTextTagConfig : NSObject
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

// Tag extra space in width and height, will expand each tag's size
@property (assign, nonatomic) CGSize tagExtraSpace;
@end

/// TTGTextTagCollectionView

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView canTapTag:(NSString *)tagText atIndex:(NSUInteger)index currentSelected:(BOOL)currentSelected;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize;
@end

@interface TTGTextTagCollectionView : UIView
// Delegate
@property (weak, nonatomic) id <TTGTextTagCollectionViewDelegate> delegate;

// Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

// Default tag config
@property (nonatomic, strong) TTGTextTagConfig *defaultConfig;

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

// Content inset, like padding, default is UIEdgeInsetsMake(2, 2, 2, 2).
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

// Reload
- (void)reload;

// Add tag with detalt config
- (void)addTag:(NSString *)tag;

- (void)addTags:(NSArray <NSString *> *)tags;

// Add tag with custom config
- (void)addTag:(NSString *)tag withConfig:(TTGTextTagConfig *)config;

- (void)addTags:(NSArray <NSString *> *)tags withConfig:(TTGTextTagConfig *)config;

// Insert tag with default config
- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index;

- (void)insertTags:(NSArray <NSString *> *)tags atIndex:(NSUInteger)index;

// Insert tag with custom config
- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;

- (void)insertTags:(NSArray <NSString *> *)tags atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;

// Remove tag
- (void)removeTag:(NSString *)tag;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;

// Update tag selected state
- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected;

// Update tag config
- (void)setTagAtIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;

- (void)setTagsInRange:(NSRange)range withConfig:(TTGTextTagConfig *)config;

// Get tag
- (NSString *)getTagAtIndex:(NSUInteger)index;

- (NSArray <NSString *> *)getTagsInRange:(NSRange)range;

// Get tag config
- (TTGTextTagConfig *)getConfigAtIndex:(NSUInteger)index;

- (NSArray <TTGTextTagConfig *> *)getConfigsInRange:(NSRange)range;

// Get all
- (NSArray <NSString *> *)allTags;

- (NSArray <NSString *> *)allSelectedTags;

- (NSArray <NSString *> *)allNotSelectedTags;

@end
