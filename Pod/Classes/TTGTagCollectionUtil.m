//
// Created by zorro on 15/12/29.
//

#import <UIKit/UIKit.h>
#import "TTGTagCollectionUtil.h"

@implementation TTGTagCollectionUtil

+ (NSArray *)edgeConstraintsWithView1:(UIView *)view1 view2:(UIView *)view2 {
    // Add constraint
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:view1
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:view2
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1 constant:0];

    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:view1
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view2
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1 constant:0];

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view1
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:view2
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1 constant:0];

    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view1
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view2
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1 constant:0];

    return @[left, right, top, bottom];
}

@end