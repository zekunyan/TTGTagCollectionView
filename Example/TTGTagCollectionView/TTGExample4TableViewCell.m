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
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
}

- (void)setTags:(NSArray<NSString *> *)tags {
    [_tagView removeAllTags];
    [_tagView addTags:tags];
    
    // Random selected
    for (NSInteger i = 0; i < 3; i++) {
        [_tagView setTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
    }    
}

@end
