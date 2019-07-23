//
//  FeedbackVC.h
//  Taxidio
//
//  Created by E-Intelligence on 13/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"
#import "Utilities.h"

@interface FeedbackVC : UIViewController
{
    IBOutlet UITextField *txtSubject;
    IBOutlet UITextView *txtFeedback;
    IBOutlet UIView *viewMainView;
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenwidth;
}

- (IBAction)pressClose:(id)sender;
- (IBAction)pressSubmitFeedback:(id)sender;

@end
