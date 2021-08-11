//
//  TTGTextTagContent.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Base content class.
 Do not use this class directly!
 */
@interface TTGTextTagContent : NSObject <NSCopying>

/// Must be override by subClass
- (NSAttributedString *_Nonnull)getContentAttributedString;

/// Must be override by subClass
- (id _Nonnull)copyWithZone:(NSZone *_Nullable)zone;

@end
