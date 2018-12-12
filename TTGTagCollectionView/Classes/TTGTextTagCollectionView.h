//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

/// TTGTextTagConfig

@interface TTGTextTagConfig : NSObject;
// Text font
@property (strong, nonatomic) UIFont *textFont;

// Text color
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *selectedTextColor;

// Background color
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

// Gradient background color
@property (assign, nonatomic) BOOL enableGradientBackground;
@property (strong, nonatomic) UIColor *gradientBackgroundStartColor;
@property (strong, nonatomic) UIColor *gradientBackgroundEndColor;
@property (strong, nonatomic) UIColor *selectedGradientBackgroundStartColor;
@property (strong, nonatomic) UIColor *selectedGradientBackgroundEndColor;
@property (assign, nonatomic) CGPoint gradientBackgroundStartPoint;
@property (assign, nonatomic) CGPoint gradientBackgroundEndPoint;

// Corner radius
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat selectedCornerRadius;
@property (assign, nonatomic) Boolean cornerTopRight;
@property (assign, nonatomic) Boolean cornerTopLeft;
@property (assign, nonatomic) Boolean cornerBottomRight;
@property (assign, nonatomic) Boolean cornerBottomLeft;

// Border
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat selectedBorderWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *selectedBorderColor;

// Shadow.
@property (nonatomic, copy) UIColor *shadowColor;    // Default is [UIColor black]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

// Extra space in width and height, will expand each tag's size
@property (assign, nonatomic) CGSize extraSpace;

// Max width for a text tag. 0 and below means no max width.
@property (assign, nonatomic) CGFloat maxWidth;
// Min width for a text tag. 0 and below means no min width.
@property (assign, nonatomic) CGFloat minWidth;

// Exact width. 0 and below means no work
@property (nonatomic, assign) CGFloat exactWidth;
// Exact height. 0 and below means no work
@property (nonatomic, assign) CGFloat exactHeight;

// Extra data. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) NSObject *extraData;

@end

/// TTGTextTagCollectionView

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional

- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
              currentSelected:(BOOL)currentSelected
                    tagConfig:(TTGTextTagConfig *)config;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
            updateContentSize:(CGSize)contentSize;

// Deprecated
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
              currentSelected:(BOOL)currentSelected __attribute__((deprecated("Use the new method")));
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected __attribute__((deprecated("Use the new method")));
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
// The real number of lines ignoring the numberOfLines value
@property (nonatomic, assign, readonly) NSUInteger actualNumberOfLines;

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

// Tap blank area callback
@property (nonatomic, copy) void (^onTapBlankArea)(CGPoint location);
// Tap all area callback
@property (nonatomic, copy) void (^onTapAllArea)(CGPoint location);

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

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
- (NSInteger)indexOfTagAt:(CGPoint)point;

@end
