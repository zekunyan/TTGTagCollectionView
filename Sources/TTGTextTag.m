//
//  TTGTextTag.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
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

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    // Callback
    if (_onSelectStateChanged) {
        _onSelectStateChanged(selected);
    }
}

- (TTGTextTagContent *)selectedContent {
    if (_selectedContent == nil) {
        _selectedContent = [_content copy];
    }
    return _selectedContent;
}

- (TTGTextTagStyle *)selectedStyle {
    if (_selectedStyle == nil) {
        _selectedStyle = [_style copy];
    }
    return _selectedStyle;
}

- (TTGTextTagContent *)getRightfulContent {
    return _selected ? self.selectedContent : self.content;
}

- (TTGTextTagStyle *)getRightfulStyle {
    return _selected ? self.selectedStyle : self.style;
}

- (BOOL)isAccessibilityElement {
    return _enableAutoDetectAccessibility || _isAccessibilityElement;
}

- (NSString *)accessibilityLabel {
    if (_enableAutoDetectAccessibility) {
        return [self getRightfulContent].getContentAttributedString.string;
    }
    return _accessibilityLabel;
}

- (UIAccessibilityTraits)accessibilityTraits {
    if (_enableAutoDetectAccessibility) {
        return _selected ? UIAccessibilityTraitSelected : UIAccessibilityTraitButton;
    }
    return _accessibilityTraits;
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
        copy.selected = self.selected;
        copy.selectedContent = self.selectedContent;
        copy.selectedStyle = self.selectedStyle;
        copy.isAccessibilityElement = self.isAccessibilityElement;
        copy.accessibilityLabel = self.accessibilityLabel;
        copy.accessibilityHint = self.accessibilityHint;
        copy.accessibilityValue = self.accessibilityValue;
        copy.accessibilityTraits = self.accessibilityTraits;
        copy.enableAutoDetectAccessibility = self.enableAutoDetectAccessibility;
    }
    return copy;
}

@end
