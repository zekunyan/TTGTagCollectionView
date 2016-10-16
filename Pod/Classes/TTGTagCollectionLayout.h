//
//  TTGTagCollectionLayout.h
//  Pods
//
//  Created by tutuge on 2016/10/16.
//
//

#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

@interface TTGTagCollectionLayout : UICollectionViewLayout
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;
@property (nonatomic, assign) NSUInteger numberOfLines; // Default=1
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;
@end
