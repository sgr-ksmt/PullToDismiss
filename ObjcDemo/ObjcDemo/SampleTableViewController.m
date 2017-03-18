//
//  SampleTableViewController.m
//  ObjcDemo
//
//  Created by Suguru Kishimoto on 3/16/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

#import "SampleTableViewController.h"
@import PullToDismiss;
#import "CustomShadowEffect.h"

@interface SampleTableViewController ()
@property(nonatomic, nullable) PullToDismiss *pullToDismiss;
@end

@implementation SampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.pullToDismiss = [[PullToDismiss alloc] initWithScrollView:self.tableView];
    
    self.pullToDismiss.edgeShadow = [EdgeShadow defaultEdgeShadow];
    self.pullToDismiss.delegate = self;
    CustomShadowEffect *effect = [[CustomShadowEffect alloc] init];
    effect.alpha = 0.5;
    effect.color = [UIColor purpleColor];
    self.pullToDismiss.backgroundEffect = effect;
    self.pullToDismiss.dismissableHeightPercentage = 0.5f;
    __weak typeof(self) wSelf = self;
    self.pullToDismiss.dismissAction = ^{
        NSLog(@"!!!");
        [wSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"!!!"
                                                                   message:@(indexPath.row).stringValue
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
