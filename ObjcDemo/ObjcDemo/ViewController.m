//
//  ViewController.m
//  ObjcDemo
//
//  Created by Suguru Kishimoto on 3/16/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

#import "ViewController.h"
#import "SampleTableViewController.h"

@import PullToDismiss;

@interface ViewController ()
@property(nonatomic, weak) IBOutlet UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.button addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonDidTap:(UIButton *)button {
    SampleTableViewController *tableViewController = [[SampleTableViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
