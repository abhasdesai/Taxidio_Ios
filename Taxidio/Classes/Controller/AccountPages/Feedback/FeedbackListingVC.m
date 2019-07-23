//
//  FeedbackListingVC.m
//  Taxidio
//
//  Created by E-Intelligence on 20/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "FeedbackListingVC.h"

@interface FeedbackListingVC ()

@end

@implementation FeedbackListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
//    [self checkLogin];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    tblView.allowsSelection = FALSE;

    noOfPage = 1;
    total_page = 0;
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
        [self checkLogin];
//    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)checkLogin
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        self.revealViewController.panGestureRecognizer.enabled = TRUE;
   }
    else
    {
        [btnUserMenu addTarget:self action:@selector(showLoginPage:) forControlEvents:UIControlEventTouchUpInside];
        self.revealViewController.panGestureRecognizer.enabled = FALSE;
   }
}

-(IBAction)showLoginPage:(id)sender
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        [btnUserMenu addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    else
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
        
        [self presentViewController:add animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    viewFeedbackPreview.hidden = TRUE;
    [self loadFeedbackDetails:noOfPage];
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    for (id object in cell.contentView.subviews)
    {
        [object removeFromSuperview];
    }

    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(5,5,300,30)];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [[_arrData valueForKey:@"subject"] objectAtIndex:indexPath.row];
    [cell.contentView addSubview:lblTitle];
    
    UILabel *lblDate = [[UILabel alloc]initWithFrame:CGRectMake(5,35,200,30)];
    lblDate.textColor = [UIColor blackColor];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.text = [[_arrData valueForKey:@"created"] objectAtIndex:indexPath.row];
    lblDate.font = [UIFont systemFontOfSize:11];
    [cell.contentView addSubview:lblDate];

    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setImage:[UIImage imageNamed:@"delete_trip"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(deleteFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.tag = indexPath.row;
    btnDelete.frame = CGRectMake(self.view.frame.size.width-50,35,26,26);

    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setImage:[UIImage imageNamed:@"edit_date_trip"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editFeedbackTapped:) forControlEvents:UIControlEventTouchUpInside];
    btnEdit.tag = indexPath.row;
    btnEdit.frame = CGRectMake(self.view.frame.size.width-100,35,26,26);

    [cell.contentView addSubview:btnDelete];
    [cell.contentView addSubview:btnEdit];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *buttonDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                    {
//                                        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
//                                        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
//                                                                    {
//                                                                        NSObject *feedbackObj = [_arrData objectAtIndex:indexPath.row];
//                                                                        //if ([appDelegate checkInternetConnection:0]==TRUE)
//                                                                        {
//                                                                            [self deleteFeedbackSelected:[feedbackObj valueForKey:@"id"]];
//                                                                        }
//                                                                    }]];
//                                        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
//                                        [self presentViewController:alertController animated:YES completion:nil];
//                                    }];
//    buttonDelete.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
//    UITableViewRowAction *buttonEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"View" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                          {
//                                                  NSObject *feedbackObj = [_arrData objectAtIndex:indexPath.row];
//                                                  viewFeedbackPreview.hidden = FALSE;
//                                                  lblSubjectView.text = [feedbackObj valueForKey:@"subject"];
//                                                  [webviewFeedbackView loadHTMLString:[[NSString stringWithFormat:@"%@",[feedbackObj valueForKey:@"message"]] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
//                                          }];
//    buttonEdit.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0];
//    return @[buttonDelete,buttonEdit];
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (IBAction)pressCloseFeedbackView:(id)sender
{
    viewFeedbackPreview.hidden = TRUE;
}

- (IBAction)pressMenuBtn:(id)sender
{
    
}

- (IBAction)pressAddFeedback:(id)sender
{
    if([Helper getPREFint:@"askforemail"]==0)
    {
        [self performSegueWithIdentifier:@"segueAddFeedback" sender:self];
    }
    else{
        [self checkForEmail];
    }
}

-(void)checkForEmail
{
        UIAlertController * alertController = [UIAlertController
                                               alertControllerWithTitle:@"Add Email"
                                               message:@"Oops ! We couldn't find Email ID in your Facebook account. Please provide your Email ID."
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Email  Address";
            textField.textColor = [UIColor blackColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    {
                                        NSArray * textfields = alertController.textFields;
                                        UITextField * namefield = textfields[0];
                                        NSLog(@"%@",namefield.text);
                                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                                        [self updateLoginDetails:namefield.text];
                                    }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
}

-(void)updateLoginDetails :(NSString*)strEmailAddress
{
    if([Helper validateEmailWithString:strEmailAddress]==TRUE)
    {
        [self wsUpdateEmailID:strEmailAddress];
        //        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[Helper getPREFDict:@"UserDataDict"]];
        //        [dict setValue:strEmailAddress forKey:@"useremail"];
        //
        //        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"UserDataDict"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //        [Helper setPREF:strEmailAddress :PREF_USER_EMAIL];
        //        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self checkForEmail];
    }
}

- (IBAction)deleteFeedbackTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    NSObject *feedbackObj = [_arrData objectAtIndex:i];
                                    {
                                        [self deleteFeedbackSelected:[feedbackObj valueForKey:@"id"]];
                                    }
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (IBAction)editFeedbackTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);

    NSObject *feedbackObj = [_arrData objectAtIndex:i];
    viewFeedbackPreview.hidden = FALSE;
    lblSubjectView.text = [feedbackObj valueForKey:@"subject"];
    [webviewFeedbackView loadHTMLString:[[NSString stringWithFormat:@"%@",[feedbackObj valueForKey:@"message"]] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];

}
#pragma mark- ==== WebServiceMethod =======
-(void)loadFeedbackDetails : (int)noPage
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_FEEDBACK_LIST dicParams:Parameters];
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
            else
            {
                total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                _arrData = [dicResponce valueForKey:@"data"];
                [tblView reloadData];
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

-(void)deleteFeedbackSelected : (NSString*)strFeedbackId
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%@",strFeedbackId],@"feedback_id",
                                    nil];

        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_DELETE_FEEDBACK dicParams:Parameters];
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
            else
            {
                [self loadFeedbackDetails:1];
                [tblView reloadData];
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

-(void)wsUpdateEmailID :(NSString*)strEmailAddress
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strEmailAddress,@"useremail",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_UPDATE_EMAIL_ID dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            
            if(intStatus == 0)
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Email Exists"
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                               [self checkForEmail];
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
                
//                if(isChecked==TRUE)
//                    [Helper setPREFint:1 :PREF_CHECK_USER];
//                else
//                    [Helper setPREFint:0 :PREF_CHECK_USER];
                [self performSegueWithIdentifier:@"segueAddFeedback" sender:self];
                [Helper setPREF:0 :@"askforemail"];
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


@end
