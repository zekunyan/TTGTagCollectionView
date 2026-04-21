//
//  TTGDemoTagsInTableViewController.m
//

#import "TTGDemoTagsInTableViewController.h"
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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;

    self.wordPool = [TTGTagSampleData shortSampleWords];
    self.rows = [NSMutableArray arrayWithCapacity:kDemoRowCount];
    NSUInteger poolCount = self.wordPool.count;
    for (NSInteger i = 0; i < kDemoRowCount; i++) {
        NSUInteger len = i % (poolCount + 1);
        NSRange range = NSMakeRange(0, len);
        [self.rows addObject:[self.wordPool subarrayWithRange:range]];
    }
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
    cell.label.text = [NSString stringWithFormat:@"Cell: %ld", (long)indexPath.row];
    return cell;
}

@end
