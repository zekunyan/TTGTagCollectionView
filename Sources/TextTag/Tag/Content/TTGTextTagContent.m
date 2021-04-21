//
//  TTGTextTagContent.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#if SWIFT_PACKAGE
#import "TTGTextTagContent.h"
#else
#import <TTGTagCollectionView/TTGTextTagContent.h>
#endif

@implementation TTGTextTagContent

- (NSAttributedString *)getContentAttributedString {
    NSAssert(NO, @"Do not use TTGTextTagContent directly.");
    return [NSAttributedString new];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

@end
