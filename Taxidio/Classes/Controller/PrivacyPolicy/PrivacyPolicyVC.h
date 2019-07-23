//
//  PrivacyPolicyVC.h
//  Taxidio
//
//  Created by E-Intelligence on 12/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"


@interface PrivacyPolicyVC : UIViewController
{
    IBOutlet UIButton *btnMenu,*btnUserMenu;
    NSMutableDictionary *dictData;
    IBOutlet UIWebView *webviewPolicy;
}
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

- (IBAction)pressMenu:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end
