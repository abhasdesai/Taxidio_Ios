//
//  MenuPageVCViewController.m
//  Taxidio
//
//  Created by E-Intelligence on 13/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MenuPageVCViewController.h"

@interface MenuPageVCViewController ()

@end

@implementation MenuPageVCViewController

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

- (IBAction)pressCloseBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)pressHomeBtn:(id)sender {
}

- (IBAction)pressChroniclesBtn:(id)sender {
}

- (IBAction)pressHotelsBtn:(id)sender {
}

- (IBAction)pressAttactions:(id)sender {
}

- (IBAction)pressMyTrips:(id)sender {
}

- (IBAction)pressDestinations:(id)sender {
}

- (IBAction)pressReferFriend:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer =
        [[MFMessageComposeViewController alloc] init];
        NSString *message = @"Your Message here";
        [messageComposer setBody:message];
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressLogOut:(id)sender {
}

- (IBAction)pressUserProfile:(id)sender
{
    
}

@end
