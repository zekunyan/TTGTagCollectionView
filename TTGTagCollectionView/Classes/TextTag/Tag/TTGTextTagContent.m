//
//  TTGTextTagContent.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import "TTGTextTagContent.h"

@implementation TTGTextTagContent

- (NSAttributedString *)getContentAttributedString {
    NSAssert(NO, @"Do not use TTGTextTagContent directly.");
    return nil;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

@end
