//
//  MenuPageVCViewController.h
//  Taxidio
//
//  Created by E-Intelligence on 13/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "Utilities.h"

@interface MenuPageVCViewController : UIViewController <MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIView *viewMainView;
    IBOutlet UIView *viewHeader;
}
- (IBAction)pressCloseBtn:(id)sender;
- (IBAction)pressHomeBtn:(id)sender;
- (IBAction)pressChroniclesBtn:(id)sender;
- (IBAction)pressHotelsBtn:(id)sender;
- (IBAction)pressAttactions:(id)sender;
- (IBAction)pressMyTrips:(id)sender;
- (IBAction)pressDestinations:(id)sender;
- (IBAction)pressReferFriend:(id)sender;
- (IBAction)pressLogOut:(id)sender;
- (IBAction)pressUserProfile:(id)sender;

@end
