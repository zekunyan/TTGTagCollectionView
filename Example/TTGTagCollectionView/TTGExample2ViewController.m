//
//  TTGExample2ViewController.m
//  TTGTagCollectionView
//
//  Created by zorro on 15/12/29.
//  Copyright © 2015年 zekunyan. All rights reserved.
//

#import <TTGTagCollectionView/TTGTagCollectionView.h>
#import "TTGExample2ViewController.h"

@interface TTGExample2ViewController () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet TTGTagCollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (strong, nonatomic) NSMutableArray <UIView *> *tagViews;
@end

@implementation TTGExample2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;
    _logLabel.adjustsFontSizeToFitWidth = YES;
    _tagViews = [NSMutableArray new];

    [_tagViews addObject:[self newLabelWithText:@"AutoLayout" fontSize:14.0f textColor:[UIColor whiteColor] backgroundColor:[UIColor blueColor]]];
    [_tagViews addObject:[self newButtonWithTitle:@"Button1" fontSize:18.0f backgroundColor:[UIColor lightGrayColor]]];
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:@"bluefaces_1"]]];
    [_tagViews addObject:[self newLabelWithText:@"dynamically" fontSize:20.0f textColor:[UIColor whiteColor] backgroundColor:[UIColor brownColor]]];
    [_tagViews addObject:[self newButtonWithTitle:@"Button2" fontSize:16.0f backgroundColor:[UIColor yellowColor]]];
    [_tagViews addObject:[self newButtonWithTitle:@"Button3" fontSize:15.0f backgroundColor:[UIColor brownColor]]];
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:@"bluefaces_2"]]];
    [_tagViews addObject:[self newLabelWithText:@"the" fontSize:16.0f textColor:[UIColor blackColor] backgroundColor:[UIColor grayColor]]];
    [_tagViews addObject:[self newButtonWithTitle:@"Button4" fontSize:22.0f backgroundColor:[UIColor grayColor]]];
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:@"bluefaces_3"]]];
    [_tagViews addObject:[self newLabelWithText:@"views" fontSize:12.0f textColor:[UIColor brownColor] backgroundColor:[UIColor yellowColor]]];
    [_tagViews addObject:[self newButtonWithTitle:@"Button5" fontSize:15.0f backgroundColor:[UIColor lightGrayColor]]];
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:@"bluefaces_4"]]];
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:@"bluefaces_4"]]];

    [_tagCollectionView reload];
}

#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    return _tagViews[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    _logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld", tagView.class, (long) index];
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return _tagViews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    return _tagViews[index];
}

#pragma mark - Private methods

- (UILabel *)newLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroudColor {
    UILabel *label = [UILabel new];

    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = backgroudColor;
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4.0f;

    [self expandSizeForView:label extraWidth:12 extraHeight:8];

    return label;
}

- (UIButton *)newButtonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)backgroudColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = backgroudColor;
    [button sizeToFit];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4.0f;

    [self expandSizeForView:button extraWidth:12 extraHeight:8];

    [button addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (UIImageView *)newImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView sizeToFit];
    return imageView;
}

- (void)expandSizeForView:(UIView *)view extraWidth:(CGFloat)extraWidth extraHeight:(CGFloat)extraHeight {
    CGRect frame = view.frame;
    frame.size.width += extraWidth;
    frame.size.height += extraHeight;
    view.frame = frame;
}

#pragma mark - Action

- (void)onTap:(UIButton *)button {
    _logLabel.text = @"Tap tag button !";
}

@end
