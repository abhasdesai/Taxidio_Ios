//
//  MyItineraryQuestionVC.m
//  Taxidio
//
//  Created by E-Intelligence on 03/11/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "MyItineraryQuestionVC.h"

@interface MyItineraryQuestionVC ()

@end

@implementation MyItineraryQuestionVC

@synthesize objForReply;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arrData = [[NSMutableArray alloc]init];
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    noOfPage = 1;
    total_page = 0;
    [self loadItineraryQuestion:noOfPage];
    
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    
    lblNoRecords.layer.borderColor = [UIColor blackColor].CGColor;
    lblNoRecords.layer.borderWidth = 2;
    lblNoRecords.layer.cornerRadius = 2.0;
    lblNoRecords.clipsToBounds = true;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];
    //self.revealViewController.panGestureRecognizer.enabled = FALSE;
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

- (IBAction)pressClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressMenu:(id)sender
{
    
}

- (IBAction)pressUserProfile:(id)sender
{
    
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
    static NSString *cellIdentifier = @"CellMyQuestion";
    CellMyQuestion *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[CellMyQuestion alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.viewBG.backgroundColor=[UIColor whiteColor];
    [cell.viewBG.layer setCornerRadius:5.0f];
    [cell.viewBG.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.viewBG.layer setBorderWidth:0.2f];
    [cell.viewBG.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [cell.viewBG.layer setShadowOpacity:1.0];
    [cell.viewBG.layer setShadowRadius:5.0];
    [cell.viewBG.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];

    NSObject *obj = [_arrData objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"Question : %@",[obj valueForKey:@"question"]];
    cell.lblTripName.text = [NSString stringWithFormat:@"%@ - By %@",[obj valueForKey:@"user_trip_name"],[obj valueForKey:@"name"]];
    cell.lblComment.text = [NSString stringWithFormat:@"%@ Comments",[obj valueForKey:@"totalcomments"]];
    cell.lblDate.text = [NSString stringWithFormat:@"Created On %@",[obj valueForKey:@"date"]];
    cell.lblTitle.textColor = COLOR_ORANGE;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [cell layoutIfNeeded];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(noOfPage<=total_page)
    {
        [self loadItineraryQuestion:noOfPage];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    self.objForReply = [_arrData objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueMyQuestionComments" sender:self];
}

#pragma mark- ==== WebServiceMethod =======
-(void)loadItineraryQuestion  : (int)noPage
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_FORUM_MY_QUESTION dicParams:Parameters];
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
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@""
//                                              message:strMessage
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//
//                    //do something when click button
//                }];
//                [alert addAction:okAction];
//                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                arr = [dicResponce valueForKey:@"data"];
                for(int i=0;i<arr.count;i++)
                {
                    [_arrData addObject:[arr objectAtIndex:i]];
                }
                NSLog(@"%@",_arrData);
                if(noOfPage<=total_page)
                    noOfPage+=1;
                [tblView reloadData];
            }
            if(_arrData.count==0)
            {
                tblView.hidden = TRUE;
                viewNoRecords.hidden = FALSE;
            }
            else
            {
                viewNoRecords.hidden = TRUE;
                tblView.hidden = FALSE;
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
//segueMyQuestionComments

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueMyQuestionComments"])
    {
        ReplyToForumPageVCViewController *detail = (ReplyToForumPageVCViewController *)[segue destinationViewController];
        detail.objForReply = self.objForReply;
        detail.strItineraryId = [self.objForReply valueForKey:@"itirnaryid"];
    }
}

@end
