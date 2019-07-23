//
//  PlannedItineraryVC.m
//  Taxidio
//
//  Created by E-Intelligence on 12/10/17.
//  Copyright © 2017 E-intelligence. All rights reserved.
//

#import "PlannedItineraryVC.h"

@interface PlannedItineraryVC ()

@end

@implementation PlannedItineraryVC
@synthesize strItineraryIdSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrData = [[NSMutableArray alloc]init];
    arrCountryNames = [[NSMutableArray alloc]init];
    tblViewItinerary.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [btnMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //[btnUserMenu addTarget:self action:@selector(checkLogin) forControlEvents:UIControlEventTouchUpInside];
    if([Helper getPREF:PREF_UID].length>0)
    {
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    tblViewItinerary.allowsSelection = FALSE;
    tblViewItinerary.backgroundColor = [UIColor clearColor];
    
    
    noOfPage = 1;
    total_page = 0;
    [_arrData removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    strCountryIdSelected = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPlannedItineraryDetails:noOfPage :strCountryIdSelected];
    });
//    self.statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
//    self.statusWindow.windowLevel = UIWindowLevelStatusBar + 1;
//    self.statusWindow.hidden = YES;
//    self.statusWindow.backgroundColor = [UIColor redColor];
//    [self.statusWindow makeKeyAndVisible];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isSortingDone = FALSE;
    viewCityWiseSorting.hidden = TRUE;
    viewTripInfo.hidden = true;
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-50;
    self.revealViewController.rightViewRevealWidth = self.view.frame.size.width-50;
    isLastElement = false;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self checkLogin];
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

- (IBAction)pressMenuBtn:(id)sender
{
    
}

- (IBAction)pressUserProfile:(id)sender
{
    
}

- (IBAction)pressCloseInfoView:(id)sender {
    viewTripInfo.hidden = true;
}

-(IBAction)pressShowFilter:(id)sender
{
    viewCityWiseSorting.hidden = FALSE;
    isSortingDone = TRUE;
    [tblCountrySort reloadData];
}


-(IBAction)pressSaveTrip:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    if([Helper getPREF:PREF_UID].length>0)
    {
        NSObject *objData = [_arrData objectAtIndex:i];
        [self savePlannedItinerary : [objData valueForKey:@"id"]];
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

-(IBAction)pressViewTrip:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    TripObject *obj = [_arrData objectAtIndex:i];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self WSgetTripDetails : [obj valueForKey:@"slug"]];
    });
}

-(NSString*)changeDateFormat : (NSString*)dateVal
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dds MMM YYYY"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateVal];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateString = [dateFormatter1 stringFromDate:dateFromString];
    //lblEditTripStartDate.text = dateString;
    return dateString;
}



-(IBAction)pressViewInfoOfTrip:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    NSLog(@"%ld",(long)i);
    
    NSObject *obj = [_arrData objectAtIndex:i];
    
    lblTripNameInfoView.text = [obj valueForKey:@"user_trip_name"];
    lblTripDicussionInfoView.text = [NSString stringWithFormat:@"%@ Views | %@ Discussions",[obj valueForKey:@"views"],[obj valueForKey:@"totalquestions"]];
    lblTripCreatedByName.text = [NSString stringWithFormat:@"Created By : %@",[obj valueForKey:@"name"]];
    lblTripCreatedByName.textColor = COLOR_ORANGE;
    NSArray *arrDestiDt = [[NSArray alloc]init];
    NSString *strDestiData;
    if([[obj valueForKey:@"multi"]count]!=0)
    {
        arrDestiDt = [obj valueForKey:@"multi"];
        NSMutableArray *arrDestiData = [[NSMutableArray alloc]init];
        for(int i=0;i<arrDestiDt.count;i++)
        {
            NSString *str = [NSString stringWithFormat:@"%@ : ( %@ )",[[arrDestiDt objectAtIndex:i] valueForKey:@"country"],[[arrDestiDt objectAtIndex:i] valueForKey:@"city"]];
            [arrDestiData addObject:str];
        }
        
        strDestiData = [NSString stringWithFormat:@"%@",[arrDestiData componentsJoinedByString:@"\n"]];
    }
    else
    {
        strDestiData = [NSString stringWithFormat:@"%@ : ( %@ )",[obj valueForKey:@"countryname"],[obj valueForKey:@"citiorcountries"]];
        strDestiData = [strDestiData stringByReplacingOccurrencesOfString:@"-" withString:@" , "];
    }
    txtViewDestiDetailsInfoView.text = [NSString stringWithFormat:@"%@",strDestiData];
    viewTripInfo.hidden = FALSE;
}

-(IBAction)pressViewTripForum:(id)sender
{
    if([Helper getPREF:PREF_UID].length>0)
    {
        UIButton *button = (UIButton *)sender;
        NSInteger i = button.tag;
        NSLog(@"%ld",(long)i);
        
        NSObject *obj = [_arrData objectAtIndex:i];
        strItineraryIdSelected = [obj valueForKey:@"id"];
        strTripSelected = [obj valueForKey:@"user_trip_name"];
        strTripOwnerId = [obj valueForKey:@"user_id"];
        [self performSegueWithIdentifier:@"segueShowForumForItinerary" sender:self];
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

#pragma mark - ========== Tableview Events ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    if(isSortingDone==FALSE)
        return [_arrData count];
    else
        return arrCountryNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSortingDone==FALSE)
    {
        NSString *identifier;
        NSObject *obj = [_arrData objectAtIndex:indexPath.row];
        
            identifier = @"CellLeftItinerary";
            CellLeftItinerary *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
            {
                cell = [[CellLeftItinerary alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            if([[obj valueForKey:@"issave"]intValue]==0) //Trip Not saved
            {
                cell.btnSaveTrip.hidden = FALSE;
                cell.btnSaved.hidden = true;
            }
            else if([[obj valueForKey:@"issave"]intValue]==1) //Saved Trip
            {
                cell.btnSaveTrip.hidden = TRUE;
                cell.btnSaved.hidden = FALSE;
            }
            else if([[obj valueForKey:@"issave"]intValue]==2) //My Trip
            {
                cell.btnSaveTrip.hidden = TRUE;
                cell.btnSaved.hidden = TRUE;
            }

            float rating = [[obj valueForKey:@"rating"]floatValue];
            cell.starRatingView.value = rating;
            cell.starRatingView.userInteractionEnabled = FALSE;
            cell.starRatingView.allowsHalfStars = YES;
            cell.starRatingView.tintColor = COLOR_ORANGE;
            cell.lbltripName.text = [obj valueForKey:@"user_trip_name"];
            cell.lblTotalDays.text = [NSString stringWithFormat:@"%@ Days",[obj valueForKey:@"days"]];
            cell.lblDateDuration.text = [NSString stringWithFormat:@"%@ - %@",[obj valueForKey:@"start_date"],[obj valueForKey:@"end_date"]];
            
            cell.btnSaveTrip.tag = indexPath.row;
            cell.btnViewInfo.tag = indexPath.row;
            cell.btnViewTrip.tag = indexPath.row;
            [cell.btnSaveTrip addTarget:self action:@selector(pressSaveTrip:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnViewInfo addTarget:self action:@selector(pressViewInfoOfTrip:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnViewTrip addTarget:self action:@selector(pressViewTrip:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnViewForum.tag = indexPath.row;
            [cell.btnViewForum addTarget:self action:@selector(pressViewTripForum:) forControlEvents:UIControlEventTouchUpInside];

            cell.tag = indexPath.row;
            cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WS_IMAGE_PATH_CITY,[obj valueForKey:@"image"]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                cell.imgView.image = image;
                            });
                        }
                    }
                    else
                    {
                        cell.imgView.image = [UIImage imageNamed:@"Image_Loading"];
                    }
                }];
                [task resume];
                
            });
        
        if(([indexPath row] == _arrData.count-1)&& isLastElement==false)
        {
            //if(noOfPage<=total_page)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadPlannedItineraryDetails:noOfPage :strCountryIdSelected];
                });
            }
        }

            return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"identifier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [[arrCountryNames valueForKey:@"country_name"] objectAtIndex:indexPath.row];
        return cell;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isSortingDone==TRUE)
        return 44;
    if(isSortingDone==FALSE)
        return 180;
    else
        return 0;
}

//-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
//    {
//        if(noOfPage<=total_page)
//        {
//            //[tableView beginUpdates];
//            [self loadPlannedItineraryDetails:noOfPage :@""];
//            //[tableView endUpdates];
//        }
//    }
//}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSortingDone==TRUE)
    {
        NSObject *obj = [arrCountryNames objectAtIndex:indexPath.row];
        lblCityName.text = [obj valueForKey:@"country_name"];
        isSortingDone = FALSE;
        isLastElement = false;
        viewCityWiseSorting.hidden = TRUE;
        [_arrData removeAllObjects];
        noOfPage = 1;
        strCountryIdSelected = [obj valueForKey:@"id"];
        [self loadPlannedItineraryDetails:1 :strCountryIdSelected];
    }
}

-(IBAction)pressDoneCountrySelection:(id)sender
{
    viewCityWiseSorting.hidden = TRUE;

}

#pragma mark- ==== WebServiceMethod =======
-(void)savePlannedItinerary :(NSString*)strItineraryId
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    strItineraryId,@"itirnaryid",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_SAVE_COPY_ITINERARIES dicParams:Parameters];
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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:strMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    //do something when click button
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
                
                noOfPage = 1;
                [_arrData removeAllObjects];
                total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                [self loadPlannedItineraryDetails:noOfPage :strCountryIdSelected];
                [tblViewItinerary reloadData];
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
}//a8ad45add63738a01e764bd8264d2663079b8f8f

-(void)loadPlannedItineraryDetails : (int)noPage :(NSString*)countryId
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [Helper getPREF:PREF_UID],@"userid",
                                    [NSString stringWithFormat:@"%d",noPage],@"pageno",
                                    countryId,@"country_id",
                                    nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_ITINERARIES_LIST dicParams:Parameters];
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
                HIDE_AI;
                [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                self->total_page = [[dicResponce valueForKey:@"total_page"] intValue];
                if(noOfPage==1)
                {
                    arrCountryNames = [dicResponce valueForKey:@"countries"];
                    [arrCountryNames insertObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All Country",@"country_name",@"",@"id", nil] atIndex:0];
                }
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
                NSLog(@"%@",_arrData);
                if(noOfPage<=total_page)
                    noOfPage+=1;
                [tblViewItinerary reloadData];
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


-(void)WSgetTripDetails : (NSString*)strSlug
{
    @try{
        SHOW_AI;
        NSDictionary *Parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strSlug,@"trip",nil];
        
        WSFrameWork *wsLogin = [[WSFrameWork alloc]initWithURLAndParams:WS_GET_ITINERARIES_DETAILS dicParams:Parameters];
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
               // [Helper setPREF:[dictData valueForKey:@"uniqueid"] :@"strTokenId"];
                
                if([[dictData valueForKey:@"trip_type"]intValue]==1||[[dictData valueForKey:@"trip_type"]intValue]==2)
                {
                    [self performSegueWithIdentifier:@"segueViewItinerary" sender:self];
                }
                if([[dictData valueForKey:@"trip_type"]intValue]==3)
                {
                    [self performSegueWithIdentifier:@"segueViewItinerary" sender:self];
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
    if([[segue identifier] isEqualToString:@"segueShowForumForItinerary"])
    {
        ForumListWithRatingVC *detail = (ForumListWithRatingVC *)[segue destinationViewController];
        detail.strItineraryId = strItineraryIdSelected;
        detail.strTripSelected = strTripSelected;
        detail.strTripOwnerId = strTripOwnerId;
    }
    if([[segue identifier] isEqualToString:@"segueViewItinerary"])
    {
        CitySwipeViewVC *detail = (CitySwipeViewVC *)[segue destinationViewController];
        detail.dictSearchData = dictData;
        detail.isFromEditTrip = TRUE;
        detail.strItineraryIdSelected = self.strItineraryIdSelected;
        detail.strTripType = [dictData valueForKey:@"trip_type"];
        [Helper setPREFint:1 :@"isFromViewItinerary"];
    }

    //
}



@end
