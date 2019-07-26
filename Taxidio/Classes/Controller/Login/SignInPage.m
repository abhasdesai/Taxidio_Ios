#import "SignInPage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SWRevealViewController.h"
#import  <LocalAuthentication/LocalAuthentication.h>

@interface SignInPage ()

@end

@implementation SignInPage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFontColor];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.frame = btnFBLogin.frame;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
    
    [loginButton
     addTarget:self
     action:@selector(facebookAuthButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewTextBoxes addSubview:loginButton];
    // TODO(developer) Configure the sign-in button look/feel
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
        viewGoogleBtn.frame = CGRectMake(20,20,200,200);
        [viewTextBoxes addSubview:loginButton];
        viewGoogleBtn.frame = btnGoogleLogin.frame;
        [viewTextBoxes addSubview:viewGoogleBtn];
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [sidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
    //if ([FBSDKAccessToken currentAccessToken]) {
        
        // User is logged in, do work such as go to next view controller.
    //}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Touch & FaceId code here
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *reason = @"Please authenticate using TouchID.";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                              if (success) {
                                  NSLog(@"Auth was OK");
                              }
                              else {
                                  //You should do better handling of error here but I'm being lazy
                                  NSLog(@"Error received: %d", error);
                              }
                          }];
    }
    else {
        NSLog(@"Can not evaluate Touch ID");
    }
    // [self checkForEmail];
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
}

#pragma mark - IBACTION METHODS

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email,first_name,last_name,picture.type(large),gender" forKey:@"fields"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 self.fbPhotoUrl = [[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
                 self.fbId = [result valueForKey:@"id"];
                 self.fbName = [result objectForKey:@"name"];
                 self.fbEmail = [result objectForKey:@"email"];
                 self.fbGender = [result objectForKey:@"gender"];
                 
                 if([self stringIsNilOrEmpty:self.fbEmail]==TRUE)
                     self.fbEmail = @"";
                 if([self stringIsNilOrEmpty:self.fbGender]==TRUE)
                     self.fbGender = @"";
                 
                 //                 if(self.fbEmail.length==0)
                 //                 {
                 //                     [self addEmailForFB];
                 //                 }
                 //                 else
                 //                 {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self checkFacebookLogin:self.fbId :self.fbName :self.fbGender :self.fbEmail :self. fbPhotoUrl];
                 });
                 //                 }
             }
         }];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                           parameters:@{@"fields": @"picture, name, email"}]
         
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
             if (!error) {
                 
                 
                 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                 dispatch_async(queue, ^(void) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         // you are authorised and can access user data from user info object
                         
                     });
                 });
                 
             }
             else{
                 
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
    else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Something went wrong! Please try again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"Login Cancel");
    }
    
    
    //        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
    //
    //        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
    //         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    //             if (!error)
    //             {
    //                 NSLog(@"results:%@",result);
    //
    //                 NSString *email = [result objectForKey:@"email"];
    //                 NSString *userId = [result objectForKey:@"id"];
    //
    //                 if (email.length >0 )
    //                 {
    //                     //Start you app Todo
    //                 }
    //                 else
    //                 {
    //                     NSLog(@"Facebook email is not verified");
    //                 }
    //            }
    //           else
    //           {
    //               NSLog(@"Error %@",error);
    //           }
    //       }];
    //    }
}


- (IBAction)facebookAuthButtonTapped:(id)sender
{
    //    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //    [login
    //     logInWithReadPermissions: @[@"public_profile",  @"user_friends", @"email"]
    //     fromViewController:self
    //     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    //         if (error) {
    //             NSLog(@"Process error======%@",error.description);
    //         } else if (result.isCancelled) {
    //             NSLog(@"Cancelled");
    //         } else
    //         {
    //             if ([FBSDKAccessToken currentAccessToken]) {
    //
    //
    //
    //                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , gender ,friendlists"}]
    //                  startWithCompletionHandler:^(
    //                                               FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    //                      if (!error)
    //                      {
    //                          [self fetchUserInfo];
    //                      }
    //                      else{
    //
    //                          NSLog(@"error is %@", error.description);
    //                      }
    //                  }];
    //             }
    //         }
    //     }];
    //
    //
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
    
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    
    //[self fetchUserInfo];
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        [self fetchUserInfo];
    }
    else
    {
        [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Login process error");
             }
             else if (result.isCancelled)
             {
                 NSLog(@"User cancelled login");
             }
             else
             {
                 NSLog(@"Login Success");
                 
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     NSLog(@"result is:%@",result);
                     [self fetchUserInfo];
                 }
                 else
                 {
                     NSLog(@"Facebook email permission error");
                 }
             }
         }];
    }
    
    
    //    ========OLD=========
    
    //    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //    //if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://profile/1959210047634242"]])
    //    {
    //        login.loginBehavior = FBSDKLoginBehaviorNative;
    //    }
    //
    //    [login logInWithReadPermissions:@[@"public_profile", @"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    //        if (error)
    //        {
    //            NSLog(@"Unexpected login error: %@", error);
    //            NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
    //            NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops ";
    //
    //            UIAlertController * alert=   [UIAlertController
    //                                          alertControllerWithTitle:alertTitle
    //                                          message:alertMessage
    //                                          preferredStyle:UIAlertControllerStyleAlert];
    //
    //            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //
    //            }];
    //            [alert addAction:okAction];
    //            [self presentViewController:alert animated:YES completion:nil];
    //        }
    //        else
    //        {
    //            if(result.token)   // This means if There is current access token.
    //            {
    //                NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    //                [parameters setValue:@"id,name,email,first_name,last_name,picture.type(large),gender" forKey:@"fields"];
    //                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
    //                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    //                     if (!error)
    //                     {
    //                         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //                         NSString *fbPhotoUrl = [[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
    //                         NSString *fbId = [result valueForKey:@"id"];
    //                         NSString *fbName = [result objectForKey:@"name"];
    //                         NSString *fbEmail = [result objectForKey:@"email"];
    //                         NSString *fbGender = [result objectForKey:@"gender"];
    //
    //                         if([self stringIsNilOrEmpty:fbEmail]==TRUE)
    //                            fbEmail = @"";
    //                         if([self stringIsNilOrEmpty:fbGender]==TRUE)
    //                            fbGender = @"";
    //
    //                         dispatch_async(dispatch_get_main_queue(), ^{
    //                             [self checkFacebookLogin:fbId :fbName :fbGender :fbEmail :fbPhotoUrl];
    //                         });
    //
    //                     }
    //                 }];
    //
    //                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
    //                                                   parameters:@{@"fields": @"picture, name, email"}]
    //
    //                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id userinfo, NSError *error) {
    //                     if (!error) {
    //
    //
    //                         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    //                         dispatch_async(queue, ^(void) {
    //                             dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                                 // you are authorised and can access user data from user info object
    //
    //                             });
    //                         });
    //
    //                     }
    //                     else{
    //
    //                         NSLog(@"%@", [error localizedDescription]);
    //                     }
    //                 }];
    //            }
    //            else{
    //                UIAlertController * alert=   [UIAlertController
    //                                              alertControllerWithTitle:@""
    //                                              message:@"Something went wrong! Please try again."
    //                                              preferredStyle:UIAlertControllerStyleAlert];
    //
    //                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //
    //                }];
    //                [alert addAction:okAction];
    //                [self presentViewController:alert animated:YES completion:nil];
    //
    //                NSLog(@"Login Cancel");
    //            }
    //        }
    //    }];
}

-(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

- (IBAction)pressSignInFB:(id)sender
{
    
    //    UIAlertController * alert=   [UIAlertController
    //                                  alertControllerWithTitle:@""
    //                                  message:@"This feature is under development."
    //                                  preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //
    //        //do something when click button
    //    }];
    //    [alert addAction:okAction];
    //    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    if (error) {
        // Process error
    }
    else if (result.isCancelled) {
        // Handle cancellations
    }
    else
    {
        [self fetchUserInfo];
        // Navigate to other view
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //Todo
}



- (IBAction)pressSignInGoogle:(id)sender
{
    
}

- (IBAction)pressSignIn:(id)sender
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *reason = @"Please authenticate using TouchID.";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                              if (success) {
                                  NSLog(@"Auth was OK");
                              }
                              else {
                                  //You should do better handling of error here but I'm being lazy
                                  NSLog(@"Error received: %@", error);
                              }
                          }];
    }
    else {
        NSLog(@"Can not evaluate Touch ID");
    }
    [self checkLogin];
    //    [Helper setPREFint:1 :PREF_CHECK_USER];
}

- (IBAction)pressSignUp:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)pressCloseBtn:(id)sender
{
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)pressForgotPasswd:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: @"Please enter your Email Address:"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email Address";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    NSArray * textfields = alertController.textFields;
                                    UITextField * namefield = textfields[0];
                                    NSLog(@"%@",namefield.text);
                                    [self forgotPassword:namefield.text];
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                {
                                }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Other Methods

-(void) setFontColor
{
    [self setBottomBorder:txtUserName];
    [self setBottomBorder:txtPassWord];
    
    txtPassWord.delegate = self;
    txtUserName.delegate = self;
    
    UIColor *color = [UIColor whiteColor];
    txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    txtPassWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
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
    [txtPassWord resignFirstResponder];
    [txtUserName resignFirstResponder];
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

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    NSString *userId = user.userID;                  // For client-side use only!
    //    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    //    NSString *givenName = user.profile.givenName;
    //    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    
    NSString *strImageUrl;
    CGSize thumbSize=CGSizeMake(500, 500);
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
        NSURL *imageURL = [user.profile imageURLWithDimension:dimension];
        strImageUrl = imageURL.absoluteString;
    }
    
    if([self stringIsNilOrEmpty:userId]==TRUE)
        userId = @"";
    NSString *strGender=@"1";
    if(userId.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkGoogleLogin :userId :fullName :strGender:email :strImageUrl];
        });
    }
}

- (IBAction)googlePlusButtonTouchUpInside:(id)sender {
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate=self;
    
    [GIDSignIn sharedInstance].clientID = @"302599165572-cn68b644nibj42964v9m1n4c08pc6td4.apps.googleusercontent.com";
    //  [GIDSignIn sharedInstance].clientID = @"302599165572-a36j3ldq70vgijnu2lgd4d26gvgrsk6f.apps.googleusercontent.com";
    [[GIDSignIn sharedInstance] signIn];
}


#pragma mark- ==== WebServiceMethod =======

//-(bool)wsCheckForUniqueEmailId :(NSString*)strEmailAddress
//{
//    @try{
//        SHOW_AI;
//        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    strEmailAddress,@"useremail",
//                                    nil];
//
//        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_CHECK_UNIQUE_EMAIL dicParams:Parameters];
//        wsLogin.isLogging=TRUE;
//        wsLogin.isSync=TRUE;
//        wsLogin.onSuccess=^(NSDictionary *dicResponce)
//        {
//            HIDE_AI;
//            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
//            NSString *strMessage = [dicResponce objectForKey:@"message"];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            if(intStatus==0)
//                isUnique = false;
//            else if(intStatus==1)
//                isUnique = true;
//        };
//        [wsLogin send];
//    }
//    @catch (NSException * e) {
//        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
//        NSLog(@"Exception: %@", e);
//    }
//    @finally {
//        // Added to show finally works as well
//    }
//    return isUnique;
//}
//
//-(void)wsUpdateEmailID :(NSString*)strEmailAddress
//{
//    @try{
//        SHOW_AI;
//        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [Helper getPREF:PREF_UID],@"userid",
//                                    strEmailAddress,@"useremail",
//                                    nil];
//
//        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_UPDATE_EMAIL_ID dicParams:Parameters];
//        wsLogin.isLogging=TRUE;
//        wsLogin.isSync=TRUE;
//        wsLogin.onSuccess=^(NSDictionary *dicResponce)
//        {
//            HIDE_AI;
//            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
//            NSString *strMessage = [dicResponce objectForKey:@"message"];
//            if(strMessage.length==0)
//                strMessage = MSG_NO_MESSAGE;
//
//            if(intStatus == 0)
//            {
//                if([strMessage isEqualToString:@"This Email already exists."])
//                    strMessage = @"Since the Email ID you entered has already been registered with us before, we request you to not log in via Facebook. Please use the default Sign In option instead.";
//                // Change Email Id // Sign In with Existing
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Sign In With Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                {
//                    CGRect screenRect;
//                    CGFloat screenHeight;
//                    CGFloat screenWidth;
//
//                    screenRect = [[UIScreen mainScreen] bounds];
//                    screenHeight = screenRect.size.height;
//                    screenWidth = screenRect.size.width;
//
//                    UIStoryboard* storyboard;
//                    if(screenHeight == 480 || screenHeight == 568)
//                        storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
//                    else
//                        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
//
//                    [self presentViewController:add animated:YES completion:nil];
//                    self.revealViewController.panGestureRecognizer.enabled = FALSE;
//                }];
//                [alert addAction:okAction];
////                UIAlertAction *logOutAction = [UIAlertAction actionWithTitle:@"Another Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
////
////                    //do something when click button
////                }];
////                [alert addAction:logOutAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//            else if(intStatus == 1)
//            {
//                NSObject *objUserData = [dicResponce valueForKey:@"data"];
//                NSString *strUID = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"userid"]];
//                //NSString *strToken = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"token"]];
//                NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
//                //NSString *strDesignation = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"designation"]];
//
//                NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
//                dictData = [[dicResponce valueForKey:@"data"]copy];
//
//                if([[dictData valueForKey:@"askforemail"]intValue]==1)
//                {
//                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"askforemail"];
//                }
//
//                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                [Helper setPREF:strUID :PREF_UID];
//                [Helper setPREF:strName :PREF_USER_NAME];
//                [Helper setPREF:[objUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
//                [Helper setPREF:[objUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
//
//                if(isChecked==TRUE)
//                    [Helper setPREFint:1 :PREF_CHECK_USER];
//                else
//                    [Helper setPREFint:0 :PREF_CHECK_USER];
//                [self dismissViewControllerAnimated:YES completion:nil];
//                [Helper setPREF:0 :@"askforemail"];
//            }
//        };
//        [wsLogin send];
//    }
//    @catch (NSException * e) {
//        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
//        NSLog(@"Exception: %@", e);
//    }
//    @finally {
//        // Added to show finally works as well
//    }
//}
//

-(void)forgotPassword :(NSString*)strEmailAddress
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strEmailAddress,@"useremail",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_FORGOT_PASSWORD dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
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
                //NSString *strToken = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"token"]];
                NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
                //NSString *strDesignation = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"designation"]];
                
                NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                dictData = [[dicResponce valueForKey:@"data"]copy];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [Helper setPREF:strUID :PREF_UID];
                [Helper setPREF:strName :PREF_USER_NAME];
                [Helper setPREF:[objUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
                
                if(isChecked==TRUE)
                    [Helper setPREFint:1 :PREF_CHECK_USER];
                else
                    [Helper setPREFint:0 :PREF_CHECK_USER];
                [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)checkLogin
{
    @try{
        NSString *strUDID = [Helper getPREF:PREF_DEVICE_UDID];
        if(strUDID.length==0)
            strUDID = @"";
        if([self checkTheValidationToSave] ==TRUE)
        {
            SHOW_AI;
            NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [Helper setPREF:strAppVersion :PREF_SERVER_VERSION_APP];
            
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        txtUserName.text,@"useremail",
                                        txtPassWord.text,@"userpassword",
                                        strUDID,PREF_DEVICE_UDID,
                                        //@"xyz",PREF_DEVICE_UDID,
                                        strAppVersion,PREF_APP_VERSION,
                                        @"2",PREF_DEVICE_TYPE,
                                        nil];
            
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_LOGIN_USER dicParams:Parameters];
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
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
                    HIDE_AI;
                }
                else if(intStatus == 1)
                {
                    NSObject *objUserData = [dicResponce valueForKey:@"data"];
                    NSString *strUID = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"userid"]];
                    NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
                    NSString *strEmailId = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"useremail"]];
                    
                    NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                    dictData = [[dicResponce valueForKey:@"data"]copy];
                    NSString *isSocial = [dictData valueForKey:@"issocial"];
                    [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [Helper setPREF:strUID :PREF_UID];
                    [Helper setPREF:strName :PREF_USER_NAME];
                    [Helper setPREF:strEmailId :PREF_USER_EMAIL];
                    [Helper setPREF:isSocial :PREF_USER_ISSOCIAL];
                    if(self->isChecked==TRUE)
                        [Helper setPREFint:1 :PREF_CHECK_USER];
                    else
                        [Helper setPREFint:0 :PREF_CHECK_USER];
                    //                    [self dismissViewControllerAnimated:YES completion:nil];
                    UIViewController *vc = self.presentingViewController;
                    while (vc.presentingViewController) {
                        vc = vc.presentingViewController;
                    }
                    [vc dismissViewControllerAnimated:YES completion:NULL];
                }
            };
            [wsLogin send];
        }
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

-(void)checkGoogleLogin :(NSString*)googleId :(NSString*)name : (NSString*)strGender :(NSString*)strEmail : (NSString*)strImgUrl
{//    [self checkGoogleLogin :userId :fullName :strGender :strImageUrl];
    
    @try{
        // SHOW_AI;
        NSString *strUDID = [Helper getPREF:PREF_DEVICE_UDID];
        if(strUDID.length==0)
            strUDID = @"";
        
        // if([self checkTheValidationToSave] ==TRUE)
        {
            NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [Helper setPREF:strAppVersion :PREF_SERVER_VERSION_APP];
            
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        googleId,@"googleid",
                                        name,@"username",
                                        strGender,@"usergender",
                                        strEmail,@"useremail",
                                        strImgUrl,@"socialimage",
                                        strUDID,PREF_DEVICE_UDID,
                                        //@"xyz",PREF_DEVICE_UDID,
                                        [Helper getPREF:PREF_SERVER_VERSION_APP],PREF_APP_VERSION,
                                        @"2",PREF_DEVICE_TYPE,
                                        nil];
            
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GOOGLE_LOGIN dicParams:Parameters];
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
            wsLogin.onSuccess=^(NSDictionary *dicResponce)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                    //NSString *strToken = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"token"]];
                    NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
                    //NSString *strDesignation = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"designation"]];
                    
                    NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                    dictData = [[dicResponce valueForKey:@"data"]copy];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [Helper setPREF:strUID :PREF_UID];
                    [Helper setPREF:strName :PREF_USER_NAME];
                    [Helper setPREF:[objUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
                    
                    NSString *isSocial = [dictData valueForKey:@"issocial"];
                    [Helper setPREF:isSocial :PREF_USER_ISSOCIAL];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    if(self->isChecked==TRUE)
                        [Helper setPREFint:1 :PREF_CHECK_USER];
                    else
                        [Helper setPREFint:0 :PREF_CHECK_USER];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            };
            [wsLogin send];
        }
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}


-(void)checkFacebookLogin :(NSString*)FBId :(NSString*)name : (NSString*)strGender :(NSString*)strEmail : (NSString*)strImgUrl
{//    [self checkGoogleLogin :userId :fullName :strGender :strImageUrl];
    
    @try{
        //            SHOW_AI;
        
        // if([self checkTheValidationToSave] ==TRUE)
        {
            NSString *strUDID = [Helper getPREF:PREF_DEVICE_UDID];
            if(strUDID.length==0)
                strUDID = @"";
            
            NSString *strAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [Helper setPREF:strAppVersion :PREF_SERVER_VERSION_APP];
            
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        FBId,@"facebookid",
                                        name,@"username",
                                        strGender,@"usergender",
                                        strEmail,@"useremail",
                                        strImgUrl,@"socialimage",
                                        strUDID,PREF_DEVICE_UDID,
                                        //@"xyz",PREF_DEVICE_UDID,
                                        [Helper getPREF:PREF_SERVER_VERSION_APP],PREF_APP_VERSION,
                                        @"2",PREF_DEVICE_TYPE,
                                        nil];
            
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_FACEBOOK_LOGIN dicParams:Parameters];
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=TRUE;
            wsLogin.onSuccess=^(NSDictionary *dicResponce)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
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
                    //NSString *strToken = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"token"]];
                    NSString *strName = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"username"]];
                    //NSString *strDesignation = [NSString stringWithFormat:@"%@",[objUserData valueForKey:@"designation"]];
                    
                    NSMutableDictionary *dictData = [[NSMutableDictionary  alloc] init];
                    dictData = [[dicResponce valueForKey:@"data"]copy];
                    
                    if([[dictData valueForKey:@"askforemail"]intValue]==1)
                    {
                        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"askforemail"];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [Helper setPREF:strUID :PREF_UID];
                    [Helper setPREF:strName :PREF_USER_NAME];
                    [Helper setPREF:[objUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
                    NSString *isSocial = [dictData valueForKey:@"issocial"];
                    [Helper setPREF:isSocial :PREF_USER_ISSOCIAL];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if(isChecked==TRUE)
                        [Helper setPREFint:1 :PREF_CHECK_USER];
                    else
                        [Helper setPREFint:0 :PREF_CHECK_USER];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    //    [self checkForEmail];
                }
            };
            [wsLogin send];
        }
    }
    @catch (NSException * e) {
        // NSError *error = [[NSError alloc] initWithDomain:e.name code:0 userInfo:e.userInfo];
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

//-(void)addEmailForFB
//{
//        UIAlertController * alertController = [UIAlertController
//                                               alertControllerWithTitle:@"Add Email"
//                                               message:@"Oops ! We couldn't find Email ID in your Facebook account. Please provide your Email ID."
//                                               preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"Email  Address";
//            textField.textColor = [UIColor blackColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.keyboardType = UIKeyboardTypeEmailAddress;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//        }];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//        {
//            NSArray * textfields = alertController.textFields;
//            UITextField * namefield = textfields[0];
//            NSLog(@"%@",namefield.text);
//            if(namefield.text.length>0 && ([Helper validateEmailWithString:namefield.text]==TRUE))
//            {
//                if([self wsCheckForUniqueEmailId : namefield.text]==true)
//                {
//                    self.fbEmail = namefield.text;
//                    [self checkFacebookLogin:self.fbId :self.fbName :self.fbGender :self.fbEmail :self. fbPhotoUrl];
//                }
//                else
//                {
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                    UIAlertController * alert=   [UIAlertController
//                                                  alertControllerWithTitle:@"Email Exists"
//                                                  message:@"Since the Email ID you entered has already been registered with us before, we request you to not log in via Facebook. Please use the default Sign In option instead."
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//
//                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Sign In With Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                                               {
//                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                                   NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//                                                   NSDictionary * dict = [defs dictionaryRepresentation];
//                                                   for (id key in dict) {
//                                                       [defs removeObjectForKey:key];
//                                                   }
//                                                   [defs synchronize];
//
//                                                   FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//                                                   [loginManager logOut];
//                                                   [FBSDKAccessToken setCurrentAccessToken:nil];
//                                                   [[GIDSignIn sharedInstance] signOut];
//                                               }];
//                    [alert addAction:okAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }
//            }
//            else
//            {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:@"Please enter valid Email ID."
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                    [self addEmailForFB];
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
//
//            }
//        }]];
//    [self presentViewController:alertController animated:YES completion:nil];
//
//}

//-(void)checkForEmail
//{
//    if([Helper getPREFint:@"askforemail"]==1)
//    {
////        [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//        UIAlertController * alertController = [UIAlertController
//                                                alertControllerWithTitle:@"Add Email"
//                                                message:@"Oops ! We couldn't find Email ID in your Facebook account. Please provide your Email ID."
//                                                preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"Email  Address";
//            textField.textColor = [UIColor blackColor];
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//        }];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                                    {
//                                        NSArray * textfields = alertController.textFields;
//                                        UITextField * namefield = textfields[0];
//                                        NSLog(@"%@",namefield.text);
//                                        [self updateLoginDetails:namefield.text];
//                                    }]];
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
//                                    {
//                                        [self logoutTheUser];
//                                    }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    else
//    {
//        //[MBProgressHUD hideHUDForView:self.view animated:YES];
//
//        UIViewController *vc = self.presentingViewController;
//        while (vc.presentingViewController) {
//            vc = vc.presentingViewController;
//        }
//        [vc dismissViewControllerAnimated:YES completion:NULL];
//    }
//}



//-(void)updateLoginDetails :(NSString*)strEmailAddress
//{
//    if([Helper validateEmailWithString:strEmailAddress]==TRUE)
//    {
//        [self wsUpdateEmailID:strEmailAddress];
////        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[Helper getPREFDict:@"UserDataDict"]];
////        [dict setValue:strEmailAddress forKey:@"useremail"];
////
////        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserDataDict"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////
////        [Helper setPREF:strEmailAddress :PREF_USER_EMAIL];
////        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//        [self checkForEmail];
//}

-(void)logoutTheUser
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    [[GIDSignIn sharedInstance] signOut];
    [self dismissViewControllerAnimated:YES completion:nil];
    [Helper setPREF:0 :@"askforemail"];
}


#pragma mark- ==== CheckEmptyTextFiled Method ====

-(BOOL)checkTheValidationToSave
{
    NSString *strMessage =@"";
    
    if([txtUserName.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_EMAIL_ID];
    }
    else if([txtPassWord.text isEqualToString:@""])
    {
        strMessage = [NSString stringWithFormat:@"%@",MSG_ENTER_PASSWORD];
    }
    else if (txtUserName.text.length>0 && [Helper validateEmailWithString:txtUserName.text] == FALSE)
    {
        strMessage = [NSString stringWithFormat:@"Please enter Valid EmailId."];
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

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    //Todo
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    //Todo
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    //Todo
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return parentSize;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    //Todo
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    //Todo
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    //Todo
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    //Todo
}

- (void)setNeedsFocusUpdate {
    //Todo
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return true;
}

- (void)updateFocusIfNeeded {
    //Todo
}

@end
