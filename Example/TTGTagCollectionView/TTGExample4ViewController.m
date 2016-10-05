//
//  TTGExample4ViewController.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2016/10/1.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import "TTGExample4ViewController.h"
#import "TTGExample4TableViewCell.h"

@interface TTGExample4ViewController ()
@property (nonatomic, strong) NSArray *allTags;
@property (nonatomic, strong) NSMutableArray *cellInfos;
@end

@implementation TTGExample4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    
    _allTags = @[
                 @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                 @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                 @"on", @"constraints", @"placed", @"on", @"those", @"views"
                 ];
    _cellInfos = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        [_cellInfos addObject:[self randomTags]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTGExample4TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTGExample4TableViewCell class])
                                                            forIndexPath:indexPath];
    [cell setTags:_cellInfos[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSArray <NSString *> *)randomTags {
    return [_allTags subarrayWithRange:NSMakeRange(0, (NSUInteger)arc4random_uniform((uint32_t)_allTags.count))];
}

@end
