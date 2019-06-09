//
//  TTGTextTag.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TTGTextTagStyle.h"
#import "TTGTextTagContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGTextTag : NSObject <NSCopying>

// ID
@property (nonatomic, assign, readonly) NSUInteger tagId; // Auto increase. The only identifier and main key for a tag

// Attachment. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) id attachment;

// Normal
@property (nonatomic, copy) TTGTextTagContent *content;
@property (nonatomic, copy) TTGTextTagStyle *style;

// Selected
@property (nonatomic, copy) TTGTextTagContent *selectedContent;
@property (nonatomic, copy) TTGTextTagStyle *selectedStyle;

// Selection state
@property (nonatomic, assign) BOOL selected;

// Init

- (instancetype)initWithContent:(TTGTextTagContent *)content
                          style:(TTGTextTagStyle *)style;

- (instancetype)initWithContent:(TTGTextTagContent *)content
                          style:(TTGTextTagStyle *)style
                selectedContent:(TTGTextTagContent *)selectedContent
                  selectedStyle:(TTGTextTagStyle *)selectedStyle;

+ (instancetype)tagWithContent:(TTGTextTagContent *)content
                         style:(TTGTextTagStyle *)style;

+ (instancetype)tagWithContent:(TTGTextTagContent *)content
                         style:(TTGTextTagStyle *)style
               selectedContent:(TTGTextTagContent *)selectedContent
                 selectedStyle:(TTGTextTagStyle *)selectedStyle;

// Get rightful content
- (TTGTextTagContent *)getRightfulContent;

// Get rightful style
- (TTGTextTagStyle *)getRightfulStyle;

// Base
- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToTag:(TTGTextTag *)tag;
- (NSUInteger)hash;

// Copy
- (id)copyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END
