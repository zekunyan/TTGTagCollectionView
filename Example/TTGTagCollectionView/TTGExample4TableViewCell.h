//
//  TTGExample4TableViewCell.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2016/10/1.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTGTextTagCollectionView;

@interface TTGExample4TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)setTags:(NSArray <NSString *> *)tags;

@end
