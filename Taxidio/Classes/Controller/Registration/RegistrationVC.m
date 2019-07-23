//
//  RegistrationVC.m
//  Taxidio
//
//  Created by E-Intelligence on 04/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "RegistrationVC.h"
#import <Security/Security.h>
#import <LocalAuthentication/LocalAuthentication.h>
#define SERVICE_NAME @"Taxidio"
#define GROUP_NAME @"com.taxidio-app.taxidio"
@interface RegistrationVC ()

@end

@implementation RegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFontColor];
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBACTION METHODS

- (IBAction)pressBack:(id)sender
{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    UIStoryboard* storyboard;
    if(screenHeight == 480 || screenHeight == 568)
        storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
    else
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
    
    [self presentViewController:add animated:NO completion:nil];
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressCreateAccount:(id)sender {
    NSURLCredential * credential;
    NSURLProtectionSpace *loginProtectionSpace;
    credential = [NSURLCredential credentialWithUser:txtEmailId.text password:txtPassword.text persistence:NSURLCredentialPersistencePermanent];
    
    NSURL *url = [NSURL URLWithString:@"http://beta.taxidio.com"];
    loginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:url.host
                                                                 port:[url.port integerValue]
                                                             protocol:url.scheme
                                                                realm:nil             authenticationMethod:nil];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:loginProtectionSpace];

    if([self checkTheValidationToSave] ==TRUE)
    {
        [self SaveRegistration];
    }
}

- (void)tokenAvailableNotification:(NSNotification *)notification {
    strUDIDToken = (NSString *)notification.object;
    NSLog(@"new token available : %@", strUDIDToken);
    [Helper setPREF:strUDIDToken:PREF_DEVICE_UDID];
}

#pragma mark- ==== WebServiceMethod =======

-(void)SaveRegistration
{
    @try{
        SHOW_AI;
        
        NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [Helper setPREF:strAppVersion :PREF_APP_VERSION];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenAvailableNotification:)
                                                     name:@"NEW_TOKEN_AVAILABLE"
                                                   object:nil];
        
        NSString *strUDID = [Helper getPREF:PREF_DEVICE_UDID];
        if(strUDID.length==0)
            strUDID = @"";
        
        
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    txtName.text,@"username",
                                    txtEmailId.text,@"useremail",
                                    txtPassword.text,@"userpassword",
                                    strUDID,PREF_DEVICE_UDID,
                                    //                                    @"xyz",@"device_udid",
                                    strAppVersion,@"device_version",
                                    @"2",@"device_type",
                                    nil];
        
        for(NSString *key in [Parameters allKeys]) {
            NSLog(@"--->%@",[Parameters objectForKey:key]);
        }
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SIGN_UP dicParams:Parameters];
        
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=FALSE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(intStatus == 1)
            {
                NSObject *objUserData = [dicResponce valueForKey:@"data"];
                NSString *strUID = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"userid"]];
                NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
                NSString *strEmailId = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"useremail"]];
                
                NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                dictData = [[dicResponce valueForKey:@"data"]copy];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [Helper setPREF:strUID :PREF_UID];
                [Helper setPREFint:0 :PREF_CHECK_USER];
                [Helper setPREF:strName :PREF_USER_NAME];
                [Helper setPREF:strEmailId :PREF_USER_EMAIL];
                if ([UIScreen mainScreen].scale == 2.0f && [UIScreen mainScreen].bounds.size.height == 568.0f)
                {
                    [scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                }
                else
                {
                    [scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                }
                UIViewController *vc = self.presentingViewController;
                while (vc.presentingViewController) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:YES completion:NULL];
            }
        };
        [wsLogin send];
        
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well        
    }
}


#pragma mark- ==== CheckEmptyTextFiled Method ====

-(BOOL)checkTheValidationToSave
{
    NSString *strMessage =@"";
    // txtName.text = [Helper removeWhiteSpaceString:txtName.text];
    if([txtName.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_NAME];
    }
    else if([txtEmailId.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_EMAIL_ID];
    }
    else if (txtEmailId.text.length>0 && [Helper validateEmailWithString:txtEmailId.text] == FALSE)
    {
        strMessage = [NSString stringWithFormat:@"Please enter Valid EmailId."];
    }
    else if([txtPassword.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_PASSWORD];
    }
    else if([txtConfirmPasswd.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_CONFIRM_PASSWORD];
    }
    else if (txtEmailId.text.length>0 && [Helper validateEmailWithString:txtEmailId.text] == FALSE)
    {
        strMessage = [NSString stringWithFormat:@"Please enter Valid EmailId."];
    }
    else if (![txtPassword.text isEqualToString:txtConfirmPasswd.text])
    {
        strMessage = [NSString stringWithFormat:@"Password does not match with confirm password."];
    }
    else if (txtPassword.text.length<6)
    {
        strMessage = [NSString stringWithFormat:@"Password must contain atleast 6 characters."];
    }
    
    if(strMessage.length > 0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:strMessage
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return  FALSE;
    }
    
    return TRUE;
}


#pragma mark - Other Methods

-(void) setFontColor
{
    [self setBottomBorder:txtName];
    [self setBottomBorder:txtEmailId];
    [self setBottomBorder:txtPassword];
    [self setBottomBorder:txtConfirmPasswd];
    
    UIColor *color = [UIColor whiteColor];
    txtName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    txtEmailId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    txtConfirmPasswd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)setBottomBorder : (UITextField*) txtfield
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, txtfield.frame.size.height - 2, txtfield.frame.size.width, 5.0f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    [txtfield.layer addSublayer:bottomBorder];
}

-(void)dismissKeyboard {
    [txtName resignFirstResponder];
    [txtEmailId resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPasswd resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - keyboard movements

- (void)keyboardWillShow:(NSNotification *)notification
{
    //    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -100;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

-(void) showMessage:(NSString*)text
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Info"
                                                     message:text
                                                    delegate:nil
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert show];
}

@end
