//
//  TTGTextTagAttributedStringContent.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import "TTGTextTagContent.h"

/**
 Rich text content for tag
 */
@interface TTGTextTagAttributedStringContent : TTGTextTagContent

/// Attributed text
@property (nonatomic, copy) NSAttributedString * _Nonnull attributedText;

/// Init with rich text
- (instancetype _Nonnull)initWithAttributedText:(NSAttributedString *_Nonnull)attributedText;

/// Content with rich text
+ (instancetype _Nonnull)contentWithAttributedText:(NSAttributedString *_Nonnull)attributedText;

/// Base system methods
- (id _Nonnull)copyWithZone:(NSZone *_Nullable)zone;
- (NSString *_Nonnull)description;

@end
