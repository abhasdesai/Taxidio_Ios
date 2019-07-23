//
//  RightViewController.m
//  Tab bar Sample
//
//  Created by MCN MAC2 on 16/11/2015.
//  Copyright © 2015 MCN MAC2. All rights reserved.
//

#import "RightViewController.h"
#import "SWRevealViewController.h"


@interface RightViewController (){
    NSArray *menu;
}

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    menu = @[@"Dash Board", @"My Profile", @"My Trips", @"Feedback",@"My Itinerary Questions", @"Change Password"];

    //scroll designing
    self.tableView.separatorColor = [UIColor whiteColor];
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tableView.tableHeaderView.frame = CGRectMake(self.tableView.tableHeaderView.frame.origin.x,self.tableView.tableHeaderView.frame.origin.y,self.tableView.tableHeaderView.frame.size.width,90);
// for Backgound Image
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
//    self.tableView.backgroundView = imageView;
//
    self.view.layer.borderWidth = .6;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


#pragma mark- ==== WebServiceMethod =======
-(void)loadProfileData
{
    @try{
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_USER_DETAILS dicParams:Parameters];
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
                    
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                //NSMutableDictionary *dictData = [dicResponce valueForKey:@"data"];
                
                NSMutableDictionary *mutableDict = [[[dicResponce valueForKey:@"data"]valueForKey:@"user"] mutableCopy];
                
                NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
                for (NSString * key in [mutableDict allKeys])
                {
                    if (![[mutableDict objectForKey:key] isKindOfClass:[NSNull class]])
                        [prunedDictionary setObject:[mutableDict objectForKey:key] forKey:key];
                }
                
                NSMutableDictionary *dictData = [prunedDictionary mutableCopy];//[dicResponce valueForKey:@"data"];
                
                
                NSString *strPassport1 = [dictData valueForKey:@"passport"];
                NSString *striserimage = [dictData valueForKey:@"userimage"];
                //[strMultiData isEqual:[NSNull null]] || [strMultiData isEqualToString:@"<null>"]
                if(!strPassport1.length)
                {
                    [dictData setValue:@"" forKey:@"passport"];
                }
                if(!striserimage.length)
                {
                    [dictData setValue:@"" forKey:@"userimage"];
                }
                
                int issocial = [[Helper getPREF:PREF_USER_ISSOCIAL]intValue];
                NSMutableArray *arrUserData = [[NSMutableArray alloc]init];
                arrUserData = [dictData mutableCopy];//[dictData valueForKey:@"user"];
                
                //NSString *strGender = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"gender"]];
                
                [Helper setPREF:[arrUserData valueForKey:@"username"] :PREF_USER_NAME];
                [Helper setPREF:[arrUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];
                
                //NSString *strSocialImg = [arrUserData valueForKey:@"socialimage"];
                NSString *strurl;
                if(issocial !=0)
                {
                    strurl = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"socialimage"]];
                }
                else{
                    if(![strurl containsString:@"http"])
                        strurl = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[arrUserData valueForKey:@"userimage"]];
                }
                strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *url = [NSURL URLWithString:strurl];
                NSData *data = [NSData dataWithContentsOfURL:url];
                //UIImage *img = [[UIImage alloc] initWithData:data];
                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.tableView reloadData];
            }
        };
        [wsLogin send];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    int issocial = [[Helper getPREF:PREF_USER_ISSOCIAL]intValue];
    
    if(issocial==0)
        menu = @[@"Dash Board", @"My Profile", @"My Trips",@"Invited Trips", @"Feedback",@"Itinerary Forum",@"Change Password"];
    else
        menu = @[@"Dash Board", @"My Profile", @"My Trips",@"Invited Trips", @"Feedback",@"Itinerary Forum"];
    
    [self.tableView reloadData];

    //if([Helper getPREF:PREF_UID].length>0)
//    {
//        self.tableView.hidden = FALSE;
//        //[self.tableView reloadData];
//    }
//    else
//    {
//        //self.tableView.hidden = true;
//    }
//    else
//    {
//        UIStoryboard* storyboard;
//        CGRect screenRect;
//        CGFloat screenHeight;
//        CGFloat screenWidth;
//        screenRect = [[UIScreen mainScreen] bounds];
//        screenHeight = screenRect.size.height;
//        screenWidth = screenRect.size.width;
//
//        if(screenHeight == 480 || screenHeight == 568)
//            storyboard = [UIStoryboard storyboardWithName:@"Main_5s" bundle:nil];
//        else
//        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        SignInPage *add = [storyboard instantiateViewControllerWithIdentifier:@"SignInPage"];
//        [self presentViewController:add animated:YES completion:nil];
//    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self loadProfileData];
//    });
    
    [self performSelector:@selector(loadProfileData) withObject:nil afterDelay:3.0];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[self.tbl reloadData];
//        [self loadProfileData];
//    });
}

-(IBAction)logOutUser:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:@"Are you sure you want to Log Out?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
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
                                   [self performSegueWithIdentifier:@"segueLogOut" sender:self];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[menu objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    tableView.separatorColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    if(indexPath.row==6)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                                  message: @"Change Password"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *txtOldPasswd) {
            txtOldPasswd.placeholder = @"Old Password";
            txtOldPasswd.textColor = [UIColor darkGrayColor];
            txtOldPasswd.secureTextEntry = TRUE;
            txtOldPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtOldPasswd.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *txtNewPasswd) {
            txtNewPasswd.placeholder = @"New Password";
            txtNewPasswd.textColor = [UIColor darkGrayColor];
            txtNewPasswd.secureTextEntry = TRUE;
            txtNewPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtNewPasswd.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *txtConfirmPasswd) {
            txtConfirmPasswd.placeholder = @"Confirm Password";
            txtConfirmPasswd.textColor = [UIColor darkGrayColor];
            txtConfirmPasswd.secureTextEntry = TRUE;
            txtConfirmPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtConfirmPasswd.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        NSArray * textfields = alertController.textFields;
                                        UITextField *txtOld  = textfields[0];
                                        UITextField *txtNew  = textfields[1];
                                        UITextField *txtConfirm  = textfields[2];
                                        [self changePassword:txtOld.text :txtNew.text :txtConfirm.text];
                                    }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"    ";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection: (NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = [UIColor whiteColor];
    if([Helper getPREF:PREF_UID].length>0)
    {
        CGRect screenRect;
        CGFloat screenHeight;
        CGFloat screenWidth;
        
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        UIImageView *imgHeader;
        UILabel *lblUserEmail;
        UILabel *lblUserName;
        UIButton *btnLogOut;

        if(screenHeight == 480 || screenHeight == 568)
        {
            imgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(60,10,150,150)];
            lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(40,170,200,25)];
            lblUserEmail = [[UILabel alloc]initWithFrame:CGRectMake(40,205,200,25)];
            btnLogOut = [[UIButton alloc]initWithFrame:CGRectMake(190,10,44,44)];
        }
        else
        {
            imgHeader = [[UIImageView alloc]initWithFrame:CGRectMake(100,10,150,150)];
            lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(60,170,200,25)];
            lblUserEmail = [[UILabel alloc]initWithFrame:CGRectMake(60,205,200,25)];
            btnLogOut = [[UIButton alloc]initWithFrame:CGRectMake(240,10,44,44)];
        }
        imgHeader.layer.cornerRadius = imgHeader.frame.size.height/2.0;
        imgHeader.layer.borderColor = COLOR_ORANGE.CGColor;
        imgHeader.layer.borderWidth = 2;
        imgHeader.clipsToBounds = YES;
    //  imgHeader.image = [UIImage imageNamed:@"user_icon"];
        
        NSMutableDictionary *dict = [Helper getPREFDict:@"UserDataDict"];
        NSString *strSocialImg = [dict valueForKey:@"socialimage"];
        NSString *strIsSocial;
        if(strSocialImg.length>0)
            strIsSocial = @"1";
        else
            strIsSocial = @"0";
        
        NSString *strImg = [dict valueForKey:@"userimage"];
        NSString *strurl = @"";
        
        int issocial = [[Helper getPREF:PREF_USER_ISSOCIAL]intValue];
        //NSString *strSocialImage = [dictData valueForKey:@"socialimage"];
        if(issocial !=0)
        {
            strurl = [NSString stringWithFormat:@"%@",[dict valueForKey:@"socialimage"]];
        }
        else{
            if(![strurl containsString:@"http"])
                strurl = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,strImg];
        }

    //    if([strIsSocial isEqualToString:@"0"])
    //    {
    ////        strurl = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userimage"]];
    //        if(![strurl containsString:@"http"])
    //            strurl = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,strImg];
    //    }
    //    else
    //        strurl = [NSString stringWithFormat:@"%@",[dict valueForKey:@"socialimage"]];
        
        strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:strurl];
        //                dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        //                dispatch_async(qLogo, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if(data)
        {
            imgHeader.image = img;
        }
        else
        {
            imgHeader.image = [UIImage imageNamed:@"no_image_attraction"];
        }
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfileScreen:)];
        singleTap.numberOfTapsRequired = 1;
        [imgHeader setUserInteractionEnabled:YES];
        [imgHeader addGestureRecognizer:singleTap];
        
        strName = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_USER_NAME]];
        strEmail = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_USER_EMAIL]];

        lblUserName.clearsContextBeforeDrawing = YES;
        
        lblUserName.text = strName;
        lblUserName.textColor = [UIColor blackColor];
        lblUserName.font = [UIFont systemFontOfSize:17];
        lblUserName.backgroundColor = [UIColor whiteColor];
        lblUserName.textAlignment = NSTextAlignmentCenter;
    //    lblUserName.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];

        lblUserEmail.clearsContextBeforeDrawing = YES;
        lblUserEmail.text = strEmail;
        lblUserEmail.font = [UIFont systemFontOfSize:13];
        lblUserEmail.textColor = [UIColor blackColor];
        lblUserEmail.backgroundColor = [UIColor whiteColor];
        lblUserEmail.textAlignment = NSTextAlignmentCenter;

    //    lblUserEmail.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];

        [btnLogOut setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [btnLogOut addTarget:self action:@selector(logOutUser:) forControlEvents:UIControlEventTouchUpInside];

        [header.contentView addSubview:imgHeader];
        [header.contentView addSubview:lblUserName];
        [header.contentView addSubview:lblUserEmail];
        [header.contentView addSubview:btnLogOut];
    }
    else
    {
        UIButton *btnLogOut = [[UIButton alloc]initWithFrame:CGRectMake(240,10,44,44)];
        [btnLogOut setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [btnLogOut addTarget:self action:@selector(logOutUser:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(IBAction)openProfileScreen:(id)sender
{
    [self performSegueWithIdentifier:@"segueProfile" sender:self];
}

#pragma mark- ==== WebServiceMethod =======
-(void)changePassword :(NSString*)strOldPassword : (NSString*)strNewPassword :(NSString*)strConfirmPassword
{
    NSString *newPassword;
    if([strNewPassword isEqualToString:strConfirmPassword])
    {
        newPassword = strNewPassword;
        {
            @try{
                SHOW_AI;
                NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            strOldPassword, @"currentpassword",
                                            newPassword, @"newpassword",
                                            [Helper getPREF:PREF_UID],@"userid",
                                            nil];
                
                WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_CHANGE_PASSWORD dicParams:Parameters];
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
                        
                    }
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:strMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
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
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"New Password does not match with confirm password."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
