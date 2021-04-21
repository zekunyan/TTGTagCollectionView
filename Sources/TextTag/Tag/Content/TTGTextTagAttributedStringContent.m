//
//  TTGTextTagAttributedStringContent.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import "TTGTextTagAttributedStringContent.h"

@implementation TTGTextTagAttributedStringContent

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText {
    self = [super init];
    if (self) {
        self.attributedText = attributedText;
    }
    return self;
}

+ (instancetype)contentWithAttributedText:(NSAttributedString *)attributedText {
    return [[self alloc] initWithAttributedText:attributedText];
}

- (NSAttributedString *)getContentAttributedString {
    return self.attributedText;
}

- (NSAttributedString *)attributedText {
    return _attributedText ?: [NSAttributedString new];
}

- (id)copyWithZone:(NSZone *)zone {
    TTGTextTagAttributedStringContent *copy = (TTGTextTagAttributedStringContent *)[super copyWithZone:zone];
    if (copy != nil) {
        copy.attributedText = self.attributedText;
    }
    return copy;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.attributedText=%@", self.attributedText];
    [description appendString:@">"];
    return description;
}

@end
