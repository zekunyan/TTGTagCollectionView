//
//  TTGTextTagStyle.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import "TTGTextTagStyle.h"

@implementation TTGTextTagStyle

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    TTGTextTagStyle *copy = (TTGTextTagStyle *)[[[self class] allocWithZone:zone] init];

    if (copy != nil) {
        copy.backgroundColor = self.backgroundColor;
        copy.enableGradientBackground = self.enableGradientBackground;
        copy.gradientBackgroundStartColor = self.gradientBackgroundStartColor;
        copy.gradientBackgroundEndColor = self.gradientBackgroundEndColor;
        copy.gradientBackgroundStartPoint = self.gradientBackgroundStartPoint;
        copy.gradientBackgroundEndPoint = self.gradientBackgroundEndPoint;
        copy.cornerRadius = self.cornerRadius;
        copy.cornerTopRight = self.cornerTopRight;
        copy.cornerTopLeft = self.cornerTopLeft;
        copy.cornerBottomRight = self.cornerBottomRight;
        copy.cornerBottomLeft = self.cornerBottomLeft;
        copy.borderWidth = self.borderWidth;
        copy.borderColor = self.borderColor;
        copy.shadowColor = self.shadowColor;
        copy.shadowOffset = self.shadowOffset;
        copy.shadowRadius = self.shadowRadius;
        copy.shadowOpacity = self.shadowOpacity;
        copy.extraSpace = self.extraSpace;
        copy.maxWidth = self.maxWidth;
        copy.minWidth = self.minWidth;
        copy.maxHeight = self.maxHeight;
        copy.minHeight = self.minHeight;
        copy.exactWidth = self.exactWidth;
        copy.exactHeight = self.exactHeight;
    }

    return copy;
}

- (UIColor *)backgroundColor {
    return _backgroundColor ?: [UIColor clearColor];
}

- (UIColor *)gradientBackgroundStartColor {
    return _gradientBackgroundStartColor ?: [UIColor clearColor];
}

- (UIColor *)gradientBackgroundEndColor {
    return _gradientBackgroundEndColor ?: [UIColor clearColor];
}

- (UIColor *)borderColor {
    return _borderColor ?: [UIColor clearColor];
}

- (UIColor *)shadowColor {
    return _shadowColor ?: [UIColor clearColor];
}

@end
