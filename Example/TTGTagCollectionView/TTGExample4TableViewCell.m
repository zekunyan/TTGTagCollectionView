//
//  TTGExample4TableViewCell.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2016/10/1.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import "TTGExample4TableViewCell.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample4TableViewCell ()
@end

@implementation TTGExample4TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Alignment
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    // Use manual calculate height
    _tagView.manualCalculateHeight = YES;
}

- (void)setTags:(NSArray<NSString *> *)tags {
    [_tagView removeAllTags];
    [_tagView addTags:tags];

    // Use manual height, update preferredMaxLayoutWidth
    _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;
    
    // Random selected
    for (NSInteger i = 0; i < 3; i++) {
        [_tagView setTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
    }    
}

@end
