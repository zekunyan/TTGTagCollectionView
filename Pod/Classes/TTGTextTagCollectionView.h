//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected;
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

// Border
@property (assign, nonatomic) CGFloat tagCornerRadius;
@property (assign, nonatomic) CGFloat tagBorderWidth;
@property (strong, nonatomic) UIColor *tagBorderColor;

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