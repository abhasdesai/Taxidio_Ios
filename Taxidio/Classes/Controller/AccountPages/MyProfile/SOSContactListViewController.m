//
//  SOSContactListViewController.m
//  Taxidio
//
//  Created by Jitesh Keswani on 03/09/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "SOSContactListViewController.h"

@interface SOSContactListViewController ()

@end

@implementation SOSContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tblContactDetails.separatorColor = [UIColor darkGrayColor];
    tblContactDetails.separatorStyle = UITableViewCellSelectionStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self wsShowAllSOSContactDetails];
}

#pragma mark - IBACTION METHODS

- (IBAction)pressAddContact:(id)sender
{
    self.strContactIdSelected = @"";
    [self performSegueWithIdentifier:@"segueAddSOS" sender:self];
}

- (IBAction)pressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return arrContactDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    
    for (id object in cell.contentView.subviews)
    {
        [object removeFromSuperview];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    UIView * overBg = [[UIView alloc] initWithFrame:CGRectMake(0,58,self.view.frame.size.width,2)];
    overBg.backgroundColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:overBg];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [[arrContactDetails valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[arrContactDetails valueForKey:@"relation"] objectAtIndex:indexPath.row];
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDelete.frame = CGRectMake(self.view.frame.size.width-50,15,25,25);
    // set the button title here if it will always be the same
    [btnDelete setImage:[UIImage imageNamed:@"delete_trip"] forState:UIControlStateNormal];
    btnDelete.tintColor = [UIColor redColor];
    [btnDelete setTitle:@"Action" forState:UIControlStateNormal];
    btnDelete.tag = indexPath.row;
    [btnDelete addTarget:self action:@selector(deleteSOSContact:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnDelete];
    
    if(arrContactDetails.count==2)
        btnDelete.hidden = false;
    if(arrContactDetails.count==1)
        btnDelete.hidden = true;
//    else
//        btnDelete.hidden = true;


    return cell;
}

-(IBAction)deleteSOSContact:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger indexrow = btn.tag;
 
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete the contact?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self deleteContactDetailsForSelectedID:[[arrContactDetails valueForKey:@"id"] objectAtIndex:indexrow]];
                                    });
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [arrContactDetails objectAtIndex:indexPath.row];
    self.strContactIdSelected = [obj valueForKey:@"id"];
    [self performSegueWithIdentifier:@"segueAddSOS" sender:self];
}


#pragma mark- ==== WebServiceMethod =======

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
                arrContactDetails = [dicResponce valueForKey:@"data"];
                arrContactDetails = [arrContactDetails valueForKey:@"user_sos"];
                [tblContactDetails reloadData];
                if(arrContactDetails.count==2)
                    btnAddContact.hidden = true;
                else
                    btnAddContact.hidden = false;
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

-(void)deleteContactDetailsForSelectedID : (NSString*)strId
{
    @try{
        NSMutableDictionary *Parameters = [[NSMutableDictionary alloc]initWithCapacity:2];
        [Parameters setValue:strId forKey:@"sosId"];
        [Parameters setValue:[Helper getPREF:PREF_UID] forKey:@"userid"];

        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_DELETE_SOS_DETAILS_SELECTED_ID dicParams:Parameters];
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
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self wsShowAllSOSContactDetails];
                });
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


#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueAddSOS"])
    {
        SOSContactViewController *detail = (SOSContactViewController *)[segue destinationViewController];
        detail.strContactIdSelected = self.strContactIdSelected;
    }
}
@end
