//
//  ForumVC.m
//  Taxidio
//
//  Created by E-Intelligence on 14/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "ForumVC.h"

@interface ForumVC ()

@end

@implementation ForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
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

@end
