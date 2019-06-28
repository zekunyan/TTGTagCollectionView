//
//  TTGTextTag.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

#import "TTGTextTag.h"
#import "TTGTextTagStringContent.h"

static NSUInteger TTGTextTagAutoIncreasedId = 0;

@implementation TTGTextTag

- (instancetype)initWithContent:(TTGTextTagContent *)content
                          style:(TTGTextTagStyle *)style {
    self = [self init];
    if (self) {
        self.content = content;
        self.style = style;
        [self setupDefaultStyle];
    }
    return self;
}

- (instancetype)initWithContent:(TTGTextTagContent *)content
                          style:(TTGTextTagStyle *)style
                selectedContent:(TTGTextTagContent *)selectedContent
                  selectedStyle:(TTGTextTagStyle *)selectedStyle {
    self = [self init];
    if (self) {
        self.content = content;
        self.style = style;
        self.selectedContent = selectedContent;
        self.selectedStyle = selectedStyle;
        [self setupDefaultStyle];
    }
    return self;
}

+ (instancetype)tagWithContent:(TTGTextTagContent *)content
                         style:(TTGTextTagStyle *)style {
    return [[self alloc] initWithContent:content style:style];
}

+ (instancetype)tagWithContent:(TTGTextTagContent *)content
                         style:(TTGTextTagStyle *)style
               selectedContent:(TTGTextTagContent *)selectedContent
                 selectedStyle:(TTGTextTagStyle *)selectedStyle {
    return [[self alloc] initWithContent:content
                                   style:style
                         selectedContent:selectedContent
                           selectedStyle:selectedStyle];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tagId = TTGTextTagAutoIncreasedId++;
        _attachment = nil;
    }
    return self;
}

- (void)setupDefaultStyle {
    if (!_selectedStyle) {
        _selectedStyle = [_style copy];
    }
    _style.backgroundColor = [UIColor lightGrayColor];
    _selectedStyle.backgroundColor = [UIColor greenColor];
}

- (TTGTextTagContent *)selectedContent {
    return _selectedContent ?: _content;
}

- (TTGTextTagStyle *)selectedStyle {
    return _selectedStyle ?: _style;
}

- (TTGTextTagContent *)getRightfulContent {
    return _selected ? self.selectedContent : self.content;
}

- (TTGTextTagStyle *)getRightfulStyle {
    return _selected ? self.selectedStyle : self.style;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToTag:other];
}

- (BOOL)isEqualToTag:(TTGTextTag *)tag {
    if (self == tag)
        return YES;
    if (tag == nil)
        return NO;
    if (self.tagId != tag.tagId)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return (NSUInteger)self.tagId;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    TTGTextTag *copy = (TTGTextTag *)[[[self class] allocWithZone:zone] init];
    if (copy != nil) {
        copy->_tagId = TTGTextTagAutoIncreasedId++;
        copy.attachment = self.attachment;
        copy.content = self.content;
        copy.style = self.style;
        copy.selectedContent = self.selectedContent;
        copy.selectedStyle = self.selectedStyle;
        copy.selected = self.selected;
    }
    return copy;
}

@end
