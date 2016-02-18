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
    CGFloat lastCenterY = 0.0f, newCenterY;
    CGRect frame;

    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        frame = attribute.frame;
        newCenterY = frame.origin.y + frame.size.height / 2;

        if (frame.origin.x == self.sectionInset.left || abs((int) (newCenterY - lastCenterY)) > 1) {
            xOffset = self.sectionInset.left;
            lastCenterY = newCenterY;
        }

        frame.origin.x = xOffset;
        attribute.frame = frame;

        xOffset += CGRectGetWidth(frame) + self.minimumInteritemSpacing;
    }

    return attributes;
}

@end
