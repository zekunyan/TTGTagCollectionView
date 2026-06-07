//
//  TTGDemoTagsInTableViewController.m
//

#import "TTGDemoTagsInTableViewController.h"
#import "TTGDemoUI.h"
#import "TTGDemoTagsTableViewCell.h"
#import "TTGTagSampleData.h"

static const NSInteger kDemoRowCount = 50;

@interface TTGDemoTagsInTableViewController ()
@property (nonatomic, copy) NSArray<NSString *> *wordPool;
@property (nonatomic, strong) NSMutableArray<NSArray<NSString *> *> *rows;
@end

@implementation TTGDemoTagsInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.tableView.backgroundColor = UIColor.systemBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    [self.tableView registerClass:TTGDemoTagsTableViewCell.class
           forCellReuseIdentifier:NSStringFromClass([TTGDemoTagsTableViewCell class])];
    [self configureHeader];

    self.wordPool = [TTGTagSampleData shortSampleWords];
    self.rows = [NSMutableArray arrayWithCapacity:kDemoRowCount];
    NSUInteger poolCount = self.wordPool.count;
    for (NSInteger i = 0; i < kDemoRowCount; i++) {
        NSUInteger len = i % (poolCount + 1);
        NSRange range = NSMakeRange(0, len);
        [self.rows addObject:[self.wordPool subarrayWithRange:range]];
    }
}

- (void)configureHeader {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Tags in UITableViewCell"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Each row owns a TTGTextTagCollectionView. UITableViewAutomaticDimension reads the tag view height as the tags wrap into multiple lines."];
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[ titleLabel, descriptionLabel ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 8;
    stack.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 104);
    self.tableView.tableHeaderView = stack;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTGDemoTagsTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTGDemoTagsTableViewCell class])
                                          forIndexPath:indexPath];
    [cell configureWithWords:self.rows[(NSUInteger)indexPath.row]];
    cell.label.text = [NSString stringWithFormat:@"Row %ld · %lu tags", (long)indexPath.row, (unsigned long)self.rows[(NSUInteger)indexPath.row].count];
    return cell;
}

@end
