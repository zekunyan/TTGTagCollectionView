//
// Created by zorro on 15/12/28.
//

#import "TTGTagCollectionCell.h"

@implementation TTGTagCollectionCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView.subviews.firstObject setFrame:self.contentView.bounds];
}

#pragma mark - Public methods

- (void)setTagView:(UIView *)tagView {
    if (!tagView) {
        return;
    }

    // Remove all subViews
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Add tag view
    [tagView removeFromSuperview];
    [self.contentView addSubview:tagView];
}

#pragma mark - Private methods

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.contentView.userInteractionEnabled = YES;
}

@end
