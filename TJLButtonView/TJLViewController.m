//
//  TJLViewController.m
//  TJLButtonView
//
//  Created by Terry Lewis II on 8/20/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLViewController.h"
#import "TJLButtonView.h"

@interface TJLViewController ()

@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)showButtonView:(UIButton *)sender {
    NSArray *images = @[
            [UIImage imageNamed:@"Redx"],
            [UIImage imageNamed:@"Redx"],
            [UIImage imageNamed:@"Redx"],
            [UIImage imageNamed:@"Redx"],
            [UIImage imageNamed:@"Redx"]
    ];
    NSArray *titles = @[@"1", @"2", @"3", @"4", @"5"];
    TJLButtonView *tjlButtonView = [[TJLButtonView alloc]initWithView:self.view images:images buttonTitles:titles];
    [tjlButtonView setButtonTappedBlock:^(TJLButtonView *buttonView, NSString *title) {
        NSLog(@"%@", title);
    }];
    [tjlButtonView setCloseButtonTappedBlock:^(TJLButtonView *buttonView, NSString *title) {
        NSLog(@"%@", title);
    }];
    [tjlButtonView show];

}
@end
