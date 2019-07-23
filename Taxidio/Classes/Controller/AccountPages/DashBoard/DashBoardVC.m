//
//  DashBoardVC.m
//  Taxidio
//
//  Created by E-Intelligence on 18/07/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "DashBoardVC.h"

@interface DashBoardVC ()

@end

@implementation DashBoardVC
@synthesize arrData,arrDataforCity,strItineraryIdSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabelWithMonth:self.monthlyView.seletedMonth];
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self checkLogin];
   // [btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDashBoardData];
    });
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

    [Helper setPREFint:0 :@"isFromViewItinerary"];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(screenHeight == 480 || screenHeight == 568)
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.3)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height* 1.1)];
    }
    
    viewRoundProgress.backgroundColor = [UIColor colorWithRed:89/255.f green:25/255.0f blue:134/255.0f alpha:0.5];
    viewRoundProgress.layer.cornerRadius = viewRoundProgress.frame.size.height/2.0;
    viewRoundProgress.layer.borderColor = [UIColor colorWithRed:89/255.f green:25/255.0f blue:134/255.0f alpha:1].CGColor;
    viewRoundProgress.layer.borderWidth = 2;
    viewRoundProgress.clipsToBounds = YES;
    
    viewRoundCompleted.backgroundColor = [UIColor colorWithRed:0/255.f green:136/255.0f blue:47/255.0f alpha:0.5];
    viewRoundCompleted.layer.cornerRadius = viewRoundCompleted.frame.size.height/2.0;
    viewRoundCompleted.layer.borderColor = [UIColor colorWithRed:0/255.f green:136/255.0f blue:47/255.0f alpha:1].CGColor;
    viewRoundCompleted.layer.borderWidth = 2;
    viewRoundCompleted.clipsToBounds = YES;
    
    viewRoundUpcoming.backgroundColor = [UIColor colorWithRed:255/255.f green:100/255.0f blue:32/255.0f alpha:0.5];
    viewRoundUpcoming.layer.cornerRadius = viewRoundUpcoming.frame.size.height/2.0;
    viewRoundUpcoming.layer.borderColor = [UIColor colorWithRed:255/255.f green:100/255.0f blue:32/255.0f alpha:1].CGColor;
    viewRoundUpcoming.layer.borderWidth = 2;
    viewRoundUpcoming.clipsToBounds = YES;
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenwidth = screenRect.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPCALENDER METHODS

-(void)loadData
{
    [self generateData];
    [self commonInit];
}

-(void) commonInit {
    [self generateMonthlyView];
    [self updateLabelWithMonth:self.monthlyView.seletedMonth];
}

- (void) generateMonthlyView {
    CGFloat width = [self.class currentSize].width;
    CGFloat height = [self.class currentSize].height;
    
    [self.previousButton removeFromSuperview];
    [self.nextButton removeFromSuperview];
    [self.monthLabel removeFromSuperview];
    [self.todayButton removeFromSuperview];
    [self.createEventButton removeFromSuperview];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((width - 100) / 2, 20, 100, 20)];
    [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
    self.monthLabel.font = [UIFont systemFontOfSize:17];
    self.monthLabel.textColor = [UIColor blackColor];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton setBackgroundImage:[UIImage imageNamed:@"btn-left@1x"] forState:UIControlStateNormal];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"btn-right@1x"] forState:UIControlStateNormal];
    self.todayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.createEventButton setBackgroundImage:[UIImage imageNamed:@"BtnAddSomething"] forState:UIControlStateNormal];
    self.previousButton.frame = CGRectMake(self.monthLabel.frame.origin.x - 18, 20, 18, 20);
    self.nextButton.frame = CGRectMake(CGRectGetMaxX(self.monthLabel.frame), 20, 18, 20);
    self.todayButton.frame = CGRectMake(width - 60, 20, 60, 21);
    self.backButton.frame = CGRectMake(40, 20, 50, 20);
    self.createEventButton.frame = CGRectMake(10, 20, 20, 20);
    [self.todayButton setTitle:@"Today" forState:UIControlStateNormal];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [self.previousButton addTarget:self action:@selector(previousButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewCalender addSubview:self.monthLabel];
    [viewCalender addSubview:self.previousButton];
    [viewCalender addSubview:self.nextButton];
    [viewCalender addSubview:self.createEventButton];
    [self.monthlyView removeFromSuperview];
    self.monthlyView = [[DPCalendarMonthlyView alloc] initWithFrame:CGRectMake(0, 50, width-15, height - 50) delegate:self];
    [viewCalender addSubview:self.monthlyView];
    
    [self.monthlyView setEvents:self.events complete:nil];
    [self.monthlyView setIconEvents:self.iconEvents complete:nil];
}

- (void) backButtonSelected:(id)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) previousButtonSelected:(id)button {
    [self.monthlyView scrollToPreviousMonthWithComplete:nil];
}

-(void) nextButtonSelected:(id)button {
    [self.monthlyView scrollToNextMonthWithComplete:nil];
}

-(void) todayButtonSelected:(id)button {
    [self.monthlyView clickDate:[NSDate date]];
}

- (void) generateData {
    self.events = @[].mutableCopy;
    self.iconEvents = @[].mutableCopy;

    NSArray *arrTitles = [self.arrData valueForKey:@"title"];
    NSArray *arrStartDate = [self.arrData valueForKey:@"start"];
    NSArray *arrEndDate = [self.arrData valueForKey:@"end"];
    NSArray *arrColors = [self.arrData valueForKey:@"color"];
    NSArray *arrIDs = [self.arrData valueForKey:@"id"];

    for(int i=0;i<arrData.count;i++)
    {
        int colorIndex = 0;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *Sdate = [formatter dateFromString:[arrStartDate objectAtIndex:i]];
        NSDate *Edate = [formatter dateFromString:[arrEndDate objectAtIndex:i]];
        if([[arrColors objectAtIndex:i]isEqualToString:@"#00882f"])
            colorIndex = 0;
        else if([[arrColors objectAtIndex:i]isEqualToString:@"#591986"])
            colorIndex = 1;
        else if([[arrColors objectAtIndex:i]isEqualToString:@"#ff6420"])
            colorIndex = 2;
        
        NSString *strId = [arrIDs objectAtIndex:i];

        DPCalendarEvent *event = [[DPCalendarEvent alloc] initWithTitle:[arrTitles objectAtIndex:i] startTime:Sdate endTime:Edate colorIndex:colorIndex setID:strId];
        [self.events addObject:event];
    }
}

- (void) updateLabelWithMonth:(NSDate *)month {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:month];
    [self.monthLabel setText:stringFromDate];
}

#pragma DPCalendarMonthlyViewDelegate
-(void)didScrollToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate{
    [self updateLabelWithMonth:month];
}

-(void)didSkipToMonth:(NSDate *)month firstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    [self updateLabelWithMonth:month];
}

-(void)didTapEvent:(DPCalendarEvent *)event onDate:(NSDate *)date
{
    NSLog(@"Touched event %@, date %@", event.title, date);
    
    [self getTripDetails:event.strIds];
    
    //-(void)getTripDetails : (NSString*)strTripId : (NSString*)tripName : (NSString*)strStartDt :(NSString*)strEndDt :(NSString*)tripMode

}

-(BOOL)shouldHighlightItemWithDate:(NSDate *)date {
    return YES;
}

-(BOOL)shouldSelectItemWithDate:(NSDate *)date {
    return YES;
}

-(void)didSelectItemWithDate:(NSDate *)date {
    NSLog(@"Select date %@ with \n events %@ \n and icon events %@", date, [self.monthlyView eventsForDay:date], [self.monthlyView iconEventsForDay:date]);
}

-(NSDictionary *) iphoneMonthlyViewAttributes {
    return @{
             DPCalendarMonthlyViewAttributeEventDrawingStyle: [NSNumber numberWithInt:DPCalendarMonthlyViewEventDrawingStyleUnderline],
             DPCalendarMonthlyViewAttributeCellNotInSameMonthSelectable: @YES,
             DPCalendarMonthlyViewAttributeMonthRows:@3
             };
}

-(NSDictionary *)monthlyViewAttributes {
        return [self iphoneMonthlyViewAttributes];
}

#pragma mark - Utilities

+(CGSize) currentSize
{
    return [self sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

#pragma mark - DPCalendarTestCreateEventViewControllerDelegate
-(void)eventCreated:(DPCalendarEvent *)event {
    [self.events addObject:event];
    [self.monthlyView setEvents:self.events complete:nil];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotate {
    return YES;
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self commonInit];
//}

#pragma mark- ==== WebServiceMethod =======
-(void)setDashBoardData
{
    @try{
        NSString *strUID =[Helper getPREF:PREF_UID];
            SHOW_AI;
            NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        strUID,@"userid",
                                        nil];
            WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ACCOUNT_DASHBOARD dicParams:Parameters];
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
                        
                        //do something when click button
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    NSMutableDictionary *dictData = [dicResponce valueForKey:@"data"];
                    intCompleted = [[[dictData valueForKey:@"trips"] valueForKey:@"completed"]intValue];
                    intInprogress = [[[dictData valueForKey:@"trips"] valueForKey:@"inprogress"]intValue];
                    intUpcoming = [[[dictData valueForKey:@"trips"] valueForKey:@"upcoming"]intValue];
                    lblCompletedCnt.text = [NSString stringWithFormat:@"%d",intCompleted];
                    lblInProgressCnt.text = [NSString stringWithFormat:@"%d",intInprogress];
                    lblUpcomingCnt.text = [NSString stringWithFormat:@"%d",intUpcoming];
                    self.arrData = [dictData valueForKey:@"calendartrip"];
                    [self loadData];
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

-(void)getTripDetails : (NSString*)strTripId
{
    self.strItineraryIdSelected = strTripId;
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strTripId,@"itirnaryid",nil];
        
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
                    if (! jsonData) {
                        NSLog(@"Got an error: %@", error);
                    } else {
                        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DATA];
                    [self performSegueWithIdentifier:@"segueDashBoardToTrip" sender:self];
                }
                if([[dictData valueForKey:@"trip_type"]intValue]==3)
                {
                    NSError *error;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictData valueForKey:@"search_city_inputs"] options:NSJSONWritingPrettyPrinted
                                                                         error:&error];
                    NSString *jsonString;
                    if (! jsonData) {
                        NSLog(@"Got an error: %@", error);
                    } else {
                        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    
                    [Helper setPREF:jsonString :PREF_INPUT_SEARCH_DESTI_DATA];
                    
                    
                    //dictData = [dictData valueForKey:@"singlecountry"];
                    //                    if(dictData.count==1)
                    //                    {
                    //                        [self performSegueWithIdentifier:@"segueEditTripCityLocation" sender:self];
                    //                    }
                    //                    else
                    //                    {
                    [self performSegueWithIdentifier:@"segueDashBoardToTrip" sender:self];
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

#pragma mark- PrepareSegue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueDashBoardToTrip"])
    {
        CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
        detail.dictSearchData = dictData;
        detail.isFromEditTrip = TRUE;
        detail.strItineraryIdSelected = self.strItineraryIdSelected;
        detail.strTripType = [dictData valueForKey:@"trip_type"];
    }
}

@end
