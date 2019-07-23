//
//  InvitedTripsViewController.m
//  Taxidio
//
//  Created by Jitesh Keswani on 03/10/18.
//  Copyright © 2018 E-intelligence. All rights reserved.
//

#import "InvitedTripsViewController.h"

@interface InvitedTripsViewController ()

@end

@implementation InvitedTripsViewController


@synthesize strItineraryIdSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    //tblView.allowsMultipleSelectionDuringEditing = NO;
    [viewDate removeFromSuperview];
    [datePicker removeFromSuperview];
    
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //    [self checkLogin];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self loadEditTripUI];
    tblView.allowsSelection = FALSE;
    tblView.backgroundColor = [UIColor clearColor];
    
    noOfPage = 1;
    total_page = 0;
    _arrData = [[NSMutableArray alloc]init];
    
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.view.userInteractionEnabled = YES;
    
    [Helper setPREFint:0 :@"isFromViewItinerary"];
    
    
    lblNoRecords.layer.borderColor = [UIColor blackColor].CGColor;
    lblNoRecords.layer.borderWidth = 2;
    lblNoRecords.layer.cornerRadius = 2.0;
    lblNoRecords.clipsToBounds = true;
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tblView addSubview:refreshController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Helper setPREFint:0 :@"isFromViewItinerary"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self loadTripDetails];
          [self loadTripDetails:noOfPage];
    });
    
    isLastElement = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];
    self.revealViewController.panGestureRecognizer.enabled = FALSE;
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
-(void)loadEditTripUI
{
    viewEditTripDetails.hidden = TRUE;
    viewEditTripDetails.layer.borderWidth = 3;
    viewEditTripDetails.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UITapGestureRecognizer *tapGestureStartDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblStartDateTapped)];
    tapGestureStartDate.numberOfTapsRequired = 1;
    [lblEditTripStartDate addGestureRecognizer:tapGestureStartDate];
    lblEditTripStartDate.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureEndDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblEndDateTapped)];
    tapGestureEndDate.numberOfTapsRequired = 1;
    [lblEditTripEndDate addGestureRecognizer:tapGestureEndDate];
    lblEditTripEndDate.userInteractionEnabled = YES;
}

#pragma mark - UITABLEVIEW METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor lightGrayColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
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
    
    TripObject *objTrip = [[TripObject alloc]init];
    objTrip = [_arrData objectAtIndex:indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(15,5,200,30)];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = FONT_AVENIR_45_BOOK_SIZE_14;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [objTrip valueForKey:@"user_trip_name"];
    
    UIScrollView *scrollCityName = [[UIScrollView alloc]initWithFrame:CGRectMake(15,35,400,40)];
    NSArray *arrCityName = [[objTrip valueForKey:@"citiorcountries"] componentsSeparatedByString:@"-"];
    UILabel *lblCityName;
    
    int x = 0;
    int y = 5;
    scrollCityName.backgroundColor = [UIColor clearColor];
    for( int i = 0; i < arrCityName.count; i++)
    {
        NSString *strTitle = [NSString stringWithFormat:@"%@",[arrCityName objectAtIndex:i]];
        CGSize stringsize = [strTitle sizeWithAttributes:
                             @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        
        lblCityName=[[UILabel alloc]init];//WithFrame:CGRectMake(x, y , 60, 30)];
        lblCityName.numberOfLines=0;
        lblCityName.font = FONT_AVENIR_45_BOOK_SIZE_12;
        lblCityName.textColor = [UIColor whiteColor];
        lblCityName.backgroundColor = [UIColor orangeColor];
        lblCityName.text = [arrCityName objectAtIndex:i];
        lblCityName.numberOfLines = 1;
        lblCityName.textAlignment = NSTextAlignmentCenter;
        [lblCityName setFrame:CGRectMake(x,y,stringsize.width+30,30)];
        lblCityName.alpha = 1.0;
        //        lblCityName.titleEdgeInsets = UIEdgeInsetsMake(5, 8,5, 8);
        lblCityName.tag = i;
        
        [scrollCityName addSubview:lblCityName];
        
        x += stringsize.width +50;
        //        x += 70;
    }
    scrollCityName.contentSize = CGSizeMake(x + 100,35);
    
    UILabel *lblDate = [[UILabel alloc]initWithFrame:CGRectMake(15,80,300,20)];
    lblDate.textColor = [UIColor blackColor];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.textAlignment = NSTextAlignmentLeft;
    lblDate.text = [NSString stringWithFormat:@"%@ - %@",[objTrip valueForKey:@"start_date"],[objTrip valueForKey: @"end_date"]];
    lblDate.font = FONT_AVENIR_45_BOOK_SIZE_12;
    //    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    UIButton *btnCoTraveller = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCoTraveller setImage:[UIImage imageNamed:@"co_traveller"] forState:UIControlStateNormal];
    [btnCoTraveller addTarget:self action:@selector(pressShowCoTravellerDetails:) forControlEvents:UIControlEventTouchUpInside];
    btnCoTraveller.tag = indexPath.row;
    btnCoTraveller.tintColor = COLOR_ORANGE;
    btnCoTraveller.frame = CGRectMake(150,110,26,26);
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setImage:[UIImage imageNamed:@"delete_trip"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(pressDeleteTrip:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.tag = indexPath.row;
    btnDelete.frame = CGRectMake(105,110,26,26);
    
    UIButton *btnEditTrip = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEditTrip setImage:[UIImage imageNamed:@"edit_trip"] forState:UIControlStateNormal];
    [btnEditTrip addTarget:self action:@selector(pressEditTrip:) forControlEvents:UIControlEventTouchUpInside];
    btnEditTrip.tag = indexPath.row;
    btnEditTrip.frame = CGRectMake(60,110,26,26);
    
    UIButton *btnEditTripDetails = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEditTripDetails setImage:[UIImage imageNamed:@"edit_date_trip"] forState:UIControlStateNormal];
    [btnEditTripDetails addTarget:self action:@selector(pressEditTripDetails:) forControlEvents:UIControlEventTouchUpInside];
    btnEditTripDetails.tag = indexPath.row;
    btnEditTripDetails.frame = CGRectMake(15,110,26,26);
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0 ,0,tblView.frame.size.width,150)];
    viewBG.backgroundColor=[UIColor whiteColor];
    [viewBG.layer setCornerRadius:5.0f];
    [viewBG.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [viewBG.layer setBorderWidth:0.2f];
    [viewBG.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [viewBG.layer setShadowOpacity:1.0];
    [viewBG.layer setShadowRadius:5.0];
    [viewBG.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
    [viewBG addSubview:lblTitle];
    [viewBG addSubview:scrollCityName];
    [viewBG addSubview:lblDate];
    [viewBG addSubview:btnCoTraveller];
    [viewBG addSubview:btnDelete];
    [viewBG addSubview:btnEditTrip];
    [viewBG addSubview:btnEditTripDetails];
    [cell.contentView addSubview:viewBG];
    cell.backgroundColor = [UIColor clearColor];
    
    if(([indexPath row] == _arrData.count-1)&& isLastElement==false)
    {
        if(noOfPage<=total_page)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadTripDetails:noOfPage];

            });
        }
    }
    return cell;
}

- (IBAction)pressShowCoTravellerDetails:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    TripObject *obj = [_arrData objectAtIndex:i];
    arrCoTravellerDetails = [[NSMutableArray alloc]initWithArray:[obj valueForKey:@"co_travellers"]];
    [self performSegueWithIdentifier:@"segueCoTravellerDetails" sender:self];
}

- (IBAction)pressDeleteTrip:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Are you sure you want to delete this trip?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    TripObject *obj = [_arrData objectAtIndex:i];
                                    [self deleteTripSelected:[obj valueForKey:@"id"]];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pressEditTrip:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    TripObject *obj = [_arrData objectAtIndex:i];
    [self loadDataEditTrip:obj];
    strEditTripId = [obj valueForKey:@"id"];
}

- (IBAction)pressEditTripDetails:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    TripObject *obj = [_arrData objectAtIndex:i];
    NSString *strPrivate;
    
    if([[obj valueForKey:@"trip_mode"] isEqualToString:@"1"])
        strPrivate = @"1";
    else if([[ obj valueForKey:@"trip_mode"] isEqualToString:@"2"])
        strPrivate = @"2";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getTripDetails:[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]] :[NSString stringWithFormat:@"%@",[obj valueForKey:@"user_trip_name"]] :[NSString stringWithFormat:@"%@",[obj valueForKey:@"start_date"]] :[NSString stringWithFormat:@"%@",[obj valueForKey:@"end_date"]] :strPrivate];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 170;// UITableViewAutomaticDimension;
}

#pragma mark - Handle Refresh Method

-(void)handleRefresh : (id)sender
{
    NSLog (@"Pull To Refresh Method Called");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadTripDetails:noOfPage];
        //[self loadTripDetails];
    });
    [refreshController endRefreshing];
}


//-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   // if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
//    {
//        if(noOfPage<=total_page)
//        {
//            //[tableView beginUpdates];
//            [self loadTripDetails:noOfPage];
//            //[tableView endUpdates];
//        }
//    }
//}

#pragma mark - Edit Trip View

-(void)loadDataEditTrip :(NSObject*)obj
{
    viewEditTripDetails.hidden = FALSE;
    //NSLog(@"%@",obj);
    lblTripNameEdit.text = [obj valueForKey:@"user_trip_name"];
    
    UIScrollView *scrollCityName = [[UIScrollView alloc]initWithFrame:CGRectMake(10,50,400,40)];
    
    UILabel *lblCityName;
    
    NSArray *arrCityName = [[obj valueForKey:@"citiorcountries"] componentsSeparatedByString:@"-"];
    
    int x = 0;
    int y = 5;
    scrollCityName.backgroundColor = [UIColor clearColor];
    
    for(UIView *subview in [scrollCityName subviews]) {
        [subview removeFromSuperview];
    }
    
    for( int i = 0; i < arrCityName.count; i++)
    {
        NSString *strTitle = [NSString stringWithFormat:@"%@",[arrCityName objectAtIndex:i]];
        CGSize stringsize = [strTitle sizeWithAttributes:
                             @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]}];
        
        lblCityName=[[UILabel alloc]init];
        lblCityName.numberOfLines=0;
        lblCityName.font = FONT_AVENIR_45_BOOK_SIZE_12;
        lblCityName.textColor = [UIColor whiteColor];
        lblCityName.backgroundColor = [UIColor orangeColor];
        lblCityName.text = [arrCityName objectAtIndex:i];
        lblCityName.numberOfLines = 1;
        lblCityName.textAlignment = NSTextAlignmentCenter;
        [lblCityName setFrame:CGRectMake(x,y,stringsize.width+30,30)];
        lblCityName.alpha = 1.0;
        //        lblCityName.titleEdgeInsets = UIEdgeInsetsMake(5, 8,5, 8);
        lblCityName.tag = i;
        
        [scrollCityName addSubview:lblCityName];
        
        x += stringsize.width +50;
        //        x += 70;
    }
    scrollCityName.contentSize = CGSizeMake(x + 100,35);
    
    [viewDialogTripDetailsSelected addSubview:scrollCityName];
    [viewDialogTripDetailsSelected setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    viewDialogTripDetailsSelected.layer.borderWidth=0.5;
    viewDialogTripDetailsSelected.clipsToBounds = YES;
    lblDateEdit.text = [NSString stringWithFormat:@"%@ - %@",[obj valueForKey:@"start_date"],[obj valueForKey: @"end_date"]];
    txtEditTripName.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"user_trip_name"]];
    
    lblEditTripStartDate.text = [self changeDateFormat:[NSString stringWithFormat:@"%@",[obj valueForKey:@"start_date"]]];
    
    lblEditTripEndDate.text = [self changeDateFormat:[NSString stringWithFormat:@"%@",[obj valueForKey:@"end_date"]]];
    
    if([[obj valueForKey:@"trip_mode"] isEqualToString:@"1"])
    {
        isPrivate = TRUE;
        txtComment.text = [NSString stringWithFormat:@"* Making your itinerary “Private”, it will be visible to you only."];
    }
    else if([[ obj valueForKey:@"trip_mode"] isEqualToString:@"2"])
    {
        isPrivate = FALSE;
        txtComment.text = [NSString stringWithFormat:@"* Making your itinerary “Public”, it will be visible in Planned Itinerary and others can Rate / Review / Save it."];
    }
    if(isPrivate == NO)
    {
        [btnPrivate setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnPublic setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    else
    {
        [btnPublic setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnPrivate setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - IBACTION METHODS

- (IBAction)pressUserProfile:(id)sender {
}

- (IBAction)pressMenuBtn:(id)sender {
}

- (IBAction)btnCancelEditTrip:(id)sender {
    viewEditTripDetails.hidden = TRUE;
    [viewDate removeFromSuperview];
    [self removeKeyboard];
}

- (IBAction)btnSaveEditTrip:(id)sender {
    viewEditTripDetails.hidden = TRUE;
    NSString *strPrivate;
    
    if(isPrivate==TRUE)
        strPrivate = @"1";
    else
        strPrivate = @"2";
    
    if(txtEditTripName.text.length>0 && lblEditTripStartDate.text.length>0 && lblEditTripEndDate.text.length>0 &&([self checkDateValidation:lblEditTripStartDate.text :lblEditTripEndDate.text]==TRUE))
    {
        [self saveEditTripDetails:strEditTripId :txtEditTripName.text :[NSString stringWithFormat:@"%@",lblEditTripStartDate.text] :[NSString stringWithFormat:@"%@",lblEditTripEndDate.text] :strPrivate];
        [viewDate removeFromSuperview];
    }
    else
    {
        if(txtEditTripName.text.length==0)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please enter trip name."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //lblEditTripEndDate.text = @"";
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if(lblEditTripStartDate.text.length==0)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please enter Start date."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //lblEditTripEndDate.text = @"";
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if(lblEditTripEndDate.text.length==0)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please enter End date."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //lblEditTripEndDate.text = @"";
            }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - PRIVATE METHODS
-(void)lblStartDateTapped
{
    viewDate = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 225)];
    viewDate.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(viewDate.frame.size.width - 60, 5, 50.0, 25.0);
    [viewDate addSubview:button];
    [txtEditTripName resignFirstResponder];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35,self.view.frame.size.width,190)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    
    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc]init];
    dateFormatterStart.dateFormat = @"dd/MM/yyyy";
    NSDate *StartDate = [dateFormatterStart dateFromString:lblEditTripStartDate.text];
    datePicker.date = StartDate;
    
    datePicker.backgroundColor = [UIColor lightGrayColor];
    [datePicker addTarget:self action:@selector(changeStartDateValue:) forControlEvents:UIControlEventValueChanged];
    [viewDate addSubview:datePicker];
    
    [viewEditTripDetails addSubview:viewDate];
}

-(void)lblEndDateTapped
{
    viewDate = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 225)];
    viewDate.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(viewDate.frame.size.width - 60, 5, 50.0, 25.0);
    [viewDate addSubview:button];
    [txtEditTripName resignFirstResponder];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35,viewEditTripMain.frame.size.width,190)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [NSDate date];
    
    NSDateFormatter *dateFormatterEnd = [[NSDateFormatter alloc]init];
    dateFormatterEnd.dateFormat = @"dd/MM/yyyy";
    NSDate *EndDate = [dateFormatterEnd dateFromString:lblEditTripEndDate.text];
    datePicker.date = EndDate;
    
    datePicker.backgroundColor = [UIColor lightGrayColor];
    [datePicker addTarget:self action:@selector(changeEndDateValue:) forControlEvents:UIControlEventValueChanged];
    [viewDate addSubview:datePicker];
    [viewEditTripDetails addSubview:viewDate];
}

-(void)removeKeyboard
{
    if([self checkDateValidation :lblEditTripStartDate.text : lblEditTripEndDate.text]==true)
    {
    }
    [viewDate removeFromSuperview];
    [txtEditTripName resignFirstResponder];
}

-(BOOL)checkDateValidation :(NSString*)strStartDate :(NSString*)strEndDate
{
    NSDateFormatter *dateFormatterEnd = [[NSDateFormatter alloc]init];
    dateFormatterEnd.dateFormat = @"dd/MM/yyyy";
    NSDate *EndDate = [dateFormatterEnd dateFromString:strEndDate];
    
    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
    dateFormatterStart.dateFormat = @"dd/MM/yyyy";
    NSDate *startDate = [dateFormatterStart dateFromString:strStartDate];
    
    if ([startDate earlierDate: EndDate] == startDate)
    {
        lblEditTripEndDate.text = strEndDate;
        return YES;
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Start date must be before End date."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //lblEditTripEndDate.text = @"";
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return FALSE;
    }
}

-(NSString*)changeDateFormat : (NSString*)dateVal
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateVal];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString = [dateFormatter1 stringFromDate:dateFromString];
    //lblEditTripStartDate.text = dateString;
    return dateString;
}

-(void)changeStartDateValue:(id)sender
{
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    lblEditTripStartDate.text = dateString;
    [self checkDateValidation :dateString :lblEditTripEndDate.text];
}

-(void)changeEndDateValue:(id)sender
{
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    [self checkDateValidation :lblEditTripStartDate.text :dateString];
    //    NSDateFormatter *dateFormatterStart = [[NSDateFormatter alloc] init];
    //    dateFormatterStart.dateFormat = @"dd/MM/yyyy";
    //    NSDate *startDate = [dateFormatterStart dateFromString:lblEditTripStartDate.text];
    //
    //    if ([startDate earlierDate: date] == startDate) {
    //        lblEditTripEndDate.text = dateString;
    //    }
    //    else
    //    {
    //        UIAlertController * alert=   [UIAlertController
    //                                      alertControllerWithTitle:@""
    //                                      message:@"Start date must be before End date."
    //                                      preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    //
    //            //do something when click button
    //        }];
    //        [alert addAction:okAction];
    //        [self presentViewController:alert animated:YES completion:nil];
    //
    //    }
}

-(IBAction)privateBtnTapped:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    if(i==1)
    {
        isPrivate = TRUE;
        txtComment.text = [NSString stringWithFormat:@"* Making your itinerary “Private”, it will be visible to you only."];
    }
    else if(i==2)
    {
        if([Helper getPREFint:@"askforemail"]==0)
        {
            isPrivate = FALSE;
            txtComment.text = [NSString stringWithFormat:@"* Making your itinerary “Public”, it will be visible in Planned Itinerary and others can Rate / Review / Save it."];
        }
        else{
            [self checkForEmail];
        }
    }
    
    if(isPrivate == NO)
    {
        [btnPrivate setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnPublic setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }
    else
    {
        [btnPublic setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [btnPrivate setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
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

#pragma mark- ==== WebServiceMethod =======
-(void)loadTripDetails : (int)noPage
{
    @try{
        //SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    //[NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_INVITED_TRIP_LIST dicParams:Parameters];
        wsLogin.isLogging=TRUE;
        wsLogin.isSync=TRUE;
        wsLogin.onSuccess=^(NSDictionary *dicResponce)
        {
            //HIDE_AI;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSInteger intStatus = [[dicResponce objectForKey:@"errorcode"]integerValue];
            NSString *strMessage = [dicResponce objectForKey:@"message"];
            
            NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
            dicResponce = [dict mutableCopy];
            dict = nil;
            
            if(strMessage.length==0)
                strMessage = MSG_NO_MESSAGE;
            // HIDE_AI;
            
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
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                arr = [dicResponce valueForKey:@"data"];
                
                if(arr.count==0)
                {
                    isLastElement = true;
                }
                for(int i=0;i<arr.count;i++)
                {
                    [_arrData addObject:[arr objectAtIndex:i]];
                }
                //NSLog(@"%@",_arrData);
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

-(void)saveEditTripDetails : (NSString*)strTripId : (NSString*)tripName : (NSString*)strStartDt :(NSString*)strEndDt :(NSString*)tripMode
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strTripId,@"itirnaryid",
                                    tripName,@"user_trip_name",
                                    strStartDt,@"start_date",
                                    strEndDt,@"end_date",
                                    tripMode,@"trip_mode",nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_EDIT_TRIP_DETAILS dicParams:Parameters];
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
                noOfPage = 1;
                total_page = 0;
                [_arrData removeAllObjects];
                [self loadTripDetails:noOfPage];
                //                [self loadTripDetails:noOfPage];
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

-(void)deleteTripSelected : (NSString*)strTripId
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%@",strTripId],@"itirnaryid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_DELETE_TRIP dicParams:Parameters];
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
                [_arrData removeAllObjects];
                [self loadTripDetails:1];
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

-(void)getTripDetails : (NSString*)strTripId : (NSString*)tripName : (NSString*)strStartDt :(NSString*)strEndDt :(NSString*)tripMode
{
    self.strItineraryIdSelected = strTripId;
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strTripId,@"itirnaryid",
                                    tripName,@"user_trip_name",
                                    strStartDt,@"start_date",
                                    strEndDt,@"end_date",
                                    tripMode,@"trip_mode",nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_TRIP dicParams:Parameters];
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
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                HIDE_AI;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            else
            {
                NSMutableDictionary *dict = [Helper recursiveNullRemove:[dicResponce mutableCopy]];
                dicResponce = [dict mutableCopy];
                dict = nil;
                
                dictData = [dicResponce valueForKey:@"data"];
                [Helper setPREF:[dictData valueForKey:@"uniqueid"] :@"strTokenId"];
                
                if([[dictData valueForKey:@"trip_type"]intValue]==1||[[dictData valueForKey:@"trip_type"]intValue]==2)
                {
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictData valueForKey:@"inputs"]
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:&error];
                    NSString *jsonString;
                    if (! jsonData)
                    {
                        NSLog(@"Got an error: %@", error);
                    } else {
                        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DATA];
                    [self performSegueWithIdentifier:@"segueInviteEditTrip" sender:self];
                }
                if([[dictData valueForKey:@"trip_type"]intValue]==3)
                {
                    NSMutableArray *arrInput = [[dictData valueForKey:@"search_city_inputs"]mutableCopy];
                    
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrInput options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *jsonString;
                    if (! jsonData) {
                        NSLog(@"Got an error: %@", error);
                    } else {
                        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DESTI_DATA];
                    
                    
                    //dictData = [dictData valueForKey:@"singlecountry"];
                    //                    if(dictData.count==1)
                    //                    {
                    //                        [self performSegueWithIdentifier:@"segueEditTripCityLocation" sender:self];
                    //                    }
                    //                    else
                    //                    {
                    [self performSegueWithIdentifier:@"segueInviteEditTrip" sender:self];
                    //                    }
                }
                HIDE_AI;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                isPrivate = FALSE;
                txtComment.text = [NSString stringWithFormat:@"* Making your itinerary “Public”, it will be visible in Planned Itinerary and others can Rate / Review / Save it."];
                
                if(isPrivate == NO)
                {
                    [btnPrivate setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                    [btnPublic setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
                else
                {
                    [btnPublic setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                    [btnPrivate setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                }
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

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueInviteEditTrip"])
    {
        CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
        detail.dictSearchData = dictData;
        detail.isFromEditTrip = TRUE;
        detail.isFirstTimeSaved = FALSE;
        detail.strItineraryIdSelected = self.strItineraryIdSelected;
        detail.strTripType = [dictData valueForKey:@"trip_type"];
        [Helper setPREFint:0 :@"isFromAttractionListing"];
    }
    if([[segue identifier] isEqualToString:@"segueEditTripCityLocation"])
    {
        CityLocationSwipeVC *detail = (CityLocationSwipeVC *)[segue destinationViewController];
        detail.isFromSearchData = isFromSearchData;
        detail.dictSearchData = dictData;
        NSString *strCityNameSelected = [[dictData valueForKey:@"city_name"]objectAtIndex:0];
        NSString *strLatitudeCitySelected = [[dictData valueForKey:@"latitude"]objectAtIndex:0];
        NSString *strLongitudeCitySelected = [[dictData valueForKey:@"longitude"]objectAtIndex:0];
        
        detail.strCityName = strCityNameSelected;
        detail.strLatitude = strLatitudeCitySelected;
        detail.strLongitude = strLongitudeCitySelected;
        detail.isFromEditTrip = TRUE;
        detail.strItineraryIdSelected = self.strItineraryIdSelected;
    }
    if([[segue identifier] isEqualToString:@"segueCoTravellerDetails"])
    {
        CoTravellerDataViewController *detail = (CoTravellerDataViewController *)[segue destinationViewController];
        detail.arrCoTravellerDetails = arrCoTravellerDetails;
    }
}

@end
