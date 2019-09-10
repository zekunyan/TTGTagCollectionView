//
//  TTGLanguageChangeViewController.m
//  TTGTagCollectionView_Example
//
//  Created by renwei on 2019/9/10.
//  Copyright © 2019 zekunyan. All rights reserved.
//

#import "TTGLanguageChangeViewController.h"

@interface TTGLanguageChangeViewController ()

@end

@implementation TTGLanguageChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if([[cell.textLabel.text lowercaseString] isEqualToString:@"english"]){
        [self onUpdateAppleLanguage:@"en"];
    }else{
        [self onUpdateAppleLanguage:@"ar"];
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[cell.textLabel.text lowercaseString] isEqualToString:@"english"]){
        cell.detailTextLabel.text = [[[self currentLanguage]lowercaseString] isEqualToString:@"en"]?@"√":@"";
    }else{
        cell.detailTextLabel.text = (![[[self currentLanguage]lowercaseString] isEqualToString:@"en"])?@"√":@"";
    }
}

-(NSString*)currentLanguage{
    NSString *locale = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"];
    if([locale isKindOfClass:[NSArray class]]){
        locale = [(NSArray*)locale firstObject];
    }
    if (locale.length>2) {
        NSRange range = [locale rangeOfString:@"-"];
        if (range.location!=NSNotFound) {
            locale = [locale substringToIndex:range.location];
        }
    }
    if (locale.length == 0) {
        locale = [[NSLocale currentLocale]languageCode];
    }
    return locale;
}

- (void)onUpdateAppleLanguage:(NSString*)language
{
    if ([language isKindOfClass:[NSArray class]]) {
        language = [(NSArray *)language firstObject];
    }
    NSMutableArray *array = [NSMutableArray array];
    NSString *locale = [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLocale"];
    if (locale.length>2) {
        NSRange range = [locale rangeOfString:@"_"];
        if (range.location!=NSNotFound) {
            locale = [locale substringFromIndex:range.location+1];
        }
    }
    [array addObject:[NSString stringWithFormat:@"%@-%@",language,locale]];
    for (NSString *cfg in [[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"]) {
        if (![cfg hasPrefix:language]) {
            [array addObject:cfg];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.tableView reloadData];
}

@end
