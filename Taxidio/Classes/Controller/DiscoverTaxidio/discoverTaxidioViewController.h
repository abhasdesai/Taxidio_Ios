//
//  discoverTaxidioViewController.h
//  Taxidio
//
//  Created by E-Intelligence on 03/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface discoverTaxidioViewController : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    NSMutableDictionary *dictData;
    IBOutlet UIWebView *webviewPolicy;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

- (IBAction)pressMenu:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end

