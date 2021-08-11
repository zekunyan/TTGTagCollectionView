//
//  TTGExample9ViewController.m
//  TTGTagCollectionView_Example
//
//  Created by zekunyan on 2021/4/16.
//  Copyright © 2021 zekunyan. All rights reserved.
//

#import "TTGExample9ViewController.h"
#import <TTGTags/TTGTextTagCollectionView.h>

@interface TTGExample9ViewController ()
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTag;
@end

@implementation TTGExample9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Tag1
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Auto Layout dynamically "];
    
    NSUInteger location = 0;
    NSUInteger length = 8;
    
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
        NSForegroundColorAttributeName: [UIColor blueColor]
    } range:NSMakeRange(location, length)];
    
    location += length;
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
        NSForegroundColorAttributeName: [UIColor greenColor],
        NSBackgroundColorAttributeName: [UIColor blackColor],
        NSStrikethroughStyleAttributeName: @(1)
    } range:NSMakeRange(location, length)];
    
    location += length;
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont italicSystemFontOfSize:16],
        NSForegroundColorAttributeName: [UIColor redColor],
        NSBackgroundColorAttributeName: [UIColor yellowColor]
    } range:NSMakeRange(location, length)];
    
    TTGTextTag *tag = [TTGTextTag new];
    tag.content = [TTGTextTagAttributedStringContent contentWithAttributedText:attributedString];
    tag.style = [TTGTextTagStyle new];
    [_textTag addTag:tag];
    
    // Tag2
    attributedString = [[NSMutableAttributedString alloc] initWithString:@" calculates the size "];
    
    location = 0;
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:32],
        NSForegroundColorAttributeName: [UIColor orangeColor],
        NSBackgroundColorAttributeName: [UIColor darkGrayColor],
        NSStrikethroughStyleAttributeName: @(1),
        NSStrikethroughColorAttributeName: [UIColor redColor]
    } range:NSMakeRange(location, length)];
    
    location += length;
    [attributedString addAttributes:@{
        NSFontAttributeName: [UIFont italicSystemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor purpleColor],
        NSBackgroundColorAttributeName: [UIColor whiteColor],
        NSUnderlineStyleAttributeName: @(1),
        NSUnderlineColorAttributeName: [UIColor systemPinkColor]
    } range:NSMakeRange(location, length)];
    
    tag = [TTGTextTag new];
    tag.content = [TTGTextTagAttributedStringContent contentWithAttributedText:attributedString];
    tag.style = [TTGTextTagStyle new];
    [_textTag addTag:tag];
}

@end
