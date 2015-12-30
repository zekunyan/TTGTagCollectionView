//
//  TTGTagCollectionLayout.m
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import "TTGTagCollectionLayout.h"

@implementation TTGTagCollectionLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]];

    CGFloat xOffset = 0.0f;

    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.frame.origin.x == self.sectionInset.left) {
            xOffset = self.sectionInset.left;
        } else {
            CGRect frame = attribute.frame;
            frame.origin.x = xOffset;
            attribute.frame = frame;
        }

        xOffset += CGRectGetWidth(attribute.frame) + self.minimumInteritemSpacing;
    }

    return attributes;
}

@end
