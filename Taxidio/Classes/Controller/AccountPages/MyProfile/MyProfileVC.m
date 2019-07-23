//
//  MyProfileVC.m
//  Taxidio
//
//  Created by E-Intelligence on 17/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MyProfileVC.h"

@interface MyProfileVC ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) GKImagePicker *imagePicker;

@end

@implementation MyProfileVC
@synthesize ParametersEditData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self checkLogin];
   // [btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[self.tbl reloadData];
//        [self loadProfileData];
//    });
    viewCountryList.hidden = true;
    viewTagList.hidden = true;
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    
    arrTemp = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.tbl reloadData];
        [self loadProfileData];
        [self wsShowAllSOSContactDetails];
    });
    isTagTbl = FALSE;

}

//{"id":"14","flag":0}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];

//    arrTemp = [[NSMutableArray alloc]init];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //[self.tbl reloadData];
//        [self loadProfileData];
//    });
//    isTagTbl = FALSE;

//    strTagIDs = [self.Parameters valueForKey:@"tag_ids"];

//
//    if(strTagIDs.length==0)
//        arrTemp = [[NSMutableArray alloc]init];
//    else
//    {
//        NSArray *arr = [strTagIDs componentsSeparatedByString:@","];
//        arrTemp = [[NSMutableArray alloc]initWithArray:arr];
//    }
    
    [self setTagNameForTagId];
    if(strTagIDs.length==0)
        strTagIDs = @"";
    //    self.revealViewController.panGestureRecognizer.enabled = FALSE;
}

-(void)showTagView
{
    [self.view endEditing:YES];
    if(strTagIDs.length==0)
        arrTemp = [[NSMutableArray alloc]init];
    else
    {
        NSArray *arr = [strTagIDs componentsSeparatedByString:@","];
        arrTemp = [[NSMutableArray alloc]initWithArray:arr];
    }
    viewTagList.hidden = FALSE;
    isTagTbl = TRUE;
    [tblViewTagList reloadData];
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
}

- (void)viewDidLayoutSubviews
{
    [self setBottomBorderView:viewTxtName];
    [self setBottomBorderView:viewTxtEmail];
    [self setBottomBorderView:viewDOB];
    [self setBottomBorderView:viewTxtPassport];
    [self setBottomBorderView:viewPhoneNo];
    
    if(screenHeight == 480 || screenHeight == 568)
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.2)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.1)];
    }
}

-(IBAction)btnMale:(id)sender
{
    [Helper setPREF:btnMale.titleLabel.text :PREF_GENDER];
    imgMale.image = [UIImage imageNamed:@"radio_button_selected.png"];
    imgFemale.image = [UIImage imageNamed:@"radio_button_unselected.png"];
    [self removeKeyboard];
}

-(void)removeKeyboard
{
    [txtName resignFirstResponder];
    [txtDOB resignFirstResponder];
    [txtEmailID resignFirstResponder];
    [txtPassportNo resignFirstResponder];
    [txtPhoneNo resignFirstResponder];
    [viewDate removeFromSuperview];
}

-(IBAction)btnFemale:(id)sender
{
    [Helper setPREF:btnFemale.titleLabel.text :PREF_GENDER];
    imgFemale.image = [UIImage imageNamed:@"radio_button_selected.png"];
    imgMale.image = [UIImage imageNamed:@"radio_button_unselected.png"];
    [self removeKeyboard];
}

- (IBAction)pressSelectCountry:(id)sender
{
    viewCountryList.hidden = FALSE;
}

- (IBAction)pressSelectTags:(id)sender
{
    viewTagList.hidden = FALSE;
     isTagTbl = TRUE;
    [tblViewTagList reloadData];
}

- (IBAction)pressSelectSOS  :(id)sender
{
    [self performSegueWithIdentifier:@"segueAddSOSContact" sender:self];
}


- (IBAction)pressMenu:(id)sender
{
    
}

- (IBAction)pressProfileBtn:(id)sender
{
    
}

-(IBAction)MaleFemaleBtnTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    if(i==1)
        isMale = TRUE;
    else if(i==2)
        isMale = FALSE;
    
    if(isMale == NO)
    {
        [btnMale setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnFemale setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    else
    {
        [btnFemale setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnMale setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
}

-(IBAction)pressSaveEditProfile:(id)sender
{
    if(txtName.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please enter name."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(strCountryId.length==0 || [strCountryId isEqualToString:@"0"])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please select country."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (txtDOB.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please select date."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProfile];
        });
    }
}


#pragma mark- TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtPassportNo)
    {
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        
        if(screenHeight == 480)
        {
            pt.y +=220;
            [scrollView setContentOffset:pt animated:YES];
        }
        
        if(screenHeight == 568)
        {
            pt.y +=275;
            [scrollView setContentOffset:pt animated:YES];
        }
        
        if(screenHeight == 667)
        {
            pt.y +=345;
            [scrollView setContentOffset:pt animated:YES];
        }
    }
    if(textField == txtName)
    {
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollView];
        pt = rc.origin;
        pt.x = 0;
        
        if(screenHeight == 480)
        {
            pt.y -=170;
            [scrollView setContentOffset:pt animated:YES];
        }
    }
    if(textField == txtDOB)
    {
        viewDate = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-225, self.view.frame.size.width, 225)];
        viewDate.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(pressDoneDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Done" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_DARK_BLUE forState:UIControlStateNormal];
        button.frame = CGRectMake(viewDate.frame.size.width - 60, 5, 50.0, 25.0);
        [viewDate addSubview:button];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35,self.view.frame.size.width,190)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor whiteColor];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";

        NSDate *dateDOB = [dateFormatter dateFromString:strBDate];
        if(txtDOB.text.length==0)
            datePicker.date = [NSDate date];
        else
        datePicker.date = dateDOB;

        [datePicker addTarget:self action:@selector(changeTextFieldValue:) forControlEvents:UIControlEventValueChanged];
        [viewDate addSubview:datePicker];
        
        [self.view addSubview:viewDate];
        [textField resignFirstResponder];
    }
    if (textField == txtName || textField == txtPhoneNo || textField == txtEmailID ||textField == txtPassportNo)
    {
        [viewDate removeFromSuperview];
        return YES;
    }
    else
    {
        [txtName resignFirstResponder];
        [txtPhoneNo resignFirstResponder];
        [txtPassportNo resignFirstResponder];
        [txtEmailID resignFirstResponder];
        [viewDate setHidden:NO];
        return NO;
    }
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if ([UIScreen mainScreen].scale == 2.0f && [UIScreen mainScreen].bounds.size.height == 568.0f)
//    {
//        [scrollView setFrame:CGRectMake(0, self.view.frame.origin.y-viewTextData.frame.size.height, viewTextData.frame.size.width, viewTextData.frame.size.height)];
//    }
//    else
//    {
//        [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-viewTextData.frame.size.height, viewTextData.frame.size.width, viewTextData.frame.size.height)];
//    }
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)pressDoneDatePicker:(id)sender
{
  //  if(txtDOB.text.length==0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        if(txtDOB.text.length==0)
            txtDOB.text = [dateFormat stringFromDate:[NSDate date]];
        strBDate = txtDOB.text;
    }
    viewDate.hidden = TRUE;
}


-(void)changeTextFieldValue:(id)sender
{
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date ];
    txtDOB.text = dateString;
}

-(void)setBottomBorderView : (UIView*) view1
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(15.0f, view1.frame.size.height - 1, view1.frame.size.width-30, 1.0f);
    bottomBorder1.backgroundColor = [UIColor grayColor].CGColor;
    [view1.layer addSublayer:bottomBorder1];
}

#pragma mark ========TAG LISTING ===========


- (IBAction)pressDoneTagListing:(id)sender
{
    NSLog(@"%@",arrTemp);
    strTagIDs = [arrTemp componentsJoinedByString:@","];
    viewTagList.hidden = TRUE;
    isTagTbl = FALSE;
    [self setTagNameForTagId];
}

-(void)setTagNameForTagId
{
    NSMutableArray *arrTagName = [[NSMutableArray alloc]init];
    NSString *strId = @"";
//    for(int i=0;i<arrTagData.count;i++)
//    {
//        int tempNo = [[[arrTagData valueForKey:@"flag"]objectAtIndex:i]intValue];
//        if(tempNo==1)
//        {
//            strId = [[arrTagData valueForKey:@"id"]objectAtIndex:i];
//            [arrTemp addObject:strId];
//        }
//    }
//
    
    for(int i=0;i<arrTagData.count;i++)
    {
        for(int j=0;j<arrTemp.count;j++)
        {
            if([[[arrTagData valueForKey:@"id"]objectAtIndex:i] isEqualToString:[arrTemp objectAtIndex:j]])
            {
                NSString *strNm = [[arrTagData valueForKey:@"tag_name"]objectAtIndex:i];
                [arrTagName addObject:strNm];
            }
        }
    }
    strTagName = [arrTagName componentsJoinedByString:@","];
}

#pragma mark- ==== WebServiceMethod =======
-(void)loadProfileData
{
    @try{
        SHOW_AI;
        self.Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_USER_DETAILS dicParams:self.Parameters];
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
                strIsSocial = [NSString stringWithFormat:@"%@",[Helper getPREF:PREF_USER_ISSOCIAL]];
                //NSString *strSocialImage = [dictData valueForKey:@"socialimage"];
                if(issocial !=0)
                {
                    btnCamera.hidden = TRUE;
                    txtName.userInteractionEnabled = FALSE;
                    txtEmailID.userInteractionEnabled = FALSE;
                }
                else
                {
                    btnCamera.hidden = FALSE;
                    txtName.userInteractionEnabled = TRUE;
                    txtEmailID.userInteractionEnabled = TRUE;
                }

                arrCountryNames = [[NSMutableArray alloc]init];
                arrCountryNames = [[dicResponce valueForKey:@"data"] valueForKey:@"countries"];
                NSMutableArray *arrUserData = [[NSMutableArray alloc]init];
                arrUserData = [dictData mutableCopy];//[dictData valueForKey:@"user"];
                txtName.text = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"username"]];
                txtPhoneNo.text = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"phone"]];
                
                arrTagData = [[NSMutableArray alloc]init];
                arrTagData = [[dicResponce valueForKey:@"data"] valueForKey:@"user_tags"];
                NSString *strId = @"";
                for(int i=0;i<arrTagData.count;i++)
                {
                    int tempNo = [[[arrTagData valueForKey:@"flag"]objectAtIndex:i]intValue];
                    if(tempNo==1)
                    {
                        strId = [[arrTagData valueForKey:@"id"]objectAtIndex:i];
                        [arrTemp addObject:strId];
                    }
                }

                strBDate = [arrUserData valueForKey:@"dob"];
                if([strBDate containsString:@"0000"])
                    strBDate = @"";
                txtDOB.text  = [NSString stringWithFormat:@"%@",strBDate];
                NSString *strPassport = [arrUserData valueForKey:@"passport"];
                if([strPassport isEqual:[NSNull null]])
                    strPassport = @"";
                txtPassportNo.text = [NSString stringWithFormat:@"%@",strPassport];
                txtEmailID.text = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"useremail"]];
                NSString *strGender = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"gender"]];
                
                [Helper setPREF:[arrUserData valueForKey:@"username"] :PREF_USER_NAME];
                [Helper setPREF:[arrUserData valueForKey:@"useremail"] :PREF_USER_EMAIL];

                NSString *strSocialImg = [arrUserData valueForKey:@"socialimage"];
                NSString *strurl;
                if(issocial !=0)
                {
                    strurl = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"socialimage"]];
                }
                else{
                    if(![strurl containsString:@"htt      p"])
                        strurl = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[arrUserData valueForKey:@"userimage"]];
                }
//
//
//                NSString *strurl;
//                if([strIsSocial isEqualToString:@"0"])
//                {
//                    strurl = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"userimage"]];
//                    if(![strurl containsString:@"http"])
//                        strurl = [NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_USER,[arrUserData valueForKey:@"userimage"]];
//                }
//                else
//                    strurl = [NSString stringWithFormat:@"%@",[arrUserData valueForKey:@"socialimage"]];
                
                strurl = [strurl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *url = [NSURL URLWithString:strurl];
//                dispatch_queue_t qLogo = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//                dispatch_async(qLogo, ^{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    if(data)
                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
                            imgProfileImage.image = img;
//                        });
                    }
                    else
                    {
                        imgProfileImage.image = [UIImage imageNamed:@"no_image_attraction"];
                    }

//                });
                
                if([strGender isEqualToString:@"1"])
                    isMale = TRUE;
                else if([strGender isEqualToString:@"2"])
                    isMale = FALSE;
                else if([strGender isEqualToString:@"0"])
                    isMale = TRUE;

                if(isMale == NO)
                {
                    [btnMale setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                    [btnFemale setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                else
                {
                    [btnFemale setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                    [btnMale setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }

                strCountryId = [arrUserData valueForKey:@"country_id"];
                for(int i=0;i<arrCountryNames.count;i++)
                {
                    if([[[arrCountryNames valueForKey:@"id"]objectAtIndex:i]isEqualToString:strCountryId])
                        lblCountryNameSelected.text = [[arrCountryNames valueForKey:@"name"]objectAtIndex:i];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dictData forKey:@"UserDataDict"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [tblViewCountryList reloadData];
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

-(void)updateProfile
{
    @try
    {
        NSMutableArray* uniqueValues = [[NSMutableArray alloc] init];
        for(id e in arrTemp)
        {
            if(![uniqueValues containsObject:e])
            {
                [uniqueValues addObject:e];
            }
        }
        
        for(int i=0;i<arrTagData.count;i++)
        {
            [[arrTagData objectAtIndex:i]setValue:@"0" forKey:@"flag"];
        }
        int cntTag = 0;
        
        for(int i=0;i<arrTagData.count;i++)
        {
            for(int j=0;j<uniqueValues.count;j++)
            {
                if([[uniqueValues objectAtIndex:j]isEqualToString:[[arrTagData objectAtIndex:i]valueForKey:@"id"]])
                {
                    [[arrTagData objectAtIndex:i]setValue:@"1" forKey:@"flag"];
                    cntTag++;
                }
//                else{
//                    [[arrTagData objectAtIndex:i]setValue:@"0" forKey:@"flag"];
//                }
            }
        }
        
        strTagIDs = [arrTagData componentsJoinedByString:@","];
        NSString *strGender;
        if(isMale==true)
            strGender = @"1";
        else
            strGender = @"2";
        
        if(cntTag==0)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please select atleast one tag to continue."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (cntSOSContacts==0)
        {
            HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please add atleast one emergency contact."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSError *error;
            NSData *jsonCityData = [NSJSONSerialization dataWithJSONObject:arrTagData options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonCityDataString = [[NSString alloc] initWithData:jsonCityData encoding:NSUTF8StringEncoding];
            jsonCityDataString = [jsonCityDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            self.ParametersEditData = [[NSMutableDictionary alloc]initWithCapacity:10];
            [self.ParametersEditData setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];
            [self.ParametersEditData setValue:txtName.text forKey:@"username"];
            [self.ParametersEditData setValue:txtDOB.text forKey:@"dob"];
            [self.ParametersEditData setValue:txtPassportNo.text forKey:@"passport"];
            [self.ParametersEditData setValue:strCountryId forKey:@"country_id"];
            [self.ParametersEditData setValue:txtPhoneNo.text forKey:@"phone"];
            [self.ParametersEditData setValue:strGender forKey:@"gender"];
            [self.ParametersEditData setValue:txtEmailID.text forKey:@"useremail"];
            [self.ParametersEditData setValue:strIsSocial forKey:@"issocial"];
            [self.ParametersEditData setValue:jsonCityDataString forKey:@"user_tags"];

            NSMutableDictionary *dicFiles = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *dicFileNames=[[NSMutableDictionary alloc] init];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *now = [[NSDate alloc] init];
            NSString *theDate = [dateFormat stringFromDate:now];
            
            NSString *strIName = [NSString stringWithFormat:@"%@.jpg",theDate];
            NSString *strFileName = [NSString stringWithFormat:@"userimage"];
            
            [dicFileNames setObject:strIName forKey:strFileName];
            
            UIImage *image1 = imgProfileImage.image;
            
            if(image1!=nil)
            {
                NSData *imageData = UIImageJPEGRepresentation(image1, 0.0);
                [dicFiles setObject:imageData forKey:strFileName];
            }
            else
            {
                image1 = [UIImage imageNamed:@"no_image_attraction"];
                NSData *imageData = UIImageJPEGRepresentation(image1, 0.0);
                [dicFiles setObject:imageData forKey:strFileName];
            }
            WSFrameWork *wsLogin=[[WSFrameWork alloc] initWithURLParamsAndFiles:WS_EDIT_USER_DETAILS dicParams:self.ParametersEditData dicFilesParams:dicFiles dicFilesParamsName:dicFileNames];
            
            wsLogin.isLogging=TRUE;
            wsLogin.isSync=FALSE;

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
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@""
                                                  message:strMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadProfileData];
                    });
                }
            };
            [wsLogin send];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
    }
}

-(void)wsShowAllSOSContactDetails
{
    @try
    {
        NSMutableDictionary *Parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
        [Parameters setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_ALL_SOS_CONTACTS dicParams:Parameters];
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
                NSMutableArray *arrContactDetails = [dicResponce valueForKey:@"data"];
                arrContactDetails = [arrContactDetails valueForKey:@"user_sos"];
                cntSOSContacts = [arrContactDetails count];
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


#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(isTagTbl==FALSE)
        return arrCountryNames.count;
    else
        return arrTagData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(isTagTbl==FALSE)
        {
            static NSString *cellIdentifier = @"identifier";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            cell.textLabel.textColor = [UIColor blackColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = [[arrCountryNames valueForKey:@"name"] objectAtIndex:indexPath.row];
            return cell;
        }
        else{
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            NSString *strId = [[self->arrTagData valueForKey:@"id"]objectAtIndex:indexPath.row];
            if([arrTemp containsObject:strId])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self->arrTagData valueForKey:@"tag_name"]objectAtIndex:indexPath.row]];
            //Configure cell
            return cell;
        }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isTagTbl==FALSE)
    {
        NSObject *obj = [arrCountryNames objectAtIndex:indexPath.row];
        lblCountryNameSelected.text = [obj valueForKey:@"name"];
        strCountryId = [obj valueForKey:@"id"];
        viewCountryList.hidden = TRUE;
    }
    else
    {
        NSString *strId = [[arrTagData valueForKey:@"id"]objectAtIndex:indexPath.row];
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            if([arrTemp containsObject:strId])
                [arrTemp removeObject:strId];
        }
        else
        {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            if(![arrTemp containsObject:strId])
                [arrTemp addObject:strId];
        }
    }
}

-(IBAction)pressCancelCountrySelection:(id)sender
{
    viewCountryList.hidden = TRUE;
}


#pragma mark - =========== Open camera Method ===========

- (IBAction)pressCamera:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Take Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                
                                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                    UIAlertController * alert=   [UIAlertController
                                                                  alertControllerWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                        
                                        //do something when click button
                                    }];
                                    [alert addAction:okAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                } else {
                                    
                                    self.imagePicker = [[GKImagePicker alloc] init];
                                    self.imagePicker.cropSize = CGSizeMake(280, 280);
                                    self.imagePicker.delegate = self;
                                    self.imagePicker.resizeableCropArea = NO;
                                    self.imagePicker.imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
                                    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:NULL];
                                }
                            }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                self.imagePicker = [[GKImagePicker alloc] init];
                                self.imagePicker.cropSize = CGSizeMake(280,280);
                                self.imagePicker.delegate = self;
                                self.imagePicker.imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                                [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:NULL];
                            }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    //[self openCamera];
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    imgProfileImage.image = image;
    imgProfileImage.contentMode = UIViewContentModeScaleAspectFit;
    [self hideImagePicker];
}

- (void)hideImagePicker
{
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    imgProfileImage.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)openCamera
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Take Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                
                                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                    UIAlertController * alert=   [UIAlertController
                                                                  alertControllerWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                        
                                        //do something when click button
                                    }];
                                    [alert addAction:okAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                } else {
                                    
                                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                    picker.delegate = self;
                                    picker.allowsEditing = YES;
                                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                    picker.modalPresentationStyle = UIModalPresentationFullScreen;
                                    [self presentViewController:picker animated:YES completion:NULL];
                                }
                            }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                picker.delegate = self;
                                picker.allowsEditing = YES;
                                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                picker.modalPresentationStyle = UIModalPresentationFullScreen;
                                [self presentViewController:picker animated:YES completion:NULL];
                            }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - ============= Image Scroll View Methods =============

- (void)showImagePressed:(UIButton *)sender
{
    int i;
    UIButton *btn = (UIButton *)sender;
    i= (int)btn.tag;
    //    imgViewProfile.image =[[arrImgForDocType objectAtIndex:i]valueForKey:@"file_name"];
}

-(UIImage*)URLtoImage :(NSURL*)url
{
    UIImage *image1;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    image1 = [[UIImage alloc] initWithData:data];
    return image1;
}

#pragma mark - ============ Image Capture Methods ===========

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    imgProfileImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



@end
