//
//  SOSContactViewController.m
//  Taxidio
//
//  Created by Jitesh Keswani on 03/09/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "SOSContactViewController.h"

@interface SOSContactViewController ()

@end

@implementation SOSContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    txtCountryCode.userInteractionEnabled = true;
    txtCountryCode.delegate = self;
    [txtCountryCode addTarget:self action:@selector(pressShowCountryList) forControlEvents:UIControlEventTouchUpInside];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    viewCountryCode.hidden = true;
    [self loadCountryCodeDetails];

    if(self.strContactIdSelected.length>0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadContactDetailsForSelectedID];
        });
    }
}

- (void)viewDidLayoutSubviews
{
    [self setBottomBorderTextField:txtName];
    [self setBottomBorderTextField:txtRelation];
    [self setBottomBorderTextField:txtCountryCode];
    [self setBottomBorderTextField:txtPhoneNo];
    [self setBottomBorderTextField:txtEmailId];

    if(screenHeight == 480 || screenHeight == 568)
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.2)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.1)];
    }
}

-(void)setBottomBorderTextField : (UITextField*)txtField
{
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, txtField.frame.size.height +2  , txtField.frame.size.width, 1);
    bottomBorder1.backgroundColor = [UIColor darkGrayColor].CGColor;
    [txtField.layer addSublayer:bottomBorder1];
}

#pragma mark - IBACTION METHODS

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressSave:(id)sender
{
    if(txtName.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please enter name first."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(txtPhoneNo.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please enter contact number first."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(txtRelation.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please enter details of relation."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(txtCountryCode.text.length==0)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please select country code first."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if([Helper validateEmailWithString:txtEmailId.text]==FALSE)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please enter proper Email address first."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if(self.strContactIdSelected.length==0)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self wsAddSOSContactDetails];
            });
        }
        else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self wsUpdateSOSContactDetails];
            });
        }
    }
}

- (void)pressShowCountryList
{
    self.editing = FALSE;
    [self dismissKeyboard];

    viewCountryCode.hidden = FALSE;
    [tblViewCountryCode reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtCountryCode)
    {
        [self performSelector:@selector(pressShowCountryList)];
    }
    
    return YES;
}

- (IBAction)pressCloseCountryView:(id)sender
{
    viewCountryCode.hidden = TRUE;
}

#pragma mark- ==== WebServiceMethod =======

-(void)wsAddSOSContactDetails
{
    @try
    {
        NSMutableDictionary *Parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
        [Parameters setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];
        [Parameters setValue:txtName.text forKey:@"sosname"];
        [Parameters setValue:txtPhoneNo.text forKey:@"sosphno"];
        [Parameters setValue:txtEmailId.text forKey:@"sosemail"];
        [Parameters setValue:txtRelation.text forKey:@"sosrelation"];
        [Parameters setValue:txtCountryCode.text forKey:@"soscountrycode"];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ADD_SOS_DETAILS dicParams:Parameters];
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
//                NSMutableDictionary *dictData = [dicResponce valueForKey:@"data"];
                [self.navigationController popViewControllerAnimated:YES];
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

-(void)wsUpdateSOSContactDetails
{
    @try
    {
        NSMutableDictionary *Parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
        [Parameters setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];
        [Parameters setValue:self.strContactIdSelected forKey:@"sosId"];
        [Parameters setValue:txtName.text forKey:@"sosname"];
        [Parameters setValue:txtPhoneNo.text forKey:@"sosphno"];
        [Parameters setValue:txtEmailId.text forKey:@"sosemail"];
        [Parameters setValue:txtRelation.text forKey:@"sosrelation"];
        [Parameters setValue:txtCountryCode.text forKey:@"soscountrycode"];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_UPDATE_SOS_DETAILS dicParams:Parameters];
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
                //                NSMutableDictionary *dictData = [dicResponce valueForKey:@"data"];
                [self.navigationController popViewControllerAnimated:YES];
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


-(void)loadCountryCodeDetails
{
    @try{
        //SHOW_AI;
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_COUNTRY_CODE];
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
                arrCountryData = [dicResponce valueForKey:@"data"];
               
                arrCountryData = [arrCountryData valueForKey:@"countrycodes"];
                [tblViewCountryCode reloadData];
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

-(void)loadContactDetailsForSelectedID
{
    @try{
        NSMutableDictionary *Parameters = [[NSMutableDictionary alloc]initWithCapacity:10];
        [Parameters setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];
        [Parameters setValue:self.strContactIdSelected forKey:@"sosId"];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_SOS_DETAILS_SELECTED_ID dicParams:Parameters];
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
                arrContactData = [dicResponce valueForKey:@"data"];
                
                arrContactData = [arrContactData valueForKey:@"user_sos"];
                arrContactData = [arrContactData objectAtIndex:0];
                txtName.text = [arrContactData valueForKey:@"name"];
                txtRelation.text = [arrContactData valueForKey:@"relation"];
                txtCountryCode.text = [arrContactData valueForKey:@"country_code"];
                txtPhoneNo.text = [arrContactData valueForKey:@"phone"];
                txtEmailId.text = [arrContactData valueForKey:@"email"];
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

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return arrCountryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellIdentifier = @"identifier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [[arrCountryData valueForKey:@"name"] objectAtIndex:indexPath.row];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self dismissKeyboard];
        NSObject *obj = [arrCountryData objectAtIndex:indexPath.row];
        txtCountryCode.text = [NSString stringWithFormat:@"+%@",[obj valueForKey:@"code"]];
        viewCountryCode.hidden = TRUE;
}

-(void)dismissKeyboard {
    [txtName resignFirstResponder];
    [txtEmailId resignFirstResponder];
    [txtPhoneNo resignFirstResponder];
    [txtRelation resignFirstResponder];
    [txtCountryCode resignFirstResponder];
}

@end
