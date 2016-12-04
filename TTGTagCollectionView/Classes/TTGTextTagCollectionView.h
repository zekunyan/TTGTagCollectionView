//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize;
@end

@interface TTGTextTagCollectionView : UIView
@property (weak, nonatomic) id <TTGTextTagCollectionViewDelegate> delegate;
@property (assign, nonatomic) BOOL enableTagSelection;

// Text
@property (strong, nonatomic) UIFont *tagTextFont;
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

// Extra space
@property (assign, nonatomic) CGSize extraSpace;

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

// Space
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content size
@property (nonatomic, assign, readonly) CGSize contentSize;

// Scroll direction. Default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

// Number of lines for horizontal direction
@property (nonatomic, assign) NSUInteger numberOfLines;

// Tag shadow
@property (nonatomic, copy) UIColor *shadowColor;    // Default is [UIColor black]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is CGSizeZero
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 0f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.5f

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2)
@property (nonatomic, assign) UIEdgeInsets contentInset;

- (void)reload;

- (void)addTag:(NSString *)tag;

- (void)addTags:(NSArray <NSString *> *)tags;

- (void)removeTag:(NSString *)tag;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;

- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected;

- (NSArray <NSString *> *)allTags;

- (NSArray <NSString *> *)allSelectedTags;

- (NSArray <NSString *> *)allNotSelectedTags;

@end
