//
//  TTGExample8ViewController.m
//  TTGTagCollectionView_Example
//
//  Created by tutuge on 24/03/2018.
//  Copyright © 2018 zekunyan. All rights reserved.
//

#import "TTGExample8ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

#pragma mark - CustomTagData

@interface CustomTagData: NSObject
@property (nonatomic, strong) NSString *info;
@end

@implementation CustomTagData
- (NSString *)description {
    return [NSString stringWithFormat:@"I am CustomTagData, info is: %@", _info];
}
@end

#pragma mark - TTGExample8ViewController

@interface TTGExample8ViewController () <TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UITextView *infoTextView;
@end

@implementation TTGExample8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Data
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    // Create view
    _tagView = [TTGTextTagCollectionView new];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    _tagView.layer.borderColor = [UIColor grayColor].CGColor;
    _tagView.layer.borderWidth = 1;
    _tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tagView];
    
    _infoTextView = [UITextView new];
    _infoTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _infoTextView.layer.borderWidth = 1;
    _infoTextView.textColor = [UIColor grayColor];
    _infoTextView.font = [UIFont systemFontOfSize:12];
    _infoTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _infoTextView.contentInset = UIEdgeInsetsZero;
    _infoTextView.textContainerInset = UIEdgeInsetsZero;
    _infoTextView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_infoTextView];
    
    // TagView Layout
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tagView]-20-|"
                                                                    options:(NSLayoutFormatOptions) 0 metrics:nil
                                                                      views:@{@"tagView": _tagView}];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_tagView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.topLayoutGuide
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1 constant:20];
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    
    // Info textView layout
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[infoView]-20-|"
                                                           options:(NSLayoutFormatOptions) 0 metrics:nil
                                                             views:@{@"infoView": _infoTextView}];
    topConstraint = [NSLayoutConstraint constraintWithItem:_infoTextView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_tagView
                                                 attribute:NSLayoutAttributeBottom
                                                multiplier:1 constant:20];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_infoTextView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1 constant:-20];
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    [self.view addConstraint:bottomConstraint];
    
    // Add tag and bind data
    NSInteger tagTextIndex = 0;
    
    // Bind CustomTagData
    CustomTagData *customTagData = [CustomTagData new];
    customTagData.info = @"I am TTGTag custom data.";
    
//    TTGTextTag *config = [TTGTextTag new];
//    config.attachment = customTagData;
//
//    [_tagView addTag:tags[tagTextIndex++] withConfig:config];
//
//    // Bind NSDictionary
//    NSDictionary *dict = @{@"info": @"I am TTGTag NSDictionary data"};
//    config = [TTGTextTag new];
//    config.extraData = dict;
//
//    [_tagView addTag:tags[tagTextIndex++] withConfig:config];
//
//    // Bind the rest with string data
//    for (NSString *tagText in [tags subarrayWithRange:NSMakeRange(tagTextIndex, tags.count - tagTextIndex)]) {
//        config = [TTGTextTag new];
//        config.extraData = [NSString stringWithFormat:@"I am TTGTag NSString data with tag: %@", tagText];
//        [_tagView addTag:tagText withConfig:config];
//    }
//
//    // Random selected
//    for (NSInteger i = 0; i < 5; i++) {
//        [_tagView setTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
//    }
    
    // Reload
    [_tagView reload];
    
    // Set delegate
    _tagView.delegate = self;
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index {
    _infoTextView.text = [NSString stringWithFormat:@"%@\nInfo: %@", _infoTextView.text, tag.attachment];
}

@end
