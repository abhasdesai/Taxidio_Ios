//
//  MyAccountVC.m
//  Taxidio
//
//  Created by E-Intelligence on 13/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MyAccountVC.h"

@interface MyAccountVC ()

@end

@implementation MyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressClose:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
