//
//  TTGDemoCustomSubviewTagsViewController.m
//

#import "TTGDemoCustomSubviewTagsViewController.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoCustomSubviewTagsViewController () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet TTGTagCollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (strong, nonatomic) NSMutableArray<UIView *> *tagViews;
@end

@implementation TTGDemoCustomSubviewTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    self.logLabel.adjustsFontSizeToFitWidth = YES;
    self.tagViews = [NSMutableArray array];
    [self buildDemoTagViews];
    [self.tagCollectionView reload];
}

#pragma mark - Demo subviews

- (void)buildDemoTagViews {
    UIColor *teal = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1];
    UIColor *blue = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1];
    UIColor *orange = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1];

    void (^add)(UIView *) = ^(UIView *v) { [self.tagViews addObject:v]; };

    add([self labelWithText:@"AutoLayout" fontSize:14 textColor:UIColor.whiteColor background:teal]);
    add([self buttonWithTitle:@"Button1" fontSize:18 background:blue]);
    add([self imageNamed:@"bluefaces_1"]);
    add([self labelWithText:@"dynamically" fontSize:20 textColor:UIColor.whiteColor background:teal]);
    add([self buttonWithTitle:@"Button2" fontSize:16 background:orange]);
    add([self buttonWithTitle:@"Button3" fontSize:15 background:blue]);
    add([self imageNamed:@"bluefaces_2"]);
    add([self labelWithText:@"the" fontSize:16 textColor:UIColor.blackColor background:teal]);
    add([self buttonWithTitle:@"Button4" fontSize:22 background:blue]);
    add([self imageNamed:@"bluefaces_3"]);
    add([self labelWithText:@"views" fontSize:12
                  textColor:[UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1]
                 background:orange]);
    add([self buttonWithTitle:@"Button5" fontSize:15 background:teal]);
    add([self imageNamed:@"bluefaces_4"]);
    add([self imageNamed:@"bluefaces_4"]);
}

#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSInteger)index {
    return self.tagViews[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView
         didSelectTag:(UIView *)tagView
               atIndex:(NSInteger)index {
    self.logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld", tagView.class, (long)index];
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.tagViews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSInteger)index {
    return self.tagViews[index];
}

#pragma mark - View factories

- (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor
                background:(UIColor *)bg {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = bg;
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4;
    [self padView:label width:12 height:8];
    return label;
}

- (UIButton *)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize background:(UIColor *)bg {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = bg;
    [button sizeToFit];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    [self padView:button width:12 height:8];
    [button addTarget:self action:@selector(tagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImageView *)imageNamed:(NSString *)name {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [iv sizeToFit];
    return iv;
}

- (void)padView:(UIView *)view width:(CGFloat)w height:(CGFloat)h {
    CGRect f = view.frame;
    f.size.width += w;
    f.size.height += h;
    view.frame = f;
}

- (void)tagButtonTapped:(UIButton *)sender {
    self.logLabel.text = @"Tap tag button !";
}

@end
