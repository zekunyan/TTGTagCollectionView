//
//  TTGTextTag.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if SWIFT_PACKAGE
#import "TTGTextTagStyle.h"
#import "TTGTextTagContent.h"
#else
#import <TTGTagCollectionView/TTGTextTagStyle.h>
#import <TTGTagCollectionView/TTGTextTagContent.h>
#endif

@interface TTGTextTag : NSObject <NSCopying>

/// ID
@property (nonatomic, assign, readonly) NSUInteger tagId; // Auto increase. The only identifier and main key for a tag

/// Attachment object. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) id _Nullable attachment;

/// Normal state content and style
@property (nonatomic, copy) TTGTextTagContent * _Nonnull content;
@property (nonatomic, copy) TTGTextTagStyle * _Nonnull style;

/// Selected state content and style
@property (nonatomic, copy) TTGTextTagContent * _Nullable selectedContent;
@property (nonatomic, copy) TTGTextTagStyle * _Nullable selectedStyle;

/// Selection state
@property (nonatomic, assign) BOOL selected;

/// Init

/**
 Init with single content and style

 @param content content for both normal and selection state.
 @param style style for both normal and selection state.
 @return instance
 */
- (instancetype _Nonnull)initWithContent:(TTGTextTagContent *_Nonnull)content
                                   style:(TTGTextTagStyle *_Nonnull)style;

/**
 Init with different content and style

 @param content content for normal state
 @param style style for normal state
 @param selectedContent content for selection state
 @param selectedStyle style for selection state
 @return instance
 */
- (instancetype _Nonnull)initWithContent:(TTGTextTagContent *_Nonnull)content
                                   style:(TTGTextTagStyle *_Nonnull)style
                         selectedContent:(TTGTextTagContent *_Nullable)selectedContent
                           selectedStyle:(TTGTextTagStyle *_Nullable)selectedStyle;

/**
 Tag with single content and style

 @param content content for both normal and selection state.
 @param style style for both normal and selection state.
 @return instance
 */
+ (instancetype _Nonnull)tagWithContent:(TTGTextTagContent *_Nonnull)content
                                  style:(TTGTextTagStyle *_Nonnull)style;

/**
 Tag with different content and style
 
 @param content content for normal state
 @param style style for normal state
 @param selectedContent content for selection state
 @param selectedStyle style for selection state
 @return instance
 */
+ (instancetype _Nonnull)tagWithContent:(TTGTextTagContent *_Nonnull)content
                                  style:(TTGTextTagStyle *_Nonnull)style
                        selectedContent:(TTGTextTagContent *_Nullable)selectedContent
                          selectedStyle:(TTGTextTagStyle *_Nullable)selectedStyle;

/**
 Get current state rightful content

 @return content
 */
- (TTGTextTagContent *_Nonnull)getRightfulContent;

/**
 Get current state rightful style

 @return style
 */
- (TTGTextTagStyle *_Nonnull)getRightfulStyle;

/// Base system methods
- (BOOL)isEqual:(id _Nullable)other;
- (BOOL)isEqualToTag:(TTGTextTag *_Nullable)tag;
- (NSUInteger)hash;

/// Copy
- (id _Nonnull)copyWithZone:(NSZone *_Nullable)zone;

@end
