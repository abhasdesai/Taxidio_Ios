//
//  SignInPage.h
//  Taxidio
//
//  Created by E-Intelligence on 04/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "Utilities.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SignInPage : UIViewController <UITextFieldDelegate,GIDSignInUIDelegate, GIDSignInDelegate,FBSDKLoginButtonDelegate>
{
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassWord;
    IBOutlet UIButton *btnFBLogin;
    IBOutlet UIButton *btnGoogleLogin;
    IBOutlet UIView *viewTextBoxes;
    IBOutlet GIDSignInButton *viewGoogleBtn;
    
    IBOutlet UIButton *sidebarButton;
    BOOL isChecked;
    bool isUnique;
    
}

@property(nonatomic,retain) NSString *fbPhotoUrl;
@property(nonatomic,retain) NSString *fbId;
@property(nonatomic,retain) NSString *fbName;
@property(nonatomic,retain) NSString *fbEmail;
@property(nonatomic,retain) NSString *fbGender;


- (IBAction)pressSignInFB:(id)sender;
- (IBAction)pressSignInGoogle:(id)sender;
- (IBAction)pressSignIn:(id)sender;
- (IBAction)pressSignUp:(id)sender;


-(IBAction)pressCloseBtn:(id)sender;
-(IBAction)pressForgotPasswd:(id)sender;
- (IBAction)facebookAuthButtonTapped:(id)sender;

@end
