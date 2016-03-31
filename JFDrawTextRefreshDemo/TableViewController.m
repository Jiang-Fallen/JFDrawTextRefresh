//
//  TableViewController.m
//  JFDrawTextRefreshDemo
//
//  Created by Mr_J on 16/3/31.
//  Copyright © 2016年 Mr_Jiang. All rights reserved.
//

#import "TableViewController.h"
#import "UIScrollView+JFRefresh.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithAction:^{
        [weakSelf headerActionOpration];
    }customControl:^(JFDrawTextView *drawView) {
        drawView.refreshText = @"Jiang.Fallen";
        drawView.textColor = [UIColor redColor];
    }];
}

- (void)headerActionOpration{
    [self.tableView performSelector:@selector(endHeaderRefresh) withObject:nil afterDelay:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

@end
