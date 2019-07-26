//
//  RegistrationVC.h
//  Taxidio
//
//  Created by E-Intelligence on 04/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

@interface RegistrationVC : UIViewController
{
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtEmailId;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPasswd;
    NSString *strUDIDToken;
    IBOutlet UIScrollView *scrollView;
    
}
- (IBAction)pressBack:(id)sender;
- (IBAction)pressCreateAccount:(id)sender;


@end
