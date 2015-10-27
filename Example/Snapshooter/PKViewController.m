//
//  PKViewController.m
//  Snapshotter
//
//  Created by Seiya Shimokawa on 10/08/2015.
//  Copyright (c) 2015 Seiya Shimokawa. All rights reserved.
//

#import "PKViewController.h"

@interface PKViewController ()
@property (weak, nonatomic) IBOutlet UIButton *showAlertButton;
@end

@implementation PKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpInsideButton:(UIButton *)sender {
    if (self.showAlertButton == sender) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert title" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
